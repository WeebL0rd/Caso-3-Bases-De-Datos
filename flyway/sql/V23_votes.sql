USE pvDB;
GO

-- 1) Declaro primero las variables escalares
DECLARE
  @voteID      INT,
  @tokenID     BIGINT,
  @optID       INT,
  @weight      DECIMAL(5,2),
  @confirmedID BIGINT,
  @i           INT,
  @optCount    INT,
  @optIdx      INT;

-- 2) Ahora declaro los cursores
DECLARE voteCursor CURSOR FOR
  SELECT voteID
    FROM pvDB.pv_votes;

DECLARE tokenCursor CURSOR LOCAL FAST_FORWARD FOR
  SELECT tokenID
    FROM pvDB.pv_tokens;

OPEN voteCursor;
FETCH NEXT FROM voteCursor INTO @voteID;
WHILE @@FETCH_STATUS = 0
BEGIN
  -- Preparo opciones de esta votación en tabla temporal
  IF OBJECT_ID('tempdb..#opts') IS NOT NULL DROP TABLE #opts;
  CREATE TABLE #opts (
    idx      INT IDENTITY(1,1) PRIMARY KEY,
    optionID INT
  );

  INSERT INTO #opts(optionID)
    SELECT o.voteOptionID
      FROM pvDB.pv_voteOptions o
      JOIN pvDB.pv_voteQuestions q 
        ON o.voteQuestionID = q.voteQuestionID
     WHERE q.voteID = @voteID;

  SELECT @optCount = COUNT(*) FROM #opts;

  -- Calculo peso promedio de demographics
  SELECT @weight = AVG(CAST(d.weight AS DECIMAL(5,2)))
    FROM pvDB.pv_voteDemographics vd
    JOIN pvDB.pv_targetDemographics d 
      ON vd.targetDemographicID = d.targetDemographicID
   WHERE vd.voteID = @voteID;

  -- Recorro todos los tokens y asigno opciones en round-robin
  SET @i = 0;
  OPEN tokenCursor;
  FETCH NEXT FROM tokenCursor INTO @tokenID;
  WHILE @@FETCH_STATUS = 0
  BEGIN
    SET @optIdx = (@i % @optCount) + 1;
    SELECT @optID = optionID FROM #opts WHERE idx = @optIdx;

    -- Inserto el voto confirmado
    INSERT INTO pvDB.pv_confirmedVotes
      (optionVoteID, weight, encryptedVote, tokenID, checksum)
    VALUES
      (
        @optID,
        @weight,
        HASHBYTES('SHA2_256', CONCAT(@tokenID, '-', @optID)),
        @tokenID,
        HASHBYTES('SHA2_256', CONCAT(@tokenID, @optID))
      );
    SET @confirmedID = SCOPE_IDENTITY();

    -- Asocio demographics de esta votación
    INSERT INTO pvDB.pv_confirmedVoteDemographics
      (targetDemographicID, confirmedVoteID)
    SELECT vd.targetDemographicID, @confirmedID
      FROM pvDB.pv_voteDemographics vd
     WHERE vd.voteID = @voteID;

    SET @i = @i + 1;
    FETCH NEXT FROM tokenCursor INTO @tokenID;
  END
  CLOSE tokenCursor;

  DROP TABLE #opts;
  FETCH NEXT FROM voteCursor INTO @voteID;
END

CLOSE voteCursor;
DEALLOCATE voteCursor;
DEALLOCATE tokenCursor;
GO

