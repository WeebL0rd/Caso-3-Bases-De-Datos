USE pvDB;

-- Revocar todos los permisos a todos los usuarios públicos
REVOKE SELECT, INSERT, UPDATE, DELETE, EXECUTE ON SCHEMA::pvDB FROM public;

IF NOT EXISTS (SELECT * FROM sys.sql_logins WHERE name = 'userSP')
    CREATE LOGIN userSP WITH PASSWORD = 'VotoPuravida';
GO

IF NOT EXISTS (SELECT * FROM sys.sql_logins WHERE name = 'userORM')
    CREATE LOGIN userORM WITH PASSWORD = 'VotoPuravida';
GO

IF NOT EXISTS (SELECT * FROM sys.sql_logins WHERE name = 'superUser')
    CREATE LOGIN superUser WITH PASSWORD = 'MegaPassword123';
GO

IF NOT EXISTS (SELECT * FROM sys.database_principals WHERE name = 'userSP')
    CREATE USER userSP FOR LOGIN userSP;
GO

IF NOT EXISTS (SELECT * FROM sys.database_principals WHERE name = 'userORM')
    CREATE USER userORM FOR LOGIN userORM;
GO

IF NOT EXISTS (SELECT * FROM sys.database_principals WHERE name = 'superUser')
    CREATE USER superUser FOR LOGIN superUser;
GO

IF NOT EXISTS (SELECT * FROM sys.database_principals WHERE name = 'usoDeSPs')
    CREATE ROLE usoDeSPs;
GO

IF NOT EXISTS (SELECT * FROM sys.database_principals WHERE name = 'allowRead')
    CREATE ROLE allowRead;
GO

IF NOT EXISTS (SELECT * FROM sys.database_principals WHERE name = 'ormManipulation')
    CREATE ROLE ormManipulation;
GO

-- Otorgar permisos de lectura al userSP con permisos elevados
GRANT SELECT ON SCHEMA::pvDB TO allowRead
GRANT VIEW DEFINITION ON SCHEMA::pvDB TO allowRead
-- Otorgar permisos básicos para solo poder utilizar los SPs
GRANT EXECUTE ON SCHEMA::pvDB TO usoDeSPs
-- Otorgar permisos que necesita el userSP para utilizar los ORM
GRANT SELECT, INSERT, UPDATE ON SCHEMA::pvDB TO ormManipulation;


ALTER ROLE usoDeSPs ADD MEMBER userSP;
ALTER ROLE ormManipulation ADD MEMBER userORM;
ALTER ROLE usoDeSPs ADD MEMBER superUser;
ALTER ROLE allowRead ADD MEMBER superUser;
ALTER ROLE ormManipulation ADD MEMBER superUser;