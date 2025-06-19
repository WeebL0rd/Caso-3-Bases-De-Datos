USE pvDB;

-- Paises
INSERT INTO pvDB.pv_countries ([name]) VALUES
('Costa Rica'),
('Estados Unidos');

-- Monedas, nacionalidades, educacion
INSERT INTO pvDB.pv_educationLevels (educationLevel) VALUES
('Educacion General Basica'),
('Educacion Diversificada'),
('Bachillerato'),
('Licenciatura'),
('Maestria'),
('Doctorado');

GO
DECLARE @idCR int  = (SELECT countryID FROM pvDB.pv_countries WHERE [name] = 'Costa Rica');
DECLARE @idEU int = (SELECT countryID FROM pvDB.pv_countries WHERE [name] = 'Estados Unidos');

INSERT INTO pvDB.pv_nationalities ([name], countryID) VALUES
('Costarricense', @idCR),
('Estadounidense', @idEU);


INSERT INTO pvDB.pv_currencies ([name], acronym, symbol, countryID) VALUES
('Colón costarricense', 'CRC', '₡', @idCR),
('Dólar estadounidense', 'USD', '$', @idEU);

GO
-- Tipos Demografias
INSERT INTO pvDB.pv_demographicTypes (targetType, datatype) VALUES
('Edad','INT'),
('Sexo','BIT'),
('Educacion','INT'),
('Nacionalidad', 'INT');

GO
-- Demograficas
DECLARE @idTipoEdad int = (SELECT demographicTypeID FROM pvDB.pv_demographicTypes WHERE targetType = 'Edad');
DECLARE @idTipoSexo int = (SELECT demographicTypeID FROM pvDB.pv_demographicTypes WHERE targetType = 'Sexo');
DECLARE @idTipoEducacion int = (SELECT demographicTypeID FROM pvDB.pv_demographicTypes WHERE targetType = 'Educacion');
DECLARE @idTipoNacionalidad int = (SELECT demographicTypeID FROM pvDB.pv_demographicTypes WHERE targetType = 'Nacionalidad');

DECLARE @idCRNacionalidad int = (SELECT nationalityID FROM pvDB.pv_nationalities WHERE [name] = 'Costarricense');
DECLARE @idGenBas int = (SELECT educationLevelID FROM pvDB.pv_educationLevels WHERE educationLevel = 'Educacion General Basica');

INSERT INTO pvDB.pv_targetDemographics ([value], maxRange, [enabled], demographicTypeID, [weight]) VALUES
(40, 65, 1, @idTipoEdad, 5),
(18, 25, 1, @idTipoEdad, 3),
(60, NULL, 1, @idTipoEdad, 1),
(24, NULL, 1, @idTipoEdad, 1),
(@idCRNacionalidad, NULL, 1, @idTipoNacionalidad, 1),
(@idGenBas, NULL, 1, @idTipoEducacion, 3);
