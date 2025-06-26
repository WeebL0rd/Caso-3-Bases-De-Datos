USE pvDB;
GO

CREATE OR ALTER PROCEDURE [pvDB].[SP_Invertir]
	@CrowdfundingID INT,
	@UserToken VARCHAR(110),
	@UserSelectedPayMethodID INT,
	@CantidadInversion DECIMAL(18,5),
	@ResultMessage VARCHAR(100) OUTPUT,
	@ResultCode INT OUTPUT
AS 
BEGIN
	
	SET NOCOUNT ON
	
	DECLARE @ErrorNumber INT, @ErrorSeverity INT, @ErrorState INT, @CustomError INT
	DECLARE @Message VARCHAR(200)
	DECLARE @InicieTransaccion BIT

	-- Variables del crowdfundingEvent
	DECLARE @cfID INT;
	DECLARE @eventEquity DECIMAL(18,2);
	DECLARE @fundingGoal DECIMAL(18,3);
	DECLARE @startDate DATE;
	DECLARE @endDate DATE;
	DECLARE @crowdfundingStatusID TINYINT;
	DECLARE @currencyUsado INT;

	-- Variables del fundingProcess
	DECLARE @progressID INT;
	DECLARE @currentFunding DECIMAL(18,3);
	DECLARE @investors INT;

	SELECT @cfID = crowfundingID, @eventEquity = equity, @fundingGoal = fundingGoal, @startDate = startDate, @endDate = endDate, @crowdfundingStatusID = crowfundingStatusID, @currencyUsado = currency_id
	FROM pvDB.cf_crowfundingEvents
	WHERE crowfundingID = @CrowdfundingID;

	-- Básico: Verifica que exista el crowdfunding event
	IF @cfID IS NULL
	BEGIN
		SELECT @ResultMessage = 'El evento de crowdfunding no existe.';
		SELECT @ResultCode = 1;
		RETURN 
	END


	-- VALIDACIONES

	-- Validar si la propuesta está aprobada (Si no está en estado de revisión)
	DECLARE @IDStatusAprobado INT;
	SELECT @IDStatusAprobado = ps.proposalStatusID 
	FROM pvDB.pv_proposalStatus ps WHERE ps.name = 'Ejecutando';
	DECLARE @statusDePropuesta INT;
	
	IF NOT EXISTS (SELECT pp.proposalStatusID FROM pvDB.pv_proposals pp JOIN cf_crowfundingEvents ce ON pp.proposalID = ce.proposalID AND pp.proposalStatusID = @IDStatusAprobado
	WHERE crowfundingID = @CrowdfundingID)
	BEGIN
		SELECT @ResultMessage = 'La propuesta no está en estado de aprobación.';
		SELECT @ResultCode = 2;
		RETURN
	END


	-- Validar que el crowdfunding event a invertir está abierto (startDate < getdate() < endDate) y En curso
	DECLARE @statusEnCurso INT;
	SELECT @statusEnCurso = crowfundingStatusID FROM pvDB.pv_crowfundingStatuses WHERE "name" = 'En curso';
	
	IF NOT (@startDate < GETDATE() AND GETDATE() < @endDate AND @crowdfundingStatusID = @statusEnCurso)
	BEGIN
		SELECT @ResultMessage = 'El evento no está abierto para invertir.';
		SELECT @ResultCode = 3;
		RETURN
	END


	-- Validar si el token de usuario proporcionado es de una sesión activa de un usuario (Existe y no está vencida)
	DECLARE @userID INT

	SELECT @userID = userID 
	FROM pv_userSessions
	WHERE token = HASHBYTES('SHA2_256', @UserToken) AND expirationDate > GETDATE()

	IF @userID IS NULL
	BEGIN
		SELECT @ResultMessage = 'El usuario no fue encontrado o no tiene una sesión activa.';
		SELECT @ResultCode = 4;
		RETURN
	END

	-- Validar si el método de pago disponible del usuario sea válido y pertenezca al usuario
	IF NOT EXISTS (SELECT 1 FROM pvDB.pv_availablePayMethods WHERE GETDATE() < expToken AND userID = @userID AND available_method_id = @UserSelectedPayMethodID)
	BEGIN
		SELECT @ResultMessage = 'El método de pago proporcionado no es válido';
		SELECT @ResultCode = 5;
		RETURN
	END

	DECLARE @logSeverityInformativo INT;
	DECLARE @typeUpdate INT;
	DECLARE @SourceCrowdfunding INT;

	SELECT @logSeverityInformativo = logSeverityID FROM pvDB.pv_logsSeverity WHERE name = 'Informativo'
	SELECT @typeUpdate = logTypesID FROM pvDB.pv_logTypes WHERE name = 'Actualización de Inversión'
	SELECT @SourceCrowdfunding = logSourcesID FROM pvDB.pv_logSources WHERE name = 'Motor de Crowdfunding'
	
	SET @InicieTransaccion = 0
	IF @@TRANCOUNT=0 BEGIN
		SET @InicieTransaccion = 1
		SET TRANSACTION ISOLATION LEVEL REPEATABLE READ; -- Uso repeatable read para evitar la lectura no repetible de inversiones
		BEGIN TRANSACTION		
	END
	
	BEGIN TRY
		

		-- Obtengo los datos del progreso del crowdfunding 
		SELECT TOP 1 @progressID = progressID, @currentFunding = currentFunding, @investors = investors 
		FROM pvDB.cf_fundingProgresses 
		WHERE crowfundingID = @CrowdfundingID AND active = 1
		ORDER BY creationDate ASC;

		-- Verificar que no haya overflow de inversión
		IF (@currentFunding + @CantidadInversion) > @fundingGoal BEGIN
			SET @ResultMessage = 'La inversión excede la meta de financiamiento del crowdfunding.';
			SET @ResultCode = 6;

			IF @InicieTransaccion = 1 AND @@TRANCOUNT > 0
			BEGIN
				IF XACT_STATE() <> 0
				BEGIN
					ROLLBACK;
					RETURN
				END
			END
		END
		-- Realizar el pago
		DECLARE @NewPaymentID INT;

		DECLARE @result VARCHAR(200);
		DECLARE @auth VARCHAR(60);
		DECLARE @reference VARCHAR(100);
		DECLARE @charge_token VARBINARY(255);

		SET @result = 'Aprobado';
		SET @auth = LEFT(NEWID(), 8); 
		SET @reference = 'REF-' + REPLACE(NEWID(), '-', '');
		SET @charge_token = CONVERT(VARBINARY(255), NEWID());

		INSERT INTO pvDB.pv_payments (availableMethodID, currencyID, methodID, amount, date_pay, confirmed, result, auth, reference, charge_token, "description", "checksum") VALUES 
		(
		@UserSelectedPayMethodID,
		@currencyUsado,
		(SELECT methodID FROM pv_availablePayMethods WHERE available_method_id = @UserSelectedPayMethodID),
		@CantidadInversion,
		GETDATE(),
		1,
		@result,
		@auth,
		@reference,
		@charge_token,
		'Investment for crowdfunding ID: ' + CAST(@CrowdfundingID AS NVARCHAR(10)),
		HASHBYTES('SHA2_256', CONVERT(VARCHAR(MAX), @CantidadInversion) + CONVERT(VARCHAR(MAX), GETDATE(), 121) + ISNULL(@result, N'') + ISNULL(@auth, N'') + ISNULL(@reference, N'') + ISNULL(CONVERT(NVARCHAR(MAX), @charge_token, 1), N''))
		);

		SET @NewPaymentID = SCOPE_IDENTITY();

		-- Hacer la transacción
		DECLARE @NewTransactionID INT;

		INSERT INTO pvDB.pv_transactions (payment_id, userID, transactionTypesID, transactionSubtypesID, "date", postTime, refNumber, "checksum", exchangeRate, convertedAmount, amount) VALUES
		(
		@NewPaymentID,
		@userID,
		(SELECT transactionTypeID FROM pvDB.pv_transactionTypes WHERE name = 'Inversión de crowdfunding'),
		(SELECT transactionSubtypeID FROM pvDB.pv_transactionSubtypes WHERE name = 'Ingreso'),
		GETDATE(),
		GETDATE(),
		@reference,
		HASHBYTES('SHA2_256',  
				CONVERT(VARCHAR(MAX), @userID) +  
				CONVERT(VARCHAR(MAX), GETDATE(), 121) + 
				CONVERT(VARCHAR(MAX), GETDATE(), 121) + 
				ISNULL(@reference, N'') +  
				CONVERT(VARCHAR(MAX), @CantidadInversion) +
				CONVERT(VARCHAR(MAX), @CantidadInversion)),
		1,
		@CantidadInversion,
		@CantidadInversion
		);

		SET @NewTransactionID = SCOPE_IDENTITY();

		-- Una vez confirmados, hacer el investment
		DECLARE @NewInvestmentID INT;

		INSERT INTO pvDB.cf_investments (crowfundingID, investedAmount, equityEarned, investmentDate, statusID, userID, transactionID, "checksum") VALUES
		(
		@CrowdfundingID,
		@CantidadInversion,
		((@CantidadInversion * @eventEquity)/@fundingGoal),
		GETDATE(),
		2,
		@userID,
		@NewTransactionID,
		HASHBYTES('SHA2_256',  
				CONVERT(VARCHAR(MAX), @userID) +  
				CONVERT(VARCHAR(MAX), @CantidadInversion) +
				CONVERT(VARCHAR(MAX), ((@CantidadInversion * @eventEquity)/@fundingGoal)) +
				CONVERT(VARCHAR(MAX), GETDATE(), 121) +
				CONVERT(VARCHAR(MAX), @NewTransactionID) +
				'2')
		);

		SET @NewInvestmentID = SCOPE_IDENTITY();

		-- Actualizar el fundingProgress
		UPDATE cf_fundingProgresses SET
		currentFunding = @currentFunding + @CantidadInversion,
		investors = @investors + 1,
		lastUpdate = GETDATE()
		WHERE progressID = @progressID

		-- Si las inversiones ya llegan al objetivo, se cierra el crowdfunding
		IF (@CantidadInversion + @currentFunding) = @fundingGoal 
		BEGIN
			UPDATE cf_crowfundingEvents SET
			crowfundingStatusID = 4
			WHERE crowfundingID = @CrowdfundingID;
		END
		
		-- Guardar en logs el cambio en el funding progress
		INSERT INTO pvDB.pv_logs ([description], postTime, computer, username, trace, referenceId1, referenceId2, value1, value2, [checksum], logSeverityID, logTypesID, logSourcesID) VALUES 
		(
		N'Se ha invertido en un evento de crowdfunding. Progreso actualizado.',
		GETDATE(),
		HOST_NAME(),
		'SysUser',
		'SP_Invertir',
		@NewInvestmentID,
		@progressID,
		CONVERT(VARCHAR(MAX), @currentFunding),
		CONVERT(VARCHAR(MAX), @CantidadInversion + @currentFunding),
		HASHBYTES('SHA2_256',
				'Se ha invertido en un evento de crowdfunding' +
				CONVERT(NVARCHAR(MAX), GETDATE(), 121) +
				N'SysUser' +
				N'SP_Invertir' + 
				CONVERT(NVARCHAR(MAX), ISNULL(@currentFunding, 0)) +
				CONVERT(NVARCHAR(MAX), ISNULL(@CantidadInversion + @currentFunding, 0)) +
				CONVERT(NVARCHAR(MAX), ISNULL(@logSeverityInformativo, 0)) +
				CONVERT(NVARCHAR(MAX), ISNULL(@typeUpdate, 0)) +
				CONVERT(NVARCHAR(MAX), ISNULL(@SourceCrowdfunding, 0))),
		@logSeverityInformativo,
		@typeUpdate,
		@SourceCrowdfunding
		);
					
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
		
		-- INSERT INTO LOGS
		INSERT INTO pvDB.pv_logs ([description], postTime, computer, username, trace, [checksum], logSeverityID, logTypesID, logSourcesID) VALUES 
		(
		'Error en SP_Invertir: ' + LEFT(ISNULL(@Message, 'Mensaje de error desconocido'), 150),
		GETDATE(),
		HOST_NAME(),
		'SysUser',
		'SP_Invertir.CATCH',
		HASHBYTES('SHA2_256',
				N'Error en SP_Invertir: ' + ISNULL(CONVERT(NVARCHAR(MAX), @Message), N'') +
				CONVERT(VARCHAR(MAX), GETDATE(), 121) +
				'SysUser' +
				'SP_Invertir.CATCH' + 
				'3' +
				'3' +
				CONVERT(VARCHAR(MAX), @SourceCrowdfunding)),
		3,
		3,
		@SourceCrowdfunding
		);

		RAISERROR('%s - Error Number: %i', 
			@ErrorSeverity, @ErrorState, @Message, @CustomError) 

	END CATCH	
END
SELECT @ResultMessage = 'Inversión realizada con éxito.';
SELECT @ResultCode = 0;
RETURN 
GO