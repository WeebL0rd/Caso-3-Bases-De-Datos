use pvDB;

-- conectar organizaciones, usuarios y propuestas
DECLARE @sugarV1 INT = (SELECT proposalID FROM pvDB.pv_proposals WHERE title = 'Aplicaci�n para conocer Sugars'); 
DECLARE @sugarV2 INT = (SELECT proposalID FROM pvDB.pv_proposals WHERE title = 'Sugar.me'); 
DECLARE @semaforosV1 INT = (SELECT proposalID FROM pvDB.pv_proposals WHERE title = 'Sem�foros inteligentes en San Jos�'); 
DECLARE @educV1 INT = (SELECT proposalID FROM pvDB.pv_proposals WHERE title = 'Programa de educaci�n para adultos mayores de secundaria en zonas rurales'); 
DECLARE @comercioV1 INT = (SELECT proposalID FROM pvDB.pv_proposals WHERE title = 'Plataforma de comercio para peque�os productores'); 
DECLARE @bicisV1 INT = (SELECT proposalID FROM pvDB.pv_proposals WHERE title = 'Red de bicicletas compartidas en zonas urbanas'); 

DECLARE @orgMOPT INT = (SELECT organizationID FROM pvDB.pv_organizations WHERE legalName = 'Ministerio de Obras P�blicas y Transportes'); 

INSERT INTO pvDB.pv_organizationProposals (proposalID, organizationID) VALUES
(@semaforosV1, @orgMOPT),
(@bicisV1, @orgMOPT);

INSERT INTO pvDB.pv_UserProposals (proposalID, userID) VALUES
(@sugarV1, 10),    -- Miguel V�zquez (Identificaci�n verificada)
(@sugarV2, 10),    -- Miguel V�zquez (Identificaci�n verificada)
(@educV1, 5),     -- Laura Fern�ndez (Identificaci�n verificada)
(@comercioV1, 10); -- Miguel V�zquez (Identificaci�n verificada)
