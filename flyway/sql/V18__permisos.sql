USE pvDB;

-- Revocar todos los permisos a todos los usuarios públicos
REVOKE SELECT, INSERT, UPDATE, DELETE, EXECUTE ON SCHEMA::pvDB FROM public;

CREATE LOGIN userSP WITH PASSWORD = 'VotoPuravida'
CREATE LOGIN userORM WITH PASSWORD = 'VotoPuravida'
CREATE LOGIN superUser WITH PASSWORD = 'MegaPassword123'

CREATE USER userSP FOR LOGIN userSP
CREATE USER superUser FOR LOGIN superUser
CREATE USER userORM FOR LOGIN userORM

CREATE ROLE usoDeSPs
CREATE ROLE allowRead
CREATE ROLE ormManipulation

-- Otorgar permisos de lectura al userSP con permisos elevados
GRANT SELECT ON SCHEMA::pvDB TO allowRead
GRANT VIEW DEFINITION ON SCHEMA::pvDB TO allowRead
-- Otorgar permisos básicos para solo poder utilizar los SPs
GRANT EXECUTE ON SCHEMA::pvDB TO usoDeSPs
-- Otorgar permisos que necesita el userSP para utilizar los ORM
GRANT SELECT, INSERT, UPDATE ON SCHEMA::pvDB TO ormManipulation;
