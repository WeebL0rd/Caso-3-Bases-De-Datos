USE pvDB;
GO

CREATE OR ALTER PROCEDURE [pvDB].[SP_RevisarPropuesta]
    @proposalID   INT,                   -- Identificador de la propuesta a revisar
    @reviewerID   INT = NULL,            -- ID del revisor humano (NULL si es validación automática)
    @ResultMessage NVARCHAR(200) OUTPUT, -- Mensaje de resultado de la operación
    @ResultCode    INT OUTPUT           -- Código de resultado (0 = éxito, >0 = error)
AS
BEGIN
    SET NOCOUNT ON;

    -- 1. Declaración de variables de control de errores y transacción
    DECLARE @ErrorNumber INT, @ErrorSeverity INT, @ErrorState INT;
    DECLARE @ErrorMessage NVARCHAR(200);
    DECLARE @InicieTransaccion BIT = 0;

    -- 2. Variables para datos de la propuesta y validación
    DECLARE @proposalTypeName NVARCHAR(100);
    DECLARE @currentStatusID SMALLINT;
    DECLARE @title NVARCHAR(75), @description NVARCHAR(300);
    DECLARE @payload NVARCHAR(MAX);    -- Payload JSON preparado para IA/LLM
    DECLARE @cumple BIT, @analisis NVARCHAR(500);

    -- 3. Obtener la propuesta y verificar existencia/estado
    SELECT 
        @proposalTypeName = pt.[type],
        @currentStatusID = p.proposalStatusID,
        @title = p.title,
        @description = p.[description]
    FROM pvDB.pv_proposals p
    JOIN pvDB.pv_proposalTypes pt ON p.proposalTypeID = pt.proposalTypeID
    WHERE p.proposalID = @proposalID;

    IF @proposalTypeName IS NULL
    BEGIN
        SELECT @ResultMessage = N'La propuesta indicada no existe.', @ResultCode = 1;
        RETURN;
    END;

    -- Verificar que esté Pendiente de validación (solo en ese estado procede la revisión)
    DECLARE @statusPend SMALLINT;
    SELECT @statusPend = proposalStatusID FROM pvDB.pv_proposalStatus WHERE [name] = 'Pendiente de validacion';
    IF @currentStatusID <> @statusPend
    BEGIN
        SELECT @ResultMessage = N'La propuesta no está Pendiente de validación; no se puede revisar.', @ResultCode = 2;
        RETURN;
    END;

    -- 4. Iniciar transacción atómica para el proceso de revisión
    IF @@TRANCOUNT = 0 
    BEGIN
        SET @InicieTransaccion = 1;
        SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
        BEGIN TRANSACTION;
    END;

    BEGIN TRY
        -- 5. Preparar el payload JSON con datos de la propuesta (estructura esperada por IA/LLM)
        SET @payload = N'{' +
                       N'"proposalID": '    + CAST(@proposalID AS NVARCHAR(10)) + N',' +
                       N'"type": "'         + @proposalTypeName + N'",' +
                       N'"title": "'        + ISNULL(REPLACE(@title, '"', '\"'), '') + N'",' +
                       N'"description": "'  + ISNULL(REPLACE(@description, '"', '\"'), '') + N'"}';
        -- (Nota: Se escapan comillas en título/descr. para construir JSON válido)

        -- 6. Simular validación automática de la propuesta según criterios definidos
        SET @cumple = 1;
        SET @analisis = N'';  -- Inicia análisis técnico vacío

        -- Criterio 6.1: Verificar que la propuesta tenga al menos un documento asociado
        IF NOT EXISTS (SELECT 1 FROM pvDB.pv_proposalDocuments WHERE proposalID = @proposalID)
        BEGIN
            SET @cumple = 0;
            SET @analisis += N'Sin documento de propuesta adjunto. ';
        END;

        -- Criterio 6.2: Longitud mínima de la descripción
        IF LEN(ISNULL(@description, '')) < 50
        BEGIN
            SET @cumple = 0;
            SET @analisis += N'Descripción muy corta. ';
        END;

        -- Criterio 6.3: Detección de palabra prohibida ("violencia")
        IF LOWER(ISNULL(@description, '')) LIKE N'%violencia%' 
            OR LOWER(ISNULL(@title, '')) LIKE N'%violencia%'
        BEGIN
            SET @cumple = 0;
            SET @analisis += N'Contenido potencialmente inapropiado. ';
        END;

        -- Resultado final del análisis
        IF @cumple = 1
        BEGIN
            SET @analisis = N'Validación exitosa. La propuesta cumple con todos los criterios.';
        END
        ELSE
        BEGIN
            SET @analisis = N'Falló criterios: ' + @analisis;
        END;

        -- 7. Actualizar el estado de la propuesta según resultado de validación
        DECLARE @statusPubl SMALLINT, @statusRech SMALLINT;
        SELECT 
            @statusPubl = proposalStatusID 
        FROM pvDB.pv_proposalStatus 
        WHERE [name] = 'Publicada';
        SELECT 
            @statusRech = proposalStatusID 
        FROM pvDB.pv_proposalStatus 
        WHERE [name] = 'Rechazado';

        IF @cumple = 1
        BEGIN
            -- Cumple criterios: publicar propuesta
            UPDATE pvDB.pv_proposals
            SET proposalStatusID = @statusPubl,
                lastUpdate = GETDATE(),
                [checksum] = HASHBYTES(
                                'SHA2_256', 
                                CONCAT(proposalTypeID, @statusPubl, title, [description], creationDate, GETDATE(), [version])
                             )
            WHERE proposalID = @proposalID;
        END
        ELSE
        BEGIN
            -- No cumple criterios: rechazar propuesta
            UPDATE pvDB.pv_proposals
            SET proposalStatusID = @statusRech,
                lastUpdate = GETDATE(),
                [checksum] = HASHBYTES(
                                'SHA2_256', 
                                CONCAT(proposalTypeID, @statusRech, title, [description], creationDate, GETDATE(), [version])
                             )
            WHERE proposalID = @proposalID;
        END;

        -- 8. Registrar la solicitud de validación y su resultado (simulación de pv_requests/pv_requestResults)
        DECLARE @newRequestID INT;
        INSERT INTO pvDB.pv_requests (payload, createdAt, executed, workflowID)
        VALUES (@payload, GETDATE(), 1, 1);  -- Nota: Usamos workflowID=1 arbitrariamente para esta simulación
        SET @newRequestID = SCOPE_IDENTITY();

        DECLARE @jobID NVARCHAR(45) = CONVERT(NVARCHAR(45), NEWID());
        DECLARE @responseText NVARCHAR(100);
        SET @responseText = CASE 
                                WHEN @cumple = 1 THEN N'Aprobado - ' + @analisis
                                ELSE N'Rechazado - ' + @analisis
                            END;
        -- Truncar @responseText si excede 100 caracteres (limite del campo):
        IF LEN(@responseText) > 100 
            SET @responseText = LEFT(@responseText, 100);

        INSERT INTO pvDB.pv_requestResults (requestID, jobID, [response], executionDate)
        VALUES (@newRequestID, @jobID, @responseText, GETDATE());

        -- 9. Registrar en la bitácora (pv_logs) la operación de revisión de propuesta
        DECLARE @fuente NVARCHAR(20) = CASE WHEN @reviewerID IS NULL THEN N'Automática' ELSE N'Manual' END;
        DECLARE @logDesc NVARCHAR(200);
        IF @cumple = 1
            SET @logDesc = N'Propuesta revisada (' + @fuente + N'): Estado final Publicada.';
        ELSE 
            SET @logDesc = N'Propuesta revisada (' + @fuente + N'): Estado final Rechazada.';

        -- Incluir ID del revisor en la descripción si fue manual
        IF @reviewerID IS NOT NULL
            SET @logDesc = @logDesc + N' RevisorID=' + CAST(@reviewerID AS NVARCHAR(10)) + N'.';

        DECLARE @logSeverityInfo INT, @logTypeDataUpd INT, @logSourceBack INT;
        SELECT @logSeverityInfo = logSeverityID FROM pvDB.pv_logsSeverity WHERE [name] = 'Informativo';
        SELECT @logTypeDataUpd = logTypesID     FROM pvDB.pv_logTypes     WHERE [name] = 'Actualización de Datos';
        SELECT @logSourceBack  = logSourcesID   FROM pvDB.pv_logSources   WHERE [name] = 'Backend General';

        INSERT INTO pvDB.pv_logs (
            [description], postTime, computer, username, trace,
            referenceId1, referenceId2, value1, value2, [checksum],
            logSeverityID, logTypesID, logSourcesID
        ) VALUES (
            @logDesc,
            GETDATE(),
            HOST_NAME(),
            N'SysUser',
            N'SP_RevisarPropuesta',
            @reviewerID,                -- referencia 1: ID del revisor (NULL si automática)
            @proposalID,                -- referencia 2: ID de la propuesta
            N'Estado propuesta',        -- valor1: campo modificado
            CASE WHEN @cumple = 1 THEN N'Publicada' ELSE N'Rechazado' END,  -- valor2: nuevo estado
            HASHBYTES('SHA2_256', 
                @logDesc + 
                CONVERT(NVARCHAR(50), CONVERT(DATETIME2(0), GETDATE()), 121) +
                N'SysUser' + N'SP_RevisarPropuesta' +
                ISNULL(CONVERT(NVARCHAR(10), @reviewerID), N'') +
                CONVERT(NVARCHAR(10), @proposalID) +
                CASE WHEN @cumple = 1 THEN N'Publicada' ELSE N'Rechazado' END +
                CONVERT(NVARCHAR(10), @logSeverityInfo) +
                CONVERT(NVARCHAR(10), @logTypeDataUpd) +
                CONVERT(NVARCHAR(10), @logSourceBack)
            ),
            @logSeverityInfo,
            @logTypeDataUpd,
            @logSourceBack
        );

        -- 10. Finalizar transacción con éxito
        IF @InicieTransaccion = 1 
            COMMIT;

        -- Establecer valores de salida de éxito
        SELECT @ResultMessage = N'Propuesta revisada con éxito.', @ResultCode = 0;
    END TRY

    BEGIN CATCH
        -- Manejo de errores: revertir transacción si está activa
        SET @ErrorNumber = ERROR_NUMBER();
        SET @ErrorSeverity = ERROR_SEVERITY();
        SET @ErrorState = ERROR_STATE();
        SET @ErrorMessage = ERROR_MESSAGE();

        IF @InicieTransaccion = 1 AND XACT_STATE() <> 0
            ROLLBACK;

        -- Registrar el error en la bitácora (log de errores del sistema)
        DECLARE @logSourceErr INT;
        SELECT @logSourceErr = logSourcesID FROM pvDB.pv_logSources WHERE [name] = 'Backend General';
        INSERT INTO pvDB.pv_logs (
            [description], postTime, computer, username, trace, [checksum],
            logSeverityID, logTypesID, logSourcesID
        ) VALUES (
            N'Error en SP_RevisarPropuesta: ' + LEFT(ISNULL(@ErrorMessage, N'Error desconocido'), 150),
            GETDATE(),
            HOST_NAME(),
            N'SysUser',
            N'SP_RevisarPropuesta.CATCH',
            HASHBYTES('SHA2_256',
                N'Error en SP_RevisarPropuesta: ' + ISNULL(CONVERT(NVARCHAR(MAX), @ErrorMessage), N'') +
                CONVERT(VARCHAR(25), GETDATE(), 121) + 
                N'SysUser' + N'SP_RevisarPropuesta.CATCH' +
                CONVERT(NVARCHAR(10), @ErrorNumber) +
                CONVERT(NVARCHAR(10), @ErrorSeverity) +
                CONVERT(NVARCHAR(10), @ErrorState)
            ),
            3,   -- logSeverity "Error"
            3,   -- logType "Error del Sistema"
            @logSourceErr
        );

        -- Propagar el error al caller con detalles (mensaje y número)
        RAISERROR('%s (Error Nº %d)', @ErrorSeverity, 1, @ErrorMessage, @ErrorNumber);
    END CATCH
END;
GO
