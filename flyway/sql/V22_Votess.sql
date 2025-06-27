USE pvDB;
GO

<<<<<<< Updated upstream
--------------------------------------------------------------------------------
-- 1) DECLARACIÓN DE VARIABLES DE PROPOSALS Y DEMOGRAPHICS
--------------------------------------------------------------------------------
DECLARE
  -- IDs de propuestas
=======
SELECT * 
  FROM pvDB.pv_proposals;
--  Declaración de variables de propuestas y demographics
DECLARE
  -- Propuestas
>>>>>>> Stashed changes
  @pSem      INT = (SELECT proposalID FROM pvDB.pv_proposals WHERE title = 'Semáforos inteligentes en San José'),
  @pEduc     INT = (SELECT proposalID FROM pvDB.pv_proposals WHERE title = 'Programa de educación para adultos mayores de secundaria en zonas rurales'),
  @pSugar    INT = (SELECT proposalID FROM pvDB.pv_proposals WHERE title = 'Sugar.me'),
  @pBicis    INT = (SELECT proposalID FROM pvDB.pv_proposals WHERE title = 'Red de bicicletas compartidas en zonas urbanas'),
  @pComercio INT = (SELECT proposalID FROM pvDB.pv_proposals WHERE title = 'Plataforma de comercio para pequeños productores'),
<<<<<<< Updated upstream
  @pIlum     INT = (SELECT proposalID FROM pvDB.pv_proposals WHERE title = 'Instalación de iluminación en la Ruta 32'),
=======
  @pIlum     INT = (SELECT proposalID FROM pvDB.pv_proposals WHERE title = 'Aplicación para conocer Sugars'),
>>>>>>> Stashed changes

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

<<<<<<< Updated upstream
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
=======
-- ======================================================
-- a) Semáforos inteligentes en San José
-- ======================================================
DECLARE @v1 INT;
INSERT INTO pvDB.pv_votes (voteTypeID, voteStatusID, proposalID, approvalTypeID, topic, startDate, endDate)
VALUES (@vtApp,@vsOpen,@pSem,@apTime,'¿Apoya esta votación?',GETDATE(),DATEADD(DAY,7,GETDATE()));
SET @v1 = SCOPE_IDENTITY();

INSERT INTO pvDB.pv_voteQuestions(voteID,question,answerQuantity)
VALUES(@v1,'¿Apoya esta votación?',1);
DECLARE @q1 INT = SCOPE_IDENTITY();

INSERT INTO pvDB.pv_voteOptions(voteQuestionID,optionText,optionNumber)
VALUES (@q1,'Sí',1),(@q1,'No',2);

INSERT INTO pvDB.pv_voteDemographics(voteID,targetDemographicID)
VALUES (@v1,@CR),(@v1,@24plus);

DECLARE @v2 INT;
INSERT INTO pvDB.pv_votes (voteTypeID, voteStatusID, proposalID, approvalTypeID, topic, startDate, endDate)
VALUES (@vtApp,@vsOpen,@pSem,@apTime,
        '¿Dónde debería implementarse primero el sistema de semáforos inteligentes?',
        GETDATE(),DATEADD(DAY,7,GETDATE()));
SET @v2 = SCOPE_IDENTITY();

INSERT INTO pvDB.pv_voteQuestions(voteID,question,answerQuantity)
VALUES(@v2,'¿Dónde debería implementarse primero el sistema de semáforos inteligentes?',1);
DECLARE @q2 INT = SCOPE_IDENTITY();

INSERT INTO pvDB.pv_voteOptions(voteQuestionID,optionText,optionNumber)
VALUES 
  (@q2,'Paseo Colón y Avenida Segunda',1),
  (@q2,'Circunvalación y Hatillo',2),
  (@q2,'Sabana y alrededores',3),
  (@q2,'Moravia',4);

INSERT INTO pvDB.pv_voteDemographics(voteID,targetDemographicID)
VALUES (@v2,@CR),(@v2,@24plus);

DECLARE @v3 INT;
INSERT INTO pvDB.pv_votes (voteTypeID, voteStatusID, proposalID, approvalTypeID, topic, startDate, endDate)
VALUES (@vtApp,@vsOpen,@pSem,@apTime,
        '¿Qué tecnología adicional debería incluirse en los semáforos inteligentes?',
        GETDATE(),DATEADD(DAY,7,GETDATE()));
SET @v3 = SCOPE_IDENTITY();

INSERT INTO pvDB.pv_voteQuestions(voteID,question,answerQuantity)
VALUES(@v3,'¿Qué tecnología adicional debería incluirse en los semáforos inteligentes?',1);
DECLARE @q3 INT = SCOPE_IDENTITY();

INSERT INTO pvDB.pv_voteOptions(voteQuestionID,optionText,optionNumber)
VALUES 
  (@q3,'Sensores de tráfico en tiempo real',1),
  (@q3,'Cámaras de detección de infracciones',2),
  (@q3,'Integración con apps de navegación',3),
  (@q3,'No se necesita tecnología adicional',4);

INSERT INTO pvDB.pv_voteDemographics(voteID,targetDemographicID)
VALUES (@v3,@CR),(@v3,@24plus);

-- ======================================================
-- b) Programa de educación para adultos mayores
-- ======================================================
DECLARE @vB1 INT;
INSERT INTO pvDB.pv_votes (voteTypeID, voteStatusID, proposalID, approvalTypeID, topic, startDate, endDate)
VALUES (@vtApp,@vsOpen,@pEduc,@apTime,'¿Apoya esta propuesta?',GETDATE(),DATEADD(DAY,7,GETDATE()));
SET @vB1 = SCOPE_IDENTITY();

INSERT INTO pvDB.pv_voteQuestions(voteID,question,answerQuantity)
VALUES(@vB1,'¿Apoya esta propuesta?',1);
DECLARE @qB1 INT = SCOPE_IDENTITY();

INSERT INTO pvDB.pv_voteOptions(voteQuestionID,optionText,optionNumber)
VALUES (@qB1,'Sí',1),(@qB1,'No',2);

INSERT INTO pvDB.pv_voteDemographics(voteID,targetDemographicID)
VALUES (@vB1,@CR),(@vB1,@60plus);

DECLARE @vB2 INT;
INSERT INTO pvDB.pv_votes (voteTypeID, voteStatusID, proposalID, approvalTypeID, topic, startDate, endDate)
VALUES (@vtApp,@vsOpen,@pEduc,@apTime,
        '¿Se cumplieron los objetivos propuestos para los nuevos cursos en la zona de Cariari?',
        GETDATE(),DATEADD(DAY,7,GETDATE()));
SET @vB2 = SCOPE_IDENTITY();

INSERT INTO pvDB.pv_voteQuestions(voteID,question,answerQuantity)
VALUES(@vB2,'¿Se cumplieron los objetivos propuestos para los nuevos cursos en la zona de Cariari?',1);
DECLARE @qB2 INT = SCOPE_IDENTITY();

INSERT INTO pvDB.pv_voteOptions(voteQuestionID,optionText,optionNumber)
VALUES (@qB2,'Sí',1),(@qB2,'No',2);

INSERT INTO pvDB.pv_voteDemographics(voteID,targetDemographicID)
VALUES (@vB2,@CR),(@vB2,@60plus);

DECLARE @vB3 INT;
INSERT INTO pvDB.pv_votes (voteTypeID, voteStatusID, proposalID, approvalTypeID, topic, startDate, endDate)
VALUES (@vtApp,@vsOpen,@pEduc,@apTime,'¿Qué precio le gustaría ver para los cursos?',GETDATE(),DATEADD(DAY,7,GETDATE()));
SET @vB3 = SCOPE_IDENTITY();

INSERT INTO pvDB.pv_voteQuestions(voteID,question,answerQuantity)
VALUES(@vB3,'¿Qué precio le gustaría ver para los cursos?',1);
DECLARE @qB3 INT = SCOPE_IDENTITY();

INSERT INTO pvDB.pv_voteOptions(voteQuestionID,optionText,optionNumber)
VALUES 
  (@qB3,'₡10,000',1),
  (@qB3,'₡20,000',2),
  (@qB3,'₡30,000',3);

INSERT INTO pvDB.pv_voteDemographics(voteID,targetDemographicID)
VALUES (@vB3,@CR),(@vB3,@60plus);

DECLARE @vB4 INT;
INSERT INTO pvDB.pv_votes (voteTypeID, voteStatusID, proposalID, approvalTypeID, topic, startDate, endDate)
VALUES (@vtApp,@vsOpen,@pEduc,@apTime,
        '¿Está de acuerdo en que se complemente con fondos públicos para llegar a ₡2,000,000?',
        GETDATE(),DATEADD(DAY,7,GETDATE()));
SET @vB4 = SCOPE_IDENTITY();

INSERT INTO pvDB.pv_voteQuestions(voteID,question,answerQuantity)
VALUES(@vB4,'¿Está de acuerdo en que se complemente con fondos públicos para llegar a ₡2,000,000?',1);
DECLARE @qB4 INT = SCOPE_IDENTITY();

INSERT INTO pvDB.pv_voteOptions(voteQuestionID,optionText,optionNumber)
VALUES (@qB4,'Sí',1),(@qB4,'No',2);

INSERT INTO pvDB.pv_voteDemographics(voteID,targetDemographicID)
VALUES (@vB4,@CR),(@vB4,@60plus);

-- ======================================================
-- c) Sugar.me
-- ======================================================
DECLARE @vS1 INT;
INSERT INTO pvDB.pv_votes (voteTypeID, voteStatusID, proposalID, approvalTypeID, topic, startDate, endDate)
VALUES (@vtApp,@vsOpen,@pSugar,@apTime,'¿Está interesado en esta aplicación?',GETDATE(),DATEADD(DAY,7,GETDATE()));
SET @vS1 = SCOPE_IDENTITY();

INSERT INTO pvDB.pv_voteQuestions(voteID,question,answerQuantity)
VALUES(@vS1,'¿Está interesado en esta aplicación?',1);
DECLARE @qS1 INT = SCOPE_IDENTITY();

INSERT INTO pvDB.pv_voteOptions(voteQuestionID,optionText,optionNumber)
VALUES (@qS1,'Sí',1),(@qS1,'No',2);

INSERT INTO pvDB.pv_voteDemographics(voteID,targetDemographicID)
VALUES (@vS1,@18a25),(@vS1,@40a65);

DECLARE @vS2 INT;
INSERT INTO pvDB.pv_votes (voteTypeID, voteStatusID, proposalID, approvalTypeID, topic, startDate, endDate)
VALUES (@vtApp,@vsOpen,@pSugar,@apTime,'¿Qué nivel de privacidad deberían tener los perfiles?',GETDATE(),DATEADD(DAY,7,GETDATE()));
SET @vS2 = SCOPE_IDENTITY();

INSERT INTO pvDB.pv_voteQuestions(voteID,question,answerQuantity)
VALUES(@vS2,'¿Qué nivel de privacidad deberían tener los perfiles?',1);
DECLARE @qS2 INT = SCOPE_IDENTITY();

INSERT INTO pvDB.pv_voteOptions(voteQuestionID,optionText,optionNumber)
VALUES 
  (@qS2,'Básico',1),
  (@qS2,'Intermedio',2),
  (@qS2,'Alto',3);

INSERT INTO pvDB.pv_voteDemographics(voteID,targetDemographicID)
VALUES (@vS2,@18a25),(@vS2,@40a65);

DECLARE @vS3 INT;
INSERT INTO pvDB.pv_votes (voteTypeID, voteStatusID, proposalID, approvalTypeID, topic, startDate, endDate)
VALUES (@vtApp,@vsOpen,@pSugar,@apTime,'¿Apoya que la incubadora adopte el proyecto?',GETDATE(),DATEADD(DAY,7,GETDATE()));
SET @vS3 = SCOPE_IDENTITY();

INSERT INTO pvDB.pv_voteQuestions(voteID,question,answerQuantity)
VALUES(@vS3,'¿Apoya que la incubadora adopte el proyecto?',1);
DECLARE @qS3 INT = SCOPE_IDENTITY();

INSERT INTO pvDB.pv_voteOptions(voteQuestionID,optionText,optionNumber)
VALUES (@qS3,'Sí',1),(@qS3,'No',2);

INSERT INTO pvDB.pv_voteDemographics(voteID,targetDemographicID)
VALUES (@vS3,@18a25),(@vS3,@40a65);

DECLARE @vS4 INT;
INSERT INTO pvDB.pv_votes (voteTypeID, voteStatusID, proposalID, approvalTypeID, topic, startDate, endDate)
VALUES (@vtApp,@vsOpen,@pSugar,@apTime,
        '¿Destinar porcentaje de ingresos a mejoras? ¿Cuánto?',GETDATE(),DATEADD(DAY,7,GETDATE()));
SET @vS4 = SCOPE_IDENTITY();

INSERT INTO pvDB.pv_voteQuestions(voteID,question,answerQuantity)
VALUES(@vS4,'¿Destinar porcentaje de ingresos a mejoras? ¿Cuánto?',1);
DECLARE @qS4 INT = SCOPE_IDENTITY();

INSERT INTO pvDB.pv_voteOptions(voteQuestionID,optionText,optionNumber)
VALUES 
  (@qS4,'Sí – 5%',1),
  (@qS4,'Sí – 10%',2),
  (@qS4,'No',3);

INSERT INTO pvDB.pv_voteDemographics(voteID,targetDemographicID)
VALUES (@vS4,@18a25),(@vS4,@40a65);

-- ======================================================
-- d) Red de bicicletas compartidas
-- ======================================================
DECLARE @vB5 INT;
INSERT INTO pvDB.pv_votes (voteTypeID, voteStatusID, proposalID, approvalTypeID, topic, startDate, endDate)
VALUES (@vtApp,@vsOpen,@pBicis,@apTime,'¿Usa su bicicleta para movilizarse?',GETDATE(),DATEADD(DAY,7,GETDATE()));
SET @vB5 = SCOPE_IDENTITY();

INSERT INTO pvDB.pv_voteQuestions(voteID,question,answerQuantity)
VALUES(@vB5,'¿Usa su bicicleta para movilizarse?',1);
DECLARE @qB5 INT = SCOPE_IDENTITY();

INSERT INTO pvDB.pv_voteOptions(voteQuestionID,optionText,optionNumber)
VALUES 
  (@qB5,'Frecuentemente',1),
  (@qB5,'Muchas veces',2),
  (@qB5,'A veces',3),
  (@qB5,'Casi no',4),
  (@qB5,'No',5);

INSERT INTO pvDB.pv_voteDemographics(voteID,targetDemographicID)
VALUES (@vB5,@CR);

-- ======================================================
-- e) Plataforma de comercio para pequeños productores
-- ======================================================
DECLARE @vC1 INT;
INSERT INTO pvDB.pv_votes (voteTypeID, voteStatusID, proposalID, approvalTypeID, topic, startDate, endDate)
VALUES (@vtApp,@vsOpen,@pComercio,@apTime,'¿Apoya la creación de la plataforma?',GETDATE(),DATEADD(DAY,7,GETDATE()));
SET @vC1 = SCOPE_IDENTITY();

INSERT INTO pvDB.pv_voteQuestions(voteID,question,answerQuantity)
VALUES(@vC1,'¿Apoya la creación de la plataforma?',1);
DECLARE @qC1 INT = SCOPE_IDENTITY();

INSERT INTO pvDB.pv_voteOptions(voteQuestionID,optionText,optionNumber)
VALUES (@qC1,'Sí',1),(@qC1,'No',2);

INSERT INTO pvDB.pv_voteDemographics(voteID,targetDemographicID)
VALUES (@vC1,@CR);

DECLARE @vC2 INT;
INSERT INTO pvDB.pv_votes (voteTypeID, voteStatusID, proposalID, approvalTypeID, topic, startDate, endDate)
VALUES (@vtApp,@vsOpen,@pComercio,@apTime,'¿Qué comisión mínima pagarías?',GETDATE(),DATEADD(DAY,7,GETDATE()));
SET @vC2 = SCOPE_IDENTITY();

INSERT INTO pvDB.pv_voteQuestions(voteID,question,answerQuantity)
VALUES(@vC2,'¿Qué comisión mínima pagarías?',1);
DECLARE @qC2 INT = SCOPE_IDENTITY();

INSERT INTO pvDB.pv_voteOptions(voteQuestionID,optionText,optionNumber)
VALUES 
  (@qC2,'5%',1),
  (@qC2,'10%',2),
  (@qC2,'15%',3);

INSERT INTO pvDB.pv_voteDemographics(voteID,targetDemographicID)
VALUES (@vC2,@CR);

-- ======================================================
-- f) Instalación de iluminación en la Ruta 32
-- ======================================================
DECLARE @vI1 INT;
INSERT INTO pvDB.pv_votes (voteTypeID, voteStatusID, proposalID, approvalTypeID, topic, startDate, endDate)
VALUES (@vtApp,@vsOpen,@pIlum,@apTime,'¿Consideras necesaria la iluminación en la Ruta 32?',GETDATE(),DATEADD(DAY,7,GETDATE()));
SET @vI1 = SCOPE_IDENTITY();

INSERT INTO pvDB.pv_voteQuestions(voteID,question,answerQuantity)
VALUES(@vI1,'¿Consideras necesaria la iluminación en la Ruta 32?',1);
DECLARE @qI1	INT = SCOPE_IDENTITY();

INSERT INTO pvDB.pv_voteOptions(voteQuestionID,optionText,optionNumber)
VALUES (@qI1,'Sí',1),(@qI1,'No',2);

INSERT INTO pvDB.pv_voteDemographics(voteID,targetDemographicID)
VALUES (@vI1,@CR),(@vI1,@24plus);

DECLARE @vI2 INT;
INSERT INTO pvDB.pv_votes (voteTypeID, voteStatusID, proposalID, approvalTypeID, topic, startDate, endDate)
VALUES (@vtApp,@vsOpen,@pIlum,@apTime,'¿Crees que mejorará la seguridad vial?',GETDATE(),DATEADD(DAY,7,GETDATE()));
SET @vI2 = SCOPE_IDENTITY();

INSERT INTO pvDB.pv_voteQuestions(voteID,question,answerQuantity)
VALUES(@vI2,'¿Crees que mejorará la seguridad vial?',1);
DECLARE @qI2	INT = SCOPE_IDENTITY();

INSERT INTO pvDB.pv_voteOptions(voteQuestionID,optionText,optionNumber)
VALUES (@qI2,'Sí',1),(@qI2,'No',2);

INSERT INTO pvDB.pv_voteDemographics(voteID,targetDemographicID)
VALUES (@vI2,@CR),(@vI2,@24plus);

DECLARE @vI3 INT;
INSERT INTO pvDB.pv_votes (voteTypeID, voteStatusID, proposalID, approvalTypeID, topic, startDate, endDate)
VALUES (@vtApp,@vsOpen,@pIlum,@apTime,'¿Cuál debe ser el horario de funcionamiento?',GETDATE(),DATEADD(DAY,7,GETDATE()));
SET @vI3 = SCOPE_IDENTITY();

INSERT INTO pvDB.pv_voteQuestions(voteID,question,answerQuantity)
VALUES(@vI3,'¿Cuál debe ser el horario de funcionamiento?',1);
DECLARE @qI3 INT = SCOPE_IDENTITY();

INSERT INTO pvDB.pv_voteOptions(voteQuestionID,optionText,optionNumber)
VALUES 
  (@qI3,'24/7',1),
  (@qI3,'6pm–6am',2),
  (@qI3,'8pm–5am',3);

INSERT INTO pvDB.pv_voteDemographics(voteID,targetDemographicID)
VALUES (@vI3,@CR),(@vI3,@24plus);
>>>>>>> Stashed changes
GO
