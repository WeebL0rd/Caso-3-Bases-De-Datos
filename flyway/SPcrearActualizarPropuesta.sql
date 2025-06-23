use pvDB;
-----------------------------------------------------------
-- crearActualizarPropuesta
-----------------------------------------------------------
GO
CREATE PROCEDURE [pvDB].crearActualizarPropuesta
	@proposalID INT,
	
	@isUser BIT,
	@userID INT,
	@proposalTitle VARCHAR(75),
	@proposalDesc VARCHAR(300),
	@proposalType VARCHAR(30),
	@proposalComments BIT,
	@documents NVARCHAR(MAX),
	@demographics NVARCHAR(MAX)
AS 
BEGIN
	SET NOCOUNT ON
	
	DECLARE @ErrorNumber INT, @ErrorSeverity INT, @ErrorState INT, @CustomError INT
	DECLARE @Message VARCHAR(200)
	DECLARE @InicieTransaccion BIT
	-- Variables personalizadas para la transaccion
	SET @proposalID = (SELECT proposalID FROM pvDB.pv_proposals WHERE proposalID = @proposalID) -- si regresa NULL es creacion
	DECLARE @statusPend SMALLINT = (SELECT proposalStatusID FROM pvDB.pv_proposalStatus WHERE [name] = 'Pendiente de validacion')
	DECLARE @statusObso SMALLINT = (SELECT proposalStatusID FROM pvDB.pv_proposalStatus WHERE [name] = 'Obsoleto')
	DECLARE @proposalTypeID SMALLINT = (SELECT proposalTypeID FROM pvDB.pv_proposalTypes WHERE [type] = @proposalType)
	IF @proposalTypeID IS NULL 
        THROW 50101, 'El tipo de propuesta indicada no existe', 1;
	-- Variables de actualizacion
	DECLARE @lastProposalID INT
	DECLARE @currentVersion VARCHAR(10)
	-- Tabla temporal en memoria para insertar todas las demograficas
	DECLARE @tablaTempDemo TABLE (
    t_value NVARCHAR(70),
    t_maxRange DECIMAL(5,2),
	t_demographicTypeID INT,
	t_weight DECIMAL(5,2)
	)
	BEGIN TRY
		INSERT INTO @tablaTempDemo (t_value, t_maxRange, t_demographicTypeID, t_weight) -- Se lee el JSON y se inserta en tabla temporal
		SELECT [value], maxRange, demographicTypeID, [weight]
		FROM OPENJSON(@demographics)
		WITH (
		  [value] NVARCHAR(70) '$.value',
		  maxRange DECIMAL(5,2) '$.maxRange',
		  demographicTypeID INT '$.demographicTypeID',
		  [weight] DECIMAL(5,2) '$.weight'
		)
	END TRY
	BEGIN CATCH
		THROW 50102, 'Error al convertir el JSON de demografias.', 2
	END CATCH

	-- Iniciar transaccion
	SET @InicieTransaccion = 0
	IF @@TRANCOUNT=0 BEGIN
		SET @InicieTransaccion = 1
		SET TRANSACTION ISOLATION LEVEL READ COMMITTED
		BEGIN TRANSACTION		
	END
	BEGIN TRY
		IF @proposalID IS NULL        --se revisa si la transaccion es de creacion o actualizacion
			BEGIN
				-- Se inserta la propuesta
				INSERT INTO pvDB.pv_proposals (proposalTypeID, proposalStatusID, title, [description], creationDate, lastUpdate, currentProposal, [version], enableComments) VALUES 
				(@proposalTypeID, @statusPend, @proposalTitle, @proposalDesc, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 1, '1.0', @proposalComments)
				SELECT @proposalID = SCOPE_IDENTITY()
				--
				UPDATE pvDB.pv_proposals
				SET [checksum] = HASHBYTES('SHA2_256', CONCAT(proposalTypeID, proposalStatusID, title, [description], creationDate, lastUpdate, [version]))
				WHERE proposalID = @proposalID
				-- Se actualiza el historial
				INSERT INTO pvDB.pv_proposalRecords (lastProposalID, currentProposalID) VALUES
				(@proposalID, @proposalID)
				-- Se insertan las demografias
				--INSERT INTO pv_targetDemographics (targetDemographicID, [value], maxRange, [enabled], demographicTypeID, demographicTypeID, [weight]) VALUES ()
				
			END
		ELSE
			BEGIN
				SET @lastProposalID = (SELECT proposalID FROM pvDB.pv_proposals WHERE proposalID = @proposalID)
				SET @currentVersion = (SELECT [version] FROM pvDB.pv_proposals WHERE proposalID = @lastProposalID)
				-- Actualiza los datos de la version anterior de la propuesta
				UPDATE pvDB.pv_proposals
				SET proposalStatusID = @statusObso,
					lastUpdate = CURRENT_TIMESTAMP,
					currentProposal = 0
				WHERE proposalID = @lastProposalID

				SET @currentVersion = CHARINDEX('.', @currentVersion) - 1
				SET @currentVersion = CAST(CAST(@currentVersion AS INT) + 1 AS VARCHAR) + '.0'
				-- Se inserta la nueva version de la propuesta
				INSERT INTO pvDB.pv_proposals (proposalTypeID, proposalStatusID, title, [description], creationDate, lastUpdate, currentProposal, [version], enableComments) VALUES 
				(@proposalTypeID, @statusPend, @proposalTitle, @proposalDesc, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 1, @currentVersion, @proposalComments)
				SELECT proposalID = SCOPE_IDENTITY()
				-- 
				UPDATE pvDB.pv_proposals
				SET [checksum] = HASHBYTES('SHA2_256', CONCAT(proposalTypeID, proposalStatusID, title, [description], creationDate, lastUpdate, [version]))
				WHERE proposalID = @proposalID
				-- Se actualiza el historial
				INSERT INTO pvDB.pv_proposalRecords (lastProposalID, currentProposalID) VALUES
				(@lastProposalID, @proposalID)


			END
		IF @InicieTransaccion=1 BEGIN
			COMMIT
		END
	END TRY
	BEGIN CATCH
		
		SET @ErrorNumber = ERROR_NUMBER()
		SET @ErrorSeverity = ERROR_SEVERITY()
		SET @ErrorState = ERROR_STATE()
		SET @Message = ERROR_MESSAGE()
		
		IF @InicieTransaccion=1 BEGIN
			ROLLBACK
		END
		--INSERT INTO pvDB.pv_logs ([description], postTime, computer, username, trace, referenceId1, referenceId2, value1, value2, [checksum], logSeverityID, logTypesID, logSourcesID) VALUES 
		--('Error al crear o actualizar propuesta', CURRENT_TIMESTAMP, )
		
		RAISERROR('%s - Error Number: %i', @ErrorSeverity, @ErrorState, @Message, @CustomError) 
	END CATCH	
END
RETURN 0
GO

DECLARE @docs NVARCHAR(MAX) = N'
[
  {
    "name": "Reglamento.pdf",
    "url": "https://miapp.com/docs/Reglamento.pdf",
    "type": "pdf"
  },
  {
    "name": "Volante.png",
    "url": "https://miapp.com/docs/Volante.png",
    "type": "image"
  }
]';

DECLARE @demos NVARCHAR(MAX) = N'
[
  {
    "value": "Mujer",
    "maxRange": null,
    "demographicTypeID": 1,
    "weight": 1.0
  },
  {
    "value": "25",
    "maxRange": 75,
    "demographicTypeID": 3,
    "weight": 1.5
  }
]';

-- EXEC [pvDB].crearActualizarPropuesta @proposalID = NULL, @isUser = 1, @userID = 5, @proposalTitle = 'Iniciativa Comunidad Verde', @proposalDesc = 'Campaña de reciclaje y conciencia ambiental para barrios urbanos.',
-- 	@proposalType = 'Proyecto municipal', @proposalComments  = 0, @documents = @docs, @demographics = @demos;

DROP PROCEDURE IF EXISTS [pvDB].crearActualizarPropuesta;
