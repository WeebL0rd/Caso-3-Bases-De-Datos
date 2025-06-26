USE pvDB;
GO

DECLARE @propuestaSugarMe INT = (SELECT proposalID FROM pvDB.pv_proposals WHERE title = 'Sugar.me')
DECLARE @propuestaComercio INT = (SELECT proposalID FROM pvDB.pv_proposals WHERE title = 'Plataforma de comercio para pequeños productores')
DECLARE @USD_currencyID INT = (SELECT currencyID FROM pvDB.pv_currencies WHERE acronym = 'USD')
DECLARE @statusEnCurso INT = (SELECT crowfundingStatusID FROM pvDB.pv_crowfundingStatuses WHERE name = 'En curso')
DECLARE @statusCerrado INT = (SELECT crowfundingStatusID FROM pvDB.pv_crowfundingStatuses WHERE name = 'Cerrado')

INSERT INTO pvDB.cf_crowfundingEvents (proposalID, equity, fundingGoal, currency_id, startDate, endDate, checksum, crowfundingStatusID) VALUES
	(
	@propuestaSugarMe,
	30,
	400000,
	@USD_currencyID,
	DATEADD(month, -3, GETDATE()),
	DATEADD(month, 3, GETDATE()),
	HASHBYTES('SHA2_256',
			CONVERT(VARCHAR(MAX), @propuestaSugarMe) +
			'30' +
			'400000' +
			CONVERT(VARCHAR(MAX), DATEADD(month, -3, GETDATE()), 121) +
			CONVERT(VARCHAR(MAX), DATEADD(month, 3, GETDATE()), 121) +
			CONVERT(VARCHAR(MAX), @statusEnCurso)),
	@statusEnCurso
	),
	(
	@propuestaComercio,
	20,
	300000,
	@USD_currencyID,
	DATEADD(month, -3, GETDATE()),
	DATEADD(month, 1, GETDATE()),
	HASHBYTES('SHA2_256',
			CONVERT(VARCHAR(MAX), @propuestaComercio) +
			'20' +
			'300000' +
			CONVERT(VARCHAR(MAX), DATEADD(month, -3, GETDATE()), 121) +
			CONVERT(VARCHAR(MAX), DATEADD(month, 1, GETDATE()), 121) +
			CONVERT(VARCHAR(MAX), @statusCerrado)),
	@statusEnCurso
	)

INSERT INTO pvDB.cf_fundingProgresses (crowfundingID, currentFunding, creationDate, lastUpdate, active) VALUES
(1, 0, DATEADD(month, -3, GETDATE()), DATEADD(month, -3, GETDATE()), 1),
(2, 0, DATEADD(month, -3, GETDATE()), DATEADD(month, -3, GETDATE()), 1);





DECLARE @ResultMessage_output VARCHAR(100);
DECLARE @ResultCode_output INT;

-- Inserción de 5 investments en un crowdfunding Event 
-- Inversión de Juan Perez en el negocio de comercio
EXEC pvDB.SP_Invertir
	@CrowdfundingID = 2,
    @UserToken = 'a8d7f63a-b91e-46c9-8120-8a23e1f56f5c',
    @UserSelectedPayMethodID = 1,
    @CantidadInversion = 20000,
    @ResultMessage = @ResultMessage_output OUTPUT,
    @ResultCode = @ResultCode_output OUTPUT;

--SELECT 'Resultado Ejecución 1:' AS Resultado, @ResultMessage_output AS Mensaje, @ResultCode_output AS Codigo;
--PRINT '';

-- Inversión de Maria Gomez en en el negocio de comercio
EXEC pvDB.SP_Invertir
	@CrowdfundingID = 2,
    @UserToken = 'b1c5e62f-9c2b-4b5e-aef2-5ab8c17b63d1',
    @UserSelectedPayMethodID = 2,
    @CantidadInversion = 60000,
    @ResultMessage = @ResultMessage_output OUTPUT,
    @ResultCode = @ResultCode_output OUTPUT;

--SELECT 'Resultado Ejecución 2:' AS Resultado, @ResultMessage_output AS Mensaje, @ResultCode_output AS Codigo;
--PRINT '';

-- Inversión de Laura Fernandez en el negocio de comercio
EXEC pvDB.SP_Invertir
	@CrowdfundingID = 2,
    @UserToken = '3f2b8d1a-33a1-4bce-9817-2cd7983ea5f5',
    @UserSelectedPayMethodID = 3,
    @CantidadInversion = 30000,
    @ResultMessage = @ResultMessage_output OUTPUT,
    @ResultCode = @ResultCode_output OUTPUT;

--SELECT 'Resultado Ejecución 3:' AS Resultado, @ResultMessage_output AS Mensaje, @ResultCode_output AS Codigo;
--PRINT '';

-- Inversión de Ana Martinez en el negocio de comercio
EXEC pvDB.SP_Invertir
	@CrowdfundingID = 2,
    @UserToken = 'ae18797b-f682-4ee1-94d7-b42fd53189fb',
    @UserSelectedPayMethodID = 4,
    @CantidadInversion = 45500,
    @ResultMessage = @ResultMessage_output OUTPUT,
    @ResultCode = @ResultCode_output OUTPUT;

--SELECT 'Resultado Ejecución 4:' AS Resultado, @ResultMessage_output AS Mensaje, @ResultCode_output AS Codigo;
--PRINT '';

-- Inversión de Sofia Hernandez en el negocio de comercio
EXEC pvDB.SP_Invertir
	@CrowdfundingID = 2,
    @UserToken = 'eeb3540c-f22f-470e-8f43-c60b6c31b0c6',
    @UserSelectedPayMethodID = 5,
    @CantidadInversion = 144500,
    @ResultMessage = @ResultMessage_output OUTPUT,
    @ResultCode = @ResultCode_output OUTPUT;

--SELECT 'Resultado Ejecución 5:' AS Resultado, @ResultMessage_output AS Mensaje, @ResultCode_output AS Codigo;
--PRINT '';