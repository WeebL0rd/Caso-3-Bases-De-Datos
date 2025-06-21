USE pvDB;
GO

-- PARA PRUEBAS: Creo una llave que se usará para descifrar todos los datos
CREATE SYMMETRIC KEY llaveDescifradoSupremoParaEntornoPruebas
WITH ALGORITHM = AES_256
ENCRYPTION BY PASSWORD = 'pasandoBasesDeDat0s';
GO


CREATE SYMMETRIC KEY passwordEncrypter
WITH ALGORITHM = AES_256
ENCRYPTION BY PASSWORD = 'pasandoBasesDeDat0s';
GO

-- Como tengo que simular el keyVault, voy a tener que añadir un atributo keyPassword con su propia llave para encriptar y desencriptar las passwords en este caso
ALTER TABLE pvDB.pv_encryptionKeyMetadata
ADD keyPassword VARBINARY(256);  -- Simula la contraseña de la llave simétrica
GO


CREATE OR ALTER PROCEDURE [pvDB].[sp_CifrarDato]
    @owningEntityID INT,
    @owningEntityTypeID INT,
    @datoPlano NVARCHAR(MAX),
    @datoCifrado VARBINARY(MAX) OUTPUT
AS
BEGIN
    /* ----- ENCRIPTADO DE DATOS (lógica para conseguir la llave del key vault )
	DECLARE @keyName NVARCHAR(100), @encKeyPassword VARBINARY(256);

    SELECT @keyName = keyName, @encKeyPassword = keyPassword
    FROM pv_encryptionKeyMetadata
    WHERE owningEntityID = @owningEntityID
      AND owningEntityTypeID = @owningEntityTypeID
	  AND isActive = 1;

    IF @keyName IS NULL OR @encKeyPassword  IS NULL
    BEGIN
        RAISERROR('No se encontró una llave válida para esta entidad.', 16, 1);
        RETURN;
    END

	-- Descifrar la password con una llave del sistema
	OPEN SYMMETRIC KEY passwordEncrypter 
	DECRYPTION BY PASSWORD = 'pasandoBasesDeDat0s';

	DECLARE @keyPassword NVARCHAR(100)
	SELECT @keyPassword = CONVERT(NVARCHAR(MAX), DECRYPTBYKEY(@encKeyPassword));

	CLOSE SYMMETRIC KEY passwordEncrypter;

    -- Abrir la llave 
    EXEC('OPEN SYMMETRIC KEY [' + @keyName + '] DECRYPTION BY PASSWORD = ''' + @keyPassword + '''');

    -- Cifrar
    SET @datoCifrado = ENCRYPTBYKEY(KEY_GUID(@keyName), @datoPlano);

    CLOSE SYMMETRIC KEY [@keyName]; 
	*/


	-- ENCRIPTADO EN PRUEBAS
	OPEN SYMMETRIC KEY llaveDescifradoSupremoParaEntornoPruebas 
	DECRYPTION BY PASSWORD = 'pasandoBasesDeDat0s';

	DECLARE @keyPassword NVARCHAR(100)
	SET @datoCifrado = ENCRYPTBYKEY(KEY_GUID('llaveDescifradoSupremoParaEntornoPruebas'), @datoPlano);

	CLOSE SYMMETRIC KEY llaveDescifradoSupremoParaEntornoPruebas;

END
GO

CREATE OR ALTER PROCEDURE [pvDB].[sp_DescifrarDato]
    @owningEntityID INT,
    @owningEntityTypeID INT,
    @datoCifrado VARBINARY(MAX),
    @datoPlano NVARCHAR(MAX) OUTPUT
AS
BEGIN
	/* ----- DESENCRIPTADO DE DATOS (lógica para conseguir la llave del key vault )
    DECLARE @keyName NVARCHAR(100), @encKeyPassword VARBINARY(256);

    SELECT @keyName = keyName, @encKeyPassword = keyPassword
    FROM pv_encryptionKeyMetadata
    WHERE owningEntityID = @owningEntityID
      AND owningEntityTypeID = @owningEntityTypeID
	  AND isActive = 1;

    IF @keyName IS NULL OR @encKeyPassword  IS NULL
    BEGIN
        RAISERROR('No se encontró una llave válida para esta entidad.', 16, 1);
        RETURN;
    END

	-- Descifrar la password con una llave del sistema
	OPEN SYMMETRIC KEY passwordEncrypter 
	DECRYPTION BY PASSWORD = 'pasandoBasesDeDat0s';

	DECLARE @keyPassword NVARCHAR(100)
	SELECT @keyPassword = CONVERT(NVARCHAR(MAX), DECRYPTBYKEY(@encKeyPassword));

	CLOSE SYMMETRIC KEY passwordEncrypter;
    EXEC('OPEN SYMMETRIC KEY [' + @keyName + '] DECRYPTION BY PASSWORD = ''' + @keyPassword + '''');

    -- Descifrar
    SET @datoPlano = CONVERT(NVARCHAR(MAX), DECRYPTBYKEY(@datoCifrado));

    CLOSE SYMMETRIC KEY [@keyName]; 
	*/

	-- DESENCRIPTADO EN PRUEBAS
	OPEN SYMMETRIC KEY llaveDescifradoSupremoParaEntornoPruebas 
	DECRYPTION BY PASSWORD = 'pasandoBasesDeDat0s';

	DECLARE @keyPassword NVARCHAR(100)
	SET @datoPlano = CONVERT(NVARCHAR(MAX), DECRYPTBYKEY(@datoCifrado));

	CLOSE SYMMETRIC KEY llaveDescifradoSupremoParaEntornoPruebas;

END
GO
