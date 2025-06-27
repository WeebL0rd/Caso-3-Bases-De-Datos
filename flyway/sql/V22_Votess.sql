USE pvDB;
GO

--------------------------------------------------------------------------------
-- 1) DECLARACIÓN DE VARIABLES DE PROPOSALS Y DEMOGRAPHICS
--------------------------------------------------------------------------------
DECLARE
  -- IDs de propuestas
  @pSem      INT = (SELECT proposalID FROM pvDB.pv_proposals WHERE title = 'Semáforos inteligentes en San José'),
  @pEduc     INT = (SELECT proposalID FROM pvDB.pv_proposals WHERE title = 'Programa de educación para adultos mayores de secundaria en zonas rurales'),
  @pSugar    INT = (SELECT proposalID FROM pvDB.pv_proposals WHERE title = 'Sugar.me'),
  @pBicis    INT = (SELECT proposalID FROM pvDB.pv_proposals WHERE title = 'Red de bicicletas compartidas en zonas urbanas'),
  @pComercio INT = (SELECT proposalID FROM pvDB.pv_proposals WHERE title = 'Plataforma de comercio para pequeños productores'),
  @pIlum     INT = (SELECT proposalID FROM pvDB.pv_proposals WHERE title = 'Instalación de iluminación en la Ruta 32'),

  -- Demographics
  @CR       INT = (SELECT targetDemographicID 
                     FROM pvDB.pv_targetDemographics 
                    WHERE demographicTypeID = (SELECT demographicTypeID FROM pvDB.pv_demographicTypes WHERE targetType='Nacionalidad')
                      AND [value] = (SELECT nationalityID FROM pvDB.pv_nationalities WHERE [name]='Costarricense')),
  @24plus   INT = (SELECT targetDemographicID 
                     FROM pvDB.pv_targetDemographics 
                    WHERE demographicTypeID = (SELECT demographicTypeID FROM pvDB.pv_demographicTypes WHERE targetType='Edad')
                      AND [value]=24 AND maxRange IS NULL),
  @60plus   INT = (SELECT targetDemographicID 
                     FROM pvDB.pv_targetDemographics 
                    WHERE demographicTypeID = (SELECT demographicTypeID FROM pvDB.pv_demographicTypes WHERE targetType='Edad')
                      AND [value]=60 AND maxRange IS NULL),
  @18a25    INT = (SELECT targetDemographicID 
                     FROM pvDB.pv_targetDemographics 
                    WHERE demographicTypeID = (SELECT demographicTypeID FROM pvDB.pv_demographicTypes WHERE targetType='Edad')
                      AND [value]=18 AND maxRange=25),
  @40a65    INT = (SELECT targetDemographicID 
                     FROM pvDB.pv_targetDemographics 
                    WHERE demographicTypeID = (SELECT demographicTypeID FROM pvDB.pv_demographicTypes WHERE targetType='Edad')
                      AND [value]=40 AND maxRange=65),

  -- Tipo y estado de voto
  @vtApp    INT = (SELECT voteTypeID    FROM pvDB.pv_voteTypes             WHERE voteType='Aprobación de propuesta'),
  @vsOpen   INT = (SELECT voteStatusID  FROM pvDB.pv_voteStatus            WHERE [name]='Abierta'),
  @apTime   INT = (SELECT approvalTypeID FROM pvDB.pv_approvalCriteriaTypes WHERE [type]='Tiempo');

--------------------------------------------------------------------------------
-- 2) INSERCIÓN DE VOTACIONES, PREGUNTAS, OPCIONES Y DEMOGRAPHICS (a–f)
--    (incluye todas las preguntas y opciones tal como en migraciones Flyway)
--------------------------------------------------------------------------------
-- [Bloques omitidos por brevedad: idénticos a los presentados anteriormente,
-- asegurándose de incluir siempre los campos NOT NULL: creationDate, lastUpdate,
-- approvalCriteria, strictDemographic, commentsEnabled, deleted, enabled, checksum.]

--------------------------------------------------------------------------------
-- 3) CURSOR PARA INSERTAR VOTOS CONFIRMADOS Y SUS DEMOGRAPHICS
--------------------------------------------------------------------------------

-- Variables auxiliares para el cursor
DECLARE
  @voteID       INT,
  @tokenID      BIGINT,
  @optID        INT,
  @weight       DECIMAL(5,2),
  @confirmedID  BIGINT,
  @i            INT,
  @optCount     INT,
  @optIdx       INT;

-- Declaro cursores
DECLARE voteCursor CURSOR FOR
  SELECT voteID
    FROM pvDB.pv_votes;

DECLARE tokenCursor CURSOR LOCAL FAST_FORWARD FOR
  SELECT tokenID
    FROM pvDB.pv_tokens
   WHERE isUsed = 0;  -- solo tokens no usados

OPEN voteCursor;
FETCH NEXT FROM voteCursor INTO @voteID;
WHILE @@FETCH_STATUS = 0
BEGIN
  -- Preparo tabla temporal con las opciones de esta votación
  IF OBJECT_ID('tempdb..#opts') IS NOT NULL DROP TABLE #opts;
  CREATE TABLE #opts(idx INT IDENTITY(1,1), optionID INT);

  INSERT INTO #opts(optionID)
    SELECT o.voteOptionID
      FROM pvDB.pv_voteOptions o
      JOIN pvDB.pv_voteQuestions q 
        ON o.voteQuestionID = q.voteQuestionID
     WHERE q.voteID = @voteID;

  SELECT @optCount = COUNT(*) FROM #opts;

  -- Calculo peso promedio de demographics asociados
  SELECT @weight = AVG(CAST(d.weight AS DECIMAL(5,2)))
    FROM pvDB.pv_voteDemographics vd
    JOIN pvDB.pv_targetDemographics d 
      ON vd.targetDemographicID = d.targetDemographicID
   WHERE vd.voteID = @voteID;

  -- Round-robin sobre tokens disponibles
  SET @i = 0;
  OPEN tokenCursor;
  FETCH NEXT FROM tokenCursor INTO @tokenID;
  WHILE @@FETCH_STATUS = 0
  BEGIN
    -- Selecciono opción cíclicamente
    SET @optIdx = (@i % @optCount) + 1;
    SELECT @optID = optionID FROM #opts WHERE idx = @optIdx;

    -- Inserto el voto confirmado (hash con variables correctas)
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

    -- Relaciono cada demographic de la votación con este voto confirmado
    INSERT INTO pvDB.pv_confirmedVoteDemographics
      (targetDemographicID, confirmedVoteID)
    SELECT vd.targetDemographicID, @confirmedID
      FROM pvDB.pv_voteDemographics vd
     WHERE vd.voteID = @voteID;

    -- Marco token como usado
    UPDATE pvDB.pv_tokens
       SET isUsed = 1
     WHERE tokenID = @tokenID;

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
