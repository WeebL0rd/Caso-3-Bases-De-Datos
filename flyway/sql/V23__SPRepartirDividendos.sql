USE pvDB;
GO

CREATE OR ALTER PROCEDURE [pvDB].[repartirDividendos]
    @CrowdfundingID INT,                        -- ID del evento de crowdfunding
    @ResultMessage VARCHAR(100) OUTPUT,         -- Mensaje de resultado
    @ResultCode INT OUTPUT                      -- Código de resultado
AS
BEGIN
    SET NOCOUNT ON;
    -- Declaración de variables para manejo de errores
    DECLARE @ErrorNumber INT, @ErrorSeverity INT, @ErrorState INT;
    DECLARE @CustomError INT; 
    DECLARE @Message VARCHAR(200);
    DECLARE @InicieTransaccion BIT;
    
    -- Variables del evento de crowdfunding / proyecto
    DECLARE @proposalID INT;
    DECLARE @crowdfundingStatusID TINYINT;
    DECLARE @eventEquity DECIMAL(18,2);
    DECLARE @currencyEvent INT;
    
    -- Variables del reporte financiero / resultados
    DECLARE @financialReportID INT;
    DECLARE @netProfit DECIMAL(18,2);
    
    -- Variables de progreso de financiamiento
    DECLARE @progressID INT;
    DECLARE @currentFunding DECIMAL(18,3);
    DECLARE @investorsCount INT;
    
    -- Variables para cálculos de pagos
    DECLARE @totalDistribution DECIMAL(18,2);
    DECLARE @logSeverityInfo INT;
    DECLARE @logSeverityError INT;
    DECLARE @logTypePago INT;
    DECLARE @logTypeError INT;
    DECLARE @logSourceCF INT;
    DECLARE @logDesc NVARCHAR(150);
    
    -- 1. Validar existencia del evento de crowdfunding
    SELECT @proposalID = ce.proposalID,
           @eventEquity = ce.equity,
           @crowdfundingStatusID = ce.crowfundingStatusID,
           @currencyEvent = ce.currency_id
    FROM pvDB.cf_crowfundingEvents ce
    WHERE ce.crowfundingID = @CrowdfundingID;
    IF @proposalID IS NULL
    BEGIN
        SELECT @ResultMessage = N'El evento de crowdfunding no existe.';
        SELECT @ResultCode = 1;
        RETURN;
    END;
    
    -- 1. Validar que la propuesta esté en estado 'Ejecutando'
    DECLARE @StatusEjecutando INT;
    SELECT @StatusEjecutando = proposalStatusID 
    FROM pvDB.pv_proposalStatus 
    WHERE [name] = 'Ejecutando';
    IF NOT EXISTS (
        SELECT 1 FROM pvDB.pv_proposals p
        WHERE p.proposalID = @proposalID 
          AND p.proposalStatusID = @StatusEjecutando
    )
    BEGIN
        SELECT @ResultMessage = N'El proyecto no está en estado Ejecutando.';
        SELECT @ResultCode = 2;
        RETURN;
    END;
    
    -- 2. Verificar reporte de ganancias aprobado vinculado al evento
    -- Buscar un financialReport aprobado de esta propuesta que tenga resultados
    DECLARE @StatusAprobado INT;
    SELECT @StatusAprobado = reportStatusID 
    FROM pvDB.reportStatuses WHERE [name] = 'Aprobado';
    SELECT TOP 1 
        @financialReportID = fr.financialReportID,
        @netProfit = frs.netProfit
    FROM pvDB.cf_financialReports fr
    JOIN pvDB.cf_financialResults frs 
         ON frs.financialReportID = fr.financialReportID
    WHERE fr.proposalID = @proposalID
      AND fr.reportStatusID = @StatusAprobado
      AND frs.netProfit > 0
      AND NOT EXISTS (
             SELECT 1 FROM pvDB.cf_payouts po 
             WHERE po.financialReportID = fr.financialReportID
         )
    ORDER BY fr.reportPeriodEnd DESC;
    IF @financialReportID IS NULL
    BEGIN
        SELECT @ResultMessage = N'No hay ganancias disponibles para distribuir.';
        SELECT @ResultCode = 3;
        RETURN;
    END;
    
    -- 3. Consultar recaudación actual y validar disponibilidad de fondos
    SELECT TOP 1 
        @progressID = progressID, 
        @currentFunding = currentFunding, 
        @investorsCount = investors
    FROM pvDB.cf_fundingProgresses 
    WHERE crowfundingID = @CrowdfundingID AND [active] = 1
    ORDER BY creationDate DESC;
    IF @currentFunding IS NULL 
    BEGIN
        SELECT @ResultMessage = N'No hay registro de fondos recaudados para este evento.';
        SELECT @ResultCode = 4;
        RETURN;
    END;
    
    -- 4. Verificar métodos de pago disponibles para todos los inversionistas
    IF EXISTS (
        SELECT 1 
        FROM pvDB.cf_investments inv
        WHERE inv.crowfundingID = @CrowdfundingID 
          AND inv.statusID = 2  -- inversiones confirmadas
          AND NOT EXISTS (
                 SELECT 1 FROM pvDB.pv_availablePayMethods pm
                 WHERE pm.userID = inv.userID AND GETDATE() < pm.expToken
             )
    )
    BEGIN
        SELECT @ResultMessage = N'Uno o más inversionistas no tienen método de pago válido.';
        SELECT @ResultCode = 5;
        RETURN;
    END;
    
    -- Preparar severidades, tipos y fuente para logs
    SELECT @logSeverityInfo = logSeverityID FROM pvDB.pv_logsSeverity WHERE [name] = 'Informativo';
    SELECT @logSeverityError = logSeverityID FROM pvDB.pv_logsSeverity WHERE [name] = 'Error';
    SELECT @logTypePago = logTypesID FROM pvDB.pv_logTypes WHERE [name] = 'Pago';
    SELECT @logTypeError = logTypesID FROM pvDB.pv_logTypes WHERE [name] = 'Error del Sistema';
    SELECT @logSourceCF = logSourcesID FROM pvDB.pv_logSources WHERE [name] = 'Motor de Crowdfunding';
    
    -- Iniciar transacción para el reparto de dividendos
    SET @InicieTransaccion = 0;
    IF @@TRANCOUNT = 0 
    BEGIN
        SET @InicieTransaccion = 1;
        SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;
        BEGIN TRANSACTION;
    END;
    
    BEGIN TRY
        -- Recalcular disponibilidad de fondos dentro de la transacción
        -- (vuelve a obtener @currentFunding por seguridad, aunque ya se tenía)
        SELECT TOP 1 
            @progressID = progressID, 
            @currentFunding = currentFunding, 
            @investorsCount = investors
        FROM pvDB.cf_fundingProgresses 
        WHERE crowfundingID = @CrowdfundingID AND [active] = 1
        ORDER BY creationDate DESC;
        
        -- Calcular total a distribuir (sumatoria de dividendos a inversionistas)
        DECLARE @sumEquity DECIMAL(18,5);
        SELECT @sumEquity = SUM(inv.equityEarned)
        FROM pvDB.cf_investments inv
        WHERE inv.crowfundingID = @CrowdfundingID AND inv.statusID = 2;
        SET @totalDistribution = @netProfit * (@sumEquity / 100);
        
        IF @currentFunding < @totalDistribution
        BEGIN
            -- Fondos insuficientes para cubrir todos los dividendos
            SET @ResultMessage = N'Fondos insuficientes para distribuir los dividendos.';
            SET @ResultCode = 4;
            IF @InicieTransaccion = 1 AND @@TRANCOUNT > 0
            BEGIN
                IF XACT_STATE() <> 0 
                BEGIN
                    ROLLBACK;
                    RETURN;
                END;
            END;
        END;
        
        -- Cursor/Iteración por cada inversionista para procesar pago y payout
        DECLARE InvestorCursor CURSOR LOCAL FAST_FORWARD FOR
        SELECT inv.investmentID, inv.userID, inv.equityEarned,
               pm.available_method_id, pm.methodID
        FROM pvDB.cf_investments inv
        OUTER APPLY (
            SELECT TOP 1 available_method_id, methodID 
            FROM pvDB.pv_availablePayMethods pm 
            WHERE pm.userID = inv.userID AND GETDATE() < pm.expToken
            ORDER BY pm.available_method_id ASC
        ) pm
        WHERE inv.crowfundingID = @CrowdfundingID AND inv.statusID = 2;
        
        DECLARE @investmentID INT, @userID INT;
        DECLARE @equity DECIMAL(18,5);
        DECLARE @payMethodID INT, @methodTypeID INT;
        OPEN InvestorCursor;
        FETCH NEXT FROM InvestorCursor INTO @investmentID, @userID, @equity, @payMethodID, @methodTypeID;
        
        WHILE @@FETCH_STATUS = 0
        BEGIN
            -- (Por seguridad) Si algún inversionista no tiene método de pago aquí, lanzar error
            IF @payMethodID IS NULL OR @methodTypeID IS NULL
            BEGIN
                -- No debería ocurrir por validación previa, pero si ocurre:
                RAISERROR(N'Inversionista %d sin método de pago válido.', 16, 1, @userID);
            END;
            -- Calcular monto a pagar para este inversionista
            DECLARE @amountPay DECIMAL(18,2) = @netProfit * (@equity / 100);
            
            -- Generar datos para el pago
            DECLARE @result VARCHAR(50) = 'Aprobado';
            DECLARE @auth VARCHAR(20) = LEFT(NEWID(), 8);
            DECLARE @reference VARCHAR(100) = 'REF-' + REPLACE(NEWID(), '-', '');
            DECLARE @chargeToken VARBINARY(255) = CONVERT(VARBINARY(255), NEWID());
            DECLARE @now DATETIME2(0) = GETDATE();
            
            -- Insertar pago en pv_payments
            DECLARE @newPaymentID INT;
            INSERT INTO pvDB.pv_payments 
                (availableMethodID, currencyID, methodID, amount, date_pay, confirmed, result, auth, reference, charge_token, [description], [checksum])
            VALUES 
                (@payMethodID, 
                 @currencyEvent, 
                 @methodTypeID, 
                 @amountPay, 
                 @now, 
                 1,                                   -- confirmado
                 @result, 
                 @auth, 
                 @reference, 
                 @chargeToken,
                 CONCAT('Dividendos crowdfunding ID: ', @CrowdfundingID), 
                 HASHBYTES('SHA2_256',
                           CONCAT(CONVERT(VARCHAR(50), @amountPay),
                                  CONVERT(VARCHAR(50), @now, 121),
                                  ISNULL(@result, ''), ISNULL(@auth, ''), 
                                  ISNULL(@reference, ''), 
                                  ISNULL(CONVERT(VARCHAR(MAX), @chargeToken, 1), ''))
                 )
            );
            SET @newPaymentID = SCOPE_IDENTITY();
            
            -- Insertar transacción en pv_transactions
            DECLARE @newTransactionID INT;
            INSERT INTO pvDB.pv_transactions 
                (payment_id, userID, transactionTypesID, transactionSubtypesID, [date], postTime, refNumber, [checksum], exchangeRate, convertedAmount, amount)
            VALUES 
                (@newPaymentID,
                 @userID,
                 (SELECT transactionTypeID FROM pvDB.pv_transactionTypes WHERE [name] = 'Repartición de dividendos'),
                 (SELECT transactionSubtypeID FROM pvDB.pv_transactionSubtypes WHERE [name] = 'Egreso'),
                 @now,
                 @now,
                 @reference,
                 HASHBYTES('SHA2_256',
                           CONCAT(@userID, CONVERT(VARCHAR(50), @now, 121),
                                  CONVERT(VARCHAR(50), @now, 121), ISNULL(@reference, ''), 
                                  CONVERT(VARCHAR(50), @amountPay), CONVERT(VARCHAR(50), @amountPay))
                 ),
                 1, 
                 @amountPay, 
                 @amountPay
                );
            SET @newTransactionID = SCOPE_IDENTITY();
            
            -- Insertar registro de payout en cf_payouts
            INSERT INTO pvDB.cf_payouts 
                (financialReportID, investmentID, equityPercent, amountToPay, paymentStatusID, transactionID, paid)
            VALUES 
                (@financialReportID, @investmentID, CONVERT(DECIMAL(5,2), @equity), @amountPay, 2, @newTransactionID, 0x01);
            
            -- Registrar log de pago individual (Informativo)
            INSERT INTO pvDB.pv_logs 
                ([description], postTime, computer, username, trace, referenceId1, referenceId2, value1, value2, [checksum], logSeverityID, logTypesID, logSourcesID)
            VALUES 
                (N'Dividendo pagado a inversionista', 
                 GETDATE(), 
                 HOST_NAME(), 
                 SUSER_SNAME(), 
                 'SP_repartirDividendos', 
                 @newPaymentID,              -- ID del pago
                 @userID,                    -- ID del usuario receptor
                 CONVERT(VARCHAR(50), @amountPay), 
                 (SELECT acronym FROM pvDB.pv_currencies WHERE currencyID = @currencyEvent),
                 HASHBYTES('SHA2_256', 
                           CONCAT('Dividendo pagado', CONVERT(VARCHAR(50), GETDATE(), 121),
                                  'SP_repartirDividendos', @newPaymentID, @userID, 
                                  CONVERT(VARCHAR(50), @amountPay), @currencyEvent)
                 ),
                 @logSeverityInfo, @logTypePago, @logSourceCF
                );
            
            FETCH NEXT FROM InvestorCursor INTO @investmentID, @userID, @equity, @payMethodID, @methodTypeID;
        END
        CLOSE InvestorCursor;
        DEALLOCATE InvestorCursor;
        
        -- Registrar log general de distribución de dividendos (Informativo)
        INSERT INTO pvDB.pv_logs 
            ([description], postTime, computer, username, trace, referenceId1, referenceId2, value1, value2, [checksum], logSeverityID, logTypesID, logSourcesID)
        VALUES
            (N'Dividendos repartidos al evento de crowdfunding', 
             GETDATE(), 
             HOST_NAME(), 
             SUSER_SNAME(), 
             'SP_repartirDividendos', 
             @CrowdfundingID,               -- ID del evento
             @financialReportID,            -- ID del reporte financiero utilizado
             CONVERT(VARCHAR(50), @totalDistribution),    -- Monto total distribuido
             CONVERT(VARCHAR(10), @investorsCount),       -- Cantidad de inversionistas pagados
             HASHBYTES('SHA2_256',
                       CONCAT('Dividendos repartidos', CONVERT(VARCHAR(50), GETDATE(), 121),
                              'SP_repartirDividendos', @CrowdfundingID, @financialReportID,
                              CONVERT(VARCHAR(50), @totalDistribution), @investorsCount)
             ),
             @logSeverityInfo, @logTypePago, @logSourceCF
            );
        
        -- Si iniciamos la transacción, confirmar (commit)
        IF @InicieTransaccion = 1 
        BEGIN
            COMMIT;
        END;
        
        -- Establecer resultado exitoso
        SELECT @ResultMessage = N'Distribución de dividendos completada con éxito.';
        SELECT @ResultCode = 0;
        RETURN;
    END TRY
    BEGIN CATCH
        -- Manejo de errores inesperados
        SET @ErrorNumber = ERROR_NUMBER();
        SET @ErrorSeverity = ERROR_SEVERITY();
        SET @ErrorState = ERROR_STATE();
        SET @Message = ERROR_MESSAGE();
        
        IF @InicieTransaccion = 1 AND @@TRANCOUNT > 0
        BEGIN
            ROLLBACK;
        END;
        -- Registrar log de error
        INSERT INTO pvDB.pv_logs 
            ([description], postTime, computer, username, trace, [checksum], logSeverityID, logTypesID, logSourcesID) 
        VALUES 
            (
             LEFT(N'Error en SP_repartirDividendos: ' + ISNULL(@Message, 'Error desconocido'), 200),
             GETDATE(),
             HOST_NAME(),
             SUSER_SNAME(),
             'SP_repartirDividendos.CATCH',
             HASHBYTES('SHA2_256',
                       CONCAT(ISNULL(@Message, ''), CONVERT(VARCHAR(50), GETDATE(), 121),
                              'SP_repartirDividendos.CATCH', @ErrorNumber, @ErrorState, @logSourceCF)
             ),
             @logSeverityError, @logTypeError, @logSourceCF
            );
        -- Propagar el error SQL original
        RAISERROR(@Message, @ErrorSeverity, @ErrorState);
        RETURN;
    END CATCH
END
GO
