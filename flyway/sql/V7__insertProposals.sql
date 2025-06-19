USE pvDB;

-- Reinicios de informacion

DELETE FROM pvDB.pv_proposalDemographics;
DBCC CHECKIDENT ('pvDB.pv_proposalDemographics', RESEED, 0);
DELETE FROM pvDB.pv_KPITypes;
DBCC CHECKIDENT ('pvDB.pv_KPITypes', RESEED, 0);
DELETE FROM pvDB.pv_timeUnits;
DBCC CHECKIDENT ('pvDB.pv_timeUnits', RESEED, 0);
DELETE FROM pvDB.pv_proposalImpacts;
DBCC CHECKIDENT ('pvDB.pv_proposalImpacts', RESEED, 0);
DELETE FROM pvDB.pv_impactedEntityTypes;
DELETE FROM pvDB.pv_proposalBenefits;
DBCC CHECKIDENT ('pvDB.pv_proposalBenefits', RESEED, 0);
DELETE FROM pvDB.pv_proposalRecords;
DBCC CHECKIDENT ('pvDB.pv_proposalRecords', RESEED, 0);
DELETE FROM pvDB.pv_proposals;
DBCC CHECKIDENT ('pvDB.pv_proposals', RESEED, 0);
DELETE FROM pvDB.pv_proposalTypes;
DBCC CHECKIDENT ('pvDB.pv_proposalTypes', RESEED, 0);
DELETE FROM pvDB.pv_proposalStatus;



-- Propuestas

INSERT INTO pvDB.pv_proposalStatus (proposalStatusID, [name]) VALUES
(1, 'Pendiente de validacion'),
(2, 'Aprobado'),
(3, 'Rechazado'),
(4, 'Ejecutando'),
(5, 'Obsoleto');

INSERT INTO pvDB.pv_proposalTypes ([type]) VALUES
('Decision administrativa'),
('Proyecto municipal'),
('Reforma legal'),
('Innovacion'),
('Reglamento'),
('Admision');

GO
DECLARE @statusEjec SMALLINT = (SELECT proposalStatusID FROM pvDB.pv_proposalStatus WHERE [name] = 'Ejecutando');
DECLARE @statusPend SMALLINT = (SELECT proposalStatusID FROM pvDB.pv_proposalStatus WHERE [name] = 'Pendiente de validacion'); 
DECLARE @statusObso SMALLINT = (SELECT proposalStatusID FROM pvDB.pv_proposalStatus WHERE [name] = 'Obsoleto');

DECLARE @typeInnovacion SMALLINT = (SELECT proposalTypeID FROM pvDB.pv_proposalTypes WHERE [type] = 'Innovacion');
DECLARE @typeMunicipal SMALLINT = (SELECT proposalTypeID FROM pvDB.pv_proposalTypes WHERE [type] = 'Proyecto municipal');

INSERT INTO pvDB.pv_proposals (proposalTypeID, proposalStatusID, title, [description], creationDate, lastUpdate, currentProposal, [version], enableComments) VALUES
(@typeInnovacion, @statusObso, 'Aplicaci�n para conocer Sugars', 'Una aplicaci�n dise�ada para conectar personas interesadas en relaciones de tipo "sugar".', '2022-03-11', '2023-10-24 17:30:00', 0, '1.0', 1),
(@typeInnovacion, @statusEjec, 'Sugar.me', 'Sugar.me es una aplicaci�n para personas con estabilidad financiera que buscan compa��a.', '2023-11-10', CURRENT_TIMESTAMP, 1, '2.0', 1),
(@typeMunicipal, @statusEjec, 'Sem�foros inteligentes en San Jos�', 'Este busca modernizar el sistema de regulaci�n del tr�fico seg�n el flujo vehicular en San Jos�.', '2024-01-01', CURRENT_TIMESTAMP, 1, '1.0', 1),
(@typeMunicipal, @statusEjec, 'Programa de educaci�n para adultos mayores de secundaria en zonas rurales', 'Un programa para combatir los desaf�os educativos y sociales presentes en las regiones de Lim�n y Puntarenas.', '2024-01-01', CURRENT_TIMESTAMP, 1, '1.0', 1),
(@typeMunicipal, @statusEjec, 'Plataforma de comercio para peque�os productores', 'Este proyecto busca desarrollar una plataforma digital que conecte peque�os productores con consumidores y empresas.', '2024-01-01', CURRENT_TIMESTAMP, 1, '1.0', 1),
--> Comentarios no habilitados
(@typeMunicipal, @statusEjec, 'Red de bicicletas compartidas en zonas urbanas', 'Este proyecto busca implementar un sistema de bicicletas compartidas en zonas urbanas de Costa Rica, facilitando el acceso a transporte sostenible y reduciendo la congesti�n vehicular.', '2024-01-01', CURRENT_TIMESTAMP, 1, '1.0', 0);


DECLARE @sugarV1 INT = (SELECT proposalID FROM pvDB.pv_proposals WHERE title = 'Aplicaci�n para conocer Sugars'); 
DECLARE @sugarV2 INT = (SELECT proposalID FROM pvDB.pv_proposals WHERE title = 'Sugar.me'); 
DECLARE @semaforosV1 INT = (SELECT proposalID FROM pvDB.pv_proposals WHERE title = 'Sem�foros inteligentes en San Jos�'); 
DECLARE @educV1 INT = (SELECT proposalID FROM pvDB.pv_proposals WHERE title = 'Programa de educaci�n para adultos mayores de secundaria en zonas rurales'); 
DECLARE @comercioV1 INT = (SELECT proposalID FROM pvDB.pv_proposals WHERE title = 'Plataforma de comercio para peque�os productores'); 
DECLARE @bicisV1 INT = (SELECT proposalID FROM pvDB.pv_proposals WHERE title = 'Red de bicicletas compartidas en zonas urbanas'); 

INSERT INTO pvDB.pv_proposalRecords (lastProposalID, currentProposalID) VALUES
(@sugarV1, @sugarV1),
(@sugarV1, @sugarV2),
(@semaforosV1, @semaforosV1),
(@educV1, @educV1),
(@comercioV1, @comercioV1),
(@bicisV1, @bicisV1);

-- Beneficios e impactos
INSERT INTO pvDB.pv_proposalBenefits (proposalID, [name], [description]) VALUES
(@sugarV1, 'Interacciones seguras', 'La verificaci�n de perfiles garantiza conexiones aut�nticas y reduce riesgos de fraude.'),
(@sugarV1, 'Conexiones personalizadas', 'Los usuarios pueden encontrar acuerdos que se ajusten a sus necesidades y expectativas.'),
(@sugarV1, 'Oportunidades de apoyo financiero', 'Los beneficiarios pueden recibir respaldo econ�mico para estudios, emprendimientos o estilo de vida.'),
(@sugarV2, 'Interacciones seguras', 'La verificaci�n de perfiles garantiza conexiones aut�nticas y reduce riesgos de fraude.'),
(@sugarV2, 'Conexiones personalizadas', 'Los usuarios pueden encontrar acuerdos que se ajusten a sus necesidades y expectativas.'),
(@sugarV2, 'Oportunidades de apoyo financiero', 'Los beneficiarios pueden recibir respaldo econ�mico para estudios, emprendimientos o estilo de vida.'),
(@semaforosV1, 'Menos tiempo en el tr�fico', 'Los conductores experimentar�n tiempos de espera reducidos en intersecciones congestionadas.'),
(@semaforosV1, 'Mayor seguridad vial', 'La regulaci�n din�mica de los sem�foros disminuir� accidentes en zonas de alto riesgo.'),
(@semaforosV1, 'Menos contaminaci�n', 'Al reducir el tiempo de espera, los veh�culos consumir�n menos combustible.'),
(@educV1, 'Acceso a educaci�n sin barreras', 'Adultos mayores podr�n completar su educaci�n secundaria sin necesidad de trasladarse largas distancias.'),
(@educV1, 'Mejores oportunidades laborales', 'Obtener un t�tulo de secundaria les permitir� acceder a empleos o emprendimientos con mayor facilidad.'),
(@educV1, 'Mayor integraci�n social', 'La educaci�n fomenta la participaci�n en actividades comunitarias y mejora la calidad de vida.'),
(@comercioV1, 'Transporte accesible y econ�mico', 'Alternativa m�s barata que los veh�culos privados y el transporte p�blico.'),
(@comercioV1, 'Movilidad r�pida en la ciudad', 'Evita congestiones y permite desplazamientos eficientes en zonas urbanas.'),
(@comercioV1, 'Beneficio para la salud', 'Fomenta el ejercicio y mejora la condici�n f�sica de los usuarios.'),
(@bicisV1, 'Acceso a productos locales de calidad', 'Los consumidores pueden comprar directamente a productores sin intermediarios.'),
(@bicisV1, 'Pagos digitales seguros', 'Facilita transacciones r�pidas y confiables sin necesidad de efectivo.'),
(@bicisV1, 'Precios m�s accesibles', 'Al eliminar intermediarios, los usuarios pueden adquirir productos a costos m�s bajos.');


INSERT INTO pvDB.pv_impactedEntityTypes (impactedEntityTypeID, [name]) VALUES
(1, 'Pais'),
(2, 'Provincia'),
(3, 'Canton'),
(4, 'Distrito'),
(5, 'Barrio'),
(6, 'Grupo etario');

DECLARE @idPais int = (SELECT impactedEntityTypeID FROM pvDB.pv_impactedEntityTypes WHERE [name] = 'Pais'); 
DECLARE @idProv int = (SELECT impactedEntityTypeID FROM pvDB.pv_impactedEntityTypes WHERE [name] = 'Provincia'); 
DECLARE @idCant int = (SELECT impactedEntityTypeID FROM pvDB.pv_impactedEntityTypes WHERE [name] = 'Canton'); 
DECLARE @idDist int = (SELECT impactedEntityTypeID FROM pvDB.pv_impactedEntityTypes WHERE [name] = 'Distrito'); 
DECLARE @idBarr int = (SELECT impactedEntityTypeID FROM pvDB.pv_impactedEntityTypes WHERE [name] = 'Barrio'); 
DECLARE @idGrupoEt int = (SELECT impactedEntityTypeID FROM pvDB.pv_impactedEntityTypes WHERE [name] = 'Grupo etario'); 

INSERT INTO pvDB.pv_proposalImpacts (proposalID, impactedEntityTypeID, [name], [description], [value]) VALUES
(@sugarV1, @idGrupoEt, '4.4% de adultos jovenes', 'Habr� un impacto en adultos j�venes de 18 a 25 a�os con interes en una relaci�n "sugar", siendo alrededor del 4.4% de la poblaci�n objetiva', 4.4),
(@sugarV1, @idGrupoEt, '4.6% de adultos financialmente estables', 'Habr� un impacto en adultos mayores a 45 a�os con interes en una relaci�n "sugar", siendo alrededor del 4.6% de la poblaci�n objetiva', 4.6),
(@sugarV2, @idGrupoEt, '4.4% de adultos jovenes', 'Habr� un impacto en adultos j�venes de 18 a 25 a�os con interes en una relaci�n "sugar", siendo alrededor del 4.4% de la poblaci�n objetiva', 4.4),
(@sugarV2, @idGrupoEt, '4.6% de adultos financialmente estables', 'Habr� un impacto en adultos mayores a 45 a�os con interes en una relaci�n "sugar", siendo alrededor del 4.6% de la poblaci�n objetiva', 4.6),
(@semaforosV1, @idPais, '11% de la poblaci�n de Costa Rica', 'Existe un impacto del 11% para toda la poblaci�n de Costa Rica que transita en San Jos� todos los d�as.', 11.0),
(@educV1, @idProv, '7.4% de adultos mayores en Puntarenas', 'La propuesta har� un impacto en Puntarenas de un 7.4% de la poblaci�n adulta mayor que carece de educaci�n secundaria', 7.4),
(@educV1, @idProv, '7.7% de adultos mayores en Lim�n', 'La propuesta har� un impacto en Lim�n de un 7.7% de la poblaci�n adulta mayor que carece de educaci�n secundaria', 7.7),
(@comercioV1, @idProv, '26.9% de los productores peque�os en Cartago', 'El impacto en Cartago de la propuesta ser� de aproximadamente un 26.9% que forman el grupo de productores peque�os que usen la aplicaci�n.', 26.9),
(@comercioV1, @idCant, '7% de la poblaci�n en Turrialba', 'La propuesta impactar� un 7% de la poblaci�n de Turrialba, que incluye tanto compradores como vendedores que instalen la aplicaci�n.', 7.0),
(@bicisV1, @idPais, '22% de la poblaci�n de Costa Rica', 'La propuesta tendr� un impacto en el 22% de las personas en Costa Rica que se movilizan en bicicletas.', 22.0);

-- Planes de ejecucion y Milestones

INSERT INTO pvDB.pv_timeUnits ([name]) VALUES
('Minuto'),
('Hora'),
('Dia'),
('Semana'),
('Mes'),
('A�o');

INSERT INTO pvDB.pv_KPITypes ([name], datatype) VALUES
('Beneficiarios atendidos', 'INT');

-- Conexion propuestas y demografias
DECLARE @idTipoEdad int = (SELECT demographicTypeID FROM pvDB.pv_demographicTypes WHERE targetType = 'Edad');
DECLARE @idTipoSexo int = (SELECT demographicTypeID FROM pvDB.pv_demographicTypes WHERE targetType = 'Sexo');
DECLARE @idTipoEducacion int = (SELECT demographicTypeID FROM pvDB.pv_demographicTypes WHERE targetType = 'Educacion');
DECLARE @idTipoNacionalidad int = (SELECT demographicTypeID FROM pvDB.pv_demographicTypes WHERE targetType = 'Nacionalidad');

DECLARE @idCRNacionalidad int = (SELECT nationalityID FROM pvDB.pv_nationalities WHERE [name] = 'Costarricense');
DECLARE @idGenBas int = (SELECT educationLevelID FROM pvDB.pv_educationLevels WHERE educationLevel = 'Educacion General Basica');


DECLARE @demoCR int = (SELECT targetDemographicID FROM pvDB.pv_targetDemographics WHERE demographicTypeID = @idTipoNacionalidad AND [value] = @idCRNacionalidad);
DECLARE @demoEduc int = (SELECT targetDemographicID FROM pvDB.pv_targetDemographics WHERE demographicTypeID = @idTipoEducacion AND [value] = @idGenBas);
DECLARE @demo40a65 int = (SELECT targetDemographicID FROM pvDB.pv_targetDemographics WHERE demographicTypeID = @idTipoEdad AND [value] = 40 AND maxRange = 65);
DECLARE @demo18a25 int = (SELECT targetDemographicID FROM pvDB.pv_targetDemographics WHERE demographicTypeID = @idTipoEdad AND [value] = 18 AND maxRange = 25);
DECLARE @demo60plus int = (SELECT targetDemographicID FROM pvDB.pv_targetDemographics WHERE demographicTypeID = @idTipoEdad AND [value] = 60 AND maxRange IS NULL);
DECLARE @demo24plus int = (SELECT targetDemographicID FROM pvDB.pv_targetDemographics WHERE demographicTypeID = @idTipoEdad AND [value] = 24 AND maxRange IS NULL);

INSERT INTO pvDB.pv_proposalDemographics (proposalID, targetDemographicID, creationDate, deleted) VALUES
(@sugarV1, @demo18a25, CURRENT_TIMESTAMP, 0),
(@sugarV1, @demo40a65, CURRENT_TIMESTAMP, 0),
(@sugarV2, @demo18a25, CURRENT_TIMESTAMP, 0),
(@sugarV2, @demo40a65, CURRENT_TIMESTAMP, 0),
(@semaforosV1, @demoCR, CURRENT_TIMESTAMP, 0),
(@semaforosV1, @demo24plus, CURRENT_TIMESTAMP, 0),
(@educV1, @demoCR, CURRENT_TIMESTAMP, 0),
(@educV1, @demo60plus, CURRENT_TIMESTAMP, 0),
(@educV1, @demoEduc, CURRENT_TIMESTAMP, 0),
(@comercioV1, @demoCR, CURRENT_TIMESTAMP, 0),
(@bicisV1, @demoCR, CURRENT_TIMESTAMP, 0);

GO

