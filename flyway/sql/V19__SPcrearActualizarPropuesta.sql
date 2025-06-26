use pvDB;
-----------------------------------------------------------
-- crearActualizarPropuesta
-----------------------------------------------------------
GO
CREATE PROCEDURE [pvDB].crearActualizarPropuesta
	@proposalID INT,             -- El ID de la propuesta a actualizar, puede ser NULO para una creación de propuesta
	@isUser BIT,                 -- Un bit para identificar si se trata el usuario como organizacion o no
	@userID INT,                 -- El usuario que realiza la modificación
	@organizationID INT,         -- El ID de la organizacion en caso de que isUser = 0
	@proposalTitle VARCHAR(75),  -- El nuevo titulo de la propuesta
	@proposalDesc VARCHAR(300),  -- La nueva descripcion de la propuesta
	@proposalType VARCHAR(30),   -- El tipo de propuesta
	@proposalComments BIT,       -- Un bit que determina si la propuesta permite comentarios o no
	@documents NVARCHAR(MAX),    -- Un json para insertar todos los datos de los documentos
	@demographics NVARCHAR(MAX), -- Un json para insertar todas las demograficas objetivo
	@ResultMessage VARCHAR(100) OUTPUT        -- Mensaje de retroalimentacion
AS 
BEGIN
	SET NOCOUNT ON
	
	DECLARE @ErrorNumber INT, @ErrorSeverity INT, @ErrorState INT, @CustomError INT
	DECLARE @Message VARCHAR(200)
	DECLARE @InicieTransaccion BIT
	DECLARE @logTypeID INT
	DECLARE @logSourceID INT
	DECLARE @logSeverityID INT
	DECLARE @logChecksum VARBINARY(250)
	-- Variables personalizadas para la transaccion
	SET @proposalID = (SELECT proposalID FROM pvDB.pv_proposals WHERE proposalID = @proposalID) -- si regresa NULL es creacion
	DECLARE @statusPend SMALLINT = (SELECT proposalStatusID FROM pvDB.pv_proposalStatus WHERE [name] = 'Pendiente de validacion')
	DECLARE @statusObso SMALLINT = (SELECT proposalStatusID FROM pvDB.pv_proposalStatus WHERE [name] = 'Obsoleto')
	DECLARE @proposalTypeID SMALLINT = (SELECT proposalTypeID FROM pvDB.pv_proposalTypes WHERE [type] = @proposalType)
	IF @proposalTypeID IS NULL 
        THROW 50101, 'El tipo de propuesta indicada no existe', 1;
	DECLARE @userName VARCHAR(200)
	DECLARE @owningEntity INT
	IF @userID = 1
		SET @owningEntity = (SELECT owningEntityTypeID FROM pvDB.pv_owningEntityTypes WHERE [owningEntityTypeName] = 'Usuario');
	ELSE
		SET @owningEntity = (SELECT owningEntityTypeID FROM pvDB.pv_owningEntityTypes WHERE [owningEntityTypeName] = 'Organización');
	DECLARE @workflowType INT = (SELECT workflowTypeID FROM pvDB.pv_workflowTypes WHERE [type] = 'Verificación de Documento de Propuesta')
	-- Variables de actualizacion
	DECLARE @lastProposalID INT
	DECLARE @numVersion INT
	DECLARE @currentVersion VARCHAR(10)
	DECLARE @initialProposal INT
	-- Tabla temporal en memoria para insertar todas las demograficas
	DECLARE @tablaTempDemo TABLE (
	t_tempDemoid INT IDENTITY(1,1),
    t_value NVARCHAR(70),
    t_maxRange DECIMAL(5,2),
	t_demographicTypeID INT,
	t_weight DECIMAL(5,2),
	t_targetDemoID INT
	)
	BEGIN TRY
		INSERT INTO @tablaTempDemo (t_value, t_maxRange, t_demographicTypeID, t_weight) -- Se lee el JSON y se inserta en tabla temporal
		SELECT [value], maxRange, demographicTypeID, [weight]
		FROM OPENJSON(@demographics)
		WITH (
		  [value] NVARCHAR(70) '$.value',
		  maxRange DECIMAL(5,2) '$.maxRange',
		  demographicType VARCHAR(60) '$.demographicType',
		  [weight] DECIMAL(5,2) '$.weight'
		) AS demoJSON
		INNER JOIN pvDB.pv_demographicTypes ON pv_demographicTypes.targetType = demoJSON.demographicType
	END TRY
	BEGIN CATCH
		THROW 50102, 'Error al convertir el JSON de demografias.', 2
	END CATCH
	DECLARE @mapeoTargetDemo TABLE ( -- Esta tabla nos será util para relacionar los ID de los mediafiles con los documentos respectivos
		t_fila INT IDENTITY(1,1),
		t_targetDemoID INT
	)
	-- Tabla temporal en memoria para insertar todos los documentos
	DECLARE @tablaTempDocs TABLE (
	t_tempDocid INT IDENTITY(1,1),    -- se agrega un index para encriptar el URL mas adelante
    t_nombreArchivo NVARCHAR(250),
    t_documentURL VARCHAR(255),
	t_mediaTypeID INT,
	t_documentTypeID INT,
	t_renewalDays INT,
	t_mediaFileID INT NULL,
	t_workflowID INT NULL,
	t_documentURLCifrada VARBINARY(600)
	)
	BEGIN TRY
		INSERT INTO @tablaTempDocs (t_nombreArchivo, t_documentURL, t_mediaTypeID, t_documentTypeID, t_renewalDays) -- Se lee el JSON y se inserta en tabla temporal
		SELECT nombreArchivo, documentURL, mediaTypeID, documentTypeID, daysUntilRenewal
		FROM OPENJSON(@documents)
		WITH (
		  nombreArchivo NVARCHAR(250) '$.nombreArchivo',
		  documentURL VARCHAR(255) '$.documentURL',
		  mediaType VARCHAR(100) '$.mediaType',
		  documentType VARCHAR(100) '$.documentType'
		) AS docsJSON
		INNER JOIN pvDB.pv_mediaTypes ON pv_mediaTypes.[type] = docsJSON.mediaType
		INNER JOIN pvDB.pv_documentTypes ON pv_documentTypes.documentType = docsJSON.documentType
	END TRY
	BEGIN CATCH
		THROW 50103, 'Error al convertir el JSON de documentos.', 3
	END CATCH

	DECLARE @i INT = 1;
	DECLARE @max INT = (SELECT MAX(t_tempDocid) FROM @tablaTempDocs)
	DECLARE @inputUrl VARCHAR(255)
	DECLARE @cifrada VARBINARY(600)
	WHILE @i <= @max -- ciclo para recorrer todos los documentos
	BEGIN
		SELECT @inputUrl = t_documentURL
		FROM @tablaTempDocs
		WHERE t_tempDocid = @i;
		-- Funcion de cifrado
		EXEC pvDB.sp_CifrarDato @userID, @owningEntity, @inputUrl, @cifrada OUTPUT;
		-- Se actualiza el campo del url cifrado
		UPDATE @tablaTempDocs
		SET t_documentURLCifrada = @cifrada
		WHERE t_tempDocid = @i;

		SET @i += 1;
	END

	DECLARE @mapeoMediaFile TABLE ( -- Esta tabla nos será util para relacionar los ID de los mediafiles con los documentos respectivos
    t_fila INT IDENTITY(1,1),
    t_mediaFileID INT
	)

	DECLARE @mapeoWorkflows TABLE ( -- Igual pero para los ID de los workflows
    t_fila INT IDENTITY(1,1),
    t_workflowID INT
	)
	-- -------------------
	-- Iniciar transaccion
	SET @InicieTransaccion = 0
	IF @@TRANCOUNT=0 BEGIN
		SET @InicieTransaccion = 1
		SET TRANSACTION ISOLATION LEVEL READ COMMITTED
		BEGIN TRANSACTION		
	END
	BEGIN TRY
		IF @proposalID IS NULL        --se revisa si la transaccion es de CREACION
			BEGIN
				-- Se inserta la propuesta
				INSERT INTO pvDB.pv_proposals (proposalTypeID, proposalStatusID, title, [description], creationDate, lastUpdate, currentProposal, [version], enableComments) VALUES 
				(@proposalTypeID, @statusPend, @proposalTitle, @proposalDesc, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 1, '1.0', @proposalComments)
				SET @proposalID = SCOPE_IDENTITY()
				--
				UPDATE pvDB.pv_proposals
				SET [checksum] = HASHBYTES('SHA2_256', CONCAT(proposalTypeID, proposalStatusID, title, [description], creationDate, lastUpdate, [version]))
				WHERE proposalID = @proposalID
				-- Se actualiza el historial
				INSERT INTO pvDB.pv_proposalRecords (lastProposalID, currentProposalID) VALUES
				(@proposalID, @proposalID)
				
			END
		ELSE -- ACTUALIZACION
			BEGIN
				-- Se crea una estructura Common Table Expression para conseguir todo el historial de cambios
				WITH Historial AS (
					SELECT proposalID, currentProposal, lastProposalID, currentProposalID
					FROM pvDB.pv_proposals
					LEFT JOIN pvDB.pv_proposalRecords ON pvDB.pv_proposals.proposalID = pvDB.pv_proposalRecords.lastProposalID
					WHERE proposalID = @proposalID
					UNION ALL -- Union de todos los registros hasta encontrar currentProposal = 1
					SELECT p.proposalID, p.currentProposal, r.lastProposalID, r.currentProposalID
					FROM pvDB.pv_proposals p
					INNER JOIN pvDB.pv_proposalRecords r ON p.proposalID = r.currentProposalID
					INNER JOIN Historial h ON r.lastProposalID = h.proposalID WHERE p.proposalID <> h.proposalID)
				SELECT TOP 1 @lastproposalID = proposalID FROM Historial WHERE currentProposal = 1 ORDER BY proposalID DESC
				SET @currentVersion = (SELECT [version] FROM pvDB.pv_proposals WHERE proposalID = @lastProposalID)
				SET @numVersion = CHARINDEX('.', @currentVersion)
				SET @currentVersion = CAST(CAST(SUBSTRING(@currentVersion, 1, @numVersion - 1) AS INT) + 1 AS VARCHAR) + '.0'
				
				-- Actualiza los datos de la version anterior de la propuesta
				UPDATE pvDB.pv_proposals
				SET proposalStatusID = @statusObso,
					lastUpdate = CURRENT_TIMESTAMP,
					currentProposal = 0
				WHERE proposalID = @lastProposalID
				-- Elimina el registro del historial con datos repetidos
				SELECT @initialProposal = proposalRecordID FROM pvDB.pv_proposalRecords WHERE lastProposalID = @lastProposalID AND currentProposalID = @lastProposalID
				IF @proposalID IS NOT NULL 
					DELETE FROM pvDB.pv_proposalRecords WHERE proposalRecordID = @initialProposal;
				-- Se inserta la nueva version de la propuesta
				INSERT INTO pvDB.pv_proposals (proposalTypeID, proposalStatusID, title, [description], creationDate, lastUpdate, currentProposal, [version], enableComments) VALUES 
				(@proposalTypeID, @statusPend, @proposalTitle, @proposalDesc, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 1, @currentVersion, @proposalComments)
				SET @proposalID = SCOPE_IDENTITY()
				-- 
				UPDATE pvDB.pv_proposals
				SET [checksum] = HASHBYTES('SHA2_256', CONCAT(proposalTypeID, proposalStatusID, title, [description], creationDate, lastUpdate, [version]))
				WHERE proposalID = @proposalID
				-- Se actualiza el historial
				INSERT INTO pvDB.pv_proposalRecords (lastProposalID, currentProposalID) VALUES
				(@lastProposalID, @proposalID)
			END
			-- Se insertan las demografias
			INSERT INTO pvDB.pv_targetDemographics ([value], maxRange, [enabled], demographicTypeID, [weight]) 
			OUTPUT inserted.targetDemographicID INTO @mapeoTargetDemo(t_targetDemoID)
			SELECT t_value, t_maxRange, 1, t_demographicTypeID, t_weight FROM @tablaTempDemo ORDER BY t_tempDemoid
			UPDATE @tablaTempDemo
			SET t_targetDemoID = map.t_targetDemoID
			FROM @tablaTempDemo ttd
			INNER JOIN @mapeoTargetDemo map ON ttd.t_tempDemoid = map.t_fila;
			
			INSERT INTO pvDB.pv_proposalDemographics(proposalID, targetDemographicID, creationDate, deleted)
			SELECT @proposalID, t_targetDemoID, GETDATE(), 0 FROM @tablaTempDemo

			-- Se insertan los documentos
			INSERT INTO pvDB.pv_mediaFile(encryptedUrl, mediaTypeID) 
			OUTPUT inserted.mediaFileID INTO @mapeoMediaFile(t_mediaFileID)
			SELECT t_documentURLCifrada, t_mediaTypeID FROM @tablaTempDocs ORDER BY t_tempDocid
			UPDATE @tablaTempDocs
			SET t_mediaFileID = map.t_mediaFileID
			FROM @tablaTempDocs ttd
			INNER JOIN @mapeoMediaFile map ON ttd.t_tempDocid = map.t_fila;

			INSERT INTO pvDB.pv_documents(documentTypeID, mediaFileID, documentStatusID, nombreArchivo, uploadDate, deleted, version, renewalDate)
			SELECT t_documentTypeID, t_mediaFileID, 1, t_nombreArchivo, GETDATE(), 0, '1.0', DATEADD(day, t_renewalDays, GETDATE()) FROM @tablaTempDocs

			-- Se insertan los workflows para enviar a validar los documentos
			INSERT INTO pvDB.pv_workflows ([name], [description], endpointUrl, [enabled], workflowTypeID) 
			OUTPUT inserted.workflowID INTO @mapeoWorkflows(t_workflowID)
			SELECT 'Flujo de Verificación de Propuesta', 'Archivo ' + t_nombreArchivo + ' para la propuesta ' + @proposalTitle, ' ', 1, @workflowType FROM @tablaTempDocs ORDER BY t_tempDocid
			UPDATE @tablaTempDocs
			SET t_workflowID = map.t_workflowID
			FROM @tablaTempDocs ttd
			INNER JOIN @mapeoWorkflows map ON ttd.t_tempDocid = map.t_fila;

			INSERT INTO pvDB.pv_workflowHeaders (workflowID, [name], [value]) SELECT
			t_workflowID, t_nombreArchivo, 'Pendiente de revisión' FROM @tablaTempDocs

			IF @isUser = 1
				BEGIN
				INSERT INTO pvDB.pv_UserProposals (proposalID, userID) VALUES (@proposalID, @userID)
				END
			ELSE
				BEGIN
				INSERT INTO pvDB.pv_organizationProposals (proposalID, organizationID) VALUES (@proposalID, @organizationID)
				END

		IF @InicieTransaccion=1 BEGIN
			SET @logTypeID = (SELECT logTypesID FROM pvDB.pv_logTypes WHERE [name] = 'Actualización de Datos')
			SET @logSourceID = (SELECT logSourcesID FROM pvDB.pv_logSources WHERE [name] = 'Servicio de Usuarios')
			SET @logSeverityID = (SELECT logSeverityID FROM pvDB.pv_logsSeverity WHERE [name] = 'Informativo')

			SELECT @userName = [name] + lastName FROM pvDB.pv_users WHERE userID = @userID
			SET @logChecksum = HASHBYTES('SHA2_256', CONCAT('Cambios en las propuestas', CURRENT_TIMESTAMP, 'PC de ' + @userName, @userName, NULL, @proposalID, @lastProposalID, @proposalID, @logSeverityID, @logTypeID, @logSourceID))

			INSERT INTO pvDB.pv_logs ([description], postTime, computer, username, trace, referenceId1, referenceId2, value1, value2, [checksum], logSeverityID, logTypesID, logSourcesID) SELECT
			'Cambios en las propuestas', CURRENT_TIMESTAMP, 'PC de ' + @userName, @userName, '', NULL, @proposalID, @lastProposalID, @proposalID, @logChecksum, @logSeverityID, @logTypeID, @logSourceID
			SET @ResultMessage = 'Se ha insertado ' + @proposalTitle + ' con exito' 
			COMMIT
		END
	END TRY
	BEGIN CATCH
		
		SET @ErrorNumber = ERROR_NUMBER()
		SET @ErrorSeverity = ERROR_SEVERITY()
		SET @ErrorState = ERROR_STATE()
		SET @Message = ERROR_MESSAGE()
		SET @ResultMessage = @Message
		
		IF @InicieTransaccion=1 BEGIN
			ROLLBACK
		END
		SET @logTypeID = (SELECT logTypesID FROM pvDB.pv_logTypes WHERE [name] = 'Error del Sistema')
		SET @logSourceID = (SELECT logSourcesID FROM pvDB.pv_logSources WHERE [name] = 'Backend General')
		SET @logSeverityID = (SELECT logSeverityID FROM pvDB.pv_logsSeverity WHERE [name] = 'Error')

		IF @userID IS NOT NULL	
		BEGIN
			SELECT @userName = [name] + lastName FROM pvDB.pv_users WHERE userID = @userID
			SET @logChecksum = HASHBYTES('SHA2_256', CONCAT('Error al crear o actualizar propuesta', CURRENT_TIMESTAMP, 'PC de ' + @userName, @userName, 50100, @ErrorNumber, @Message, @logSeverityID, @logTypeID, @logSourceID))
			INSERT INTO pvDB.pv_logs ([description], postTime, computer, username, trace, referenceId1, referenceId2, value1, value2, [checksum], logSeverityID, logTypesID, logSourcesID) SELECT
			'Error al crear o actualizar propuesta', CURRENT_TIMESTAMP, 'PC de ' + @userName, @userName, '', 50100, @ErrorNumber, @Message, NULL, @logChecksum, @logSeverityID, @logTypeID, @logSourceID
		END

		RAISERROR('%s - Error Number: %i', @ErrorSeverity, @ErrorState, @Message, @CustomError) 
	END CATCH	
END
RETURN 0
GO

-- *******************
-- CONSULTA DE EJEMPLO
-- *******************
/*
DECLARE @docs NVARCHAR(MAX) = N'
[
  {
    "nombreArchivo": "Alcance Propuesta Ambiental.pdf",
    "documentURL": "https://miapp.com/docs/Alcance-Propuesta-Ambiental.pdf",
    "mediaType": "PDF",
	"documentType": "Documento de Propuesta"
  },
  {
    "nombreArchivo": "Beneficios de la propuesta.pdf",
    "documentURL": "https://miapp.com/docs/Beneficios-de-la-propuesta.pdf",
    "mediaType": "PDF",
	"documentType": "Documento de Propuesta"
  }
]';

DECLARE @demos NVARCHAR(MAX) = N'
[
  {
    "value": "1",
    "maxRange": null,
    "demographicType": "Sexo",
    "weight": 1.0
  },
  {
    "value": "25",
    "maxRange": 75,
    "demographicType": "Edad",
    "weight": 1.5
  }
]';

DECLARE @resultado VARCHAR (100);

EXEC [pvDB].crearActualizarPropuesta @proposalID = 5, @isUser = 1, @userID = 5, @organizationID = NULL, @proposalTitle = 'Iniciativa Comunidad Verde', @proposalDesc = 'Campaña de reciclaje y conciencia ambiental para barrios urbanos.',
 	@proposalType = 'Proyecto municipal', @proposalComments  = 0, @documents = @docs, @demographics = @demos, @ResultMessage = @resultado OUTPUT;;


DROP PROCEDURE IF EXISTS [pvDB].crearActualizarPropuesta;
*/
