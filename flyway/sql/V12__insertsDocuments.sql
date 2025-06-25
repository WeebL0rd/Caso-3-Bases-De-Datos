USE pvDB;
GO

INSERT INTO pvDB.pv_mediaTypes (mediaTypeID, type)
VALUES
(1, 'Imagen'),
(2, 'Video'),
(3, 'PDF'),
(4, 'Docx');
GO

INSERT INTO pvDB.pv_documentTypes (documentTypeID, documentType, daysUntilRenewal) VALUES
(1, 'Identificación Oficial', 1460),
(2, 'Personería Jurídica', 365),
(3, 'Documento de Propuesta', 30),
(4, 'Anexo de Comentario', NULL),
(5, 'Carta de Aval Municipal', 90); 
GO

INSERT INTO pvDB.pv_documentStatus (documentStatusID, name) VALUES
(1, 'Pendiente de revision'),
(2, 'Aprobado'),
(3, 'Bajo revisión'),
(4, 'Rechazado'),
(5, 'Eliminado');
GO

INSERT INTO pvDB.pv_mediaFile (mediaFileID, mediaTypeID, mediaTypeID) VALUES
(8, 1, 1),
(9, 3, 3),
(10, 3, 3),
(11, 1, 1),
(12, 3, 3),
(13, 1, 1),
(14, 1, 1),
(15, 3, 3),
(16, 4, 4),
(17, 3, 3),
(18, 3, 3),
(19, 3, 3),
(20, 4, 4),
(21, 4, 4),
(22, 3, 3),
(23, 4, 4),
(24, 3, 3);
GO

INSERT INTO pvDB.pv_documents (documentID, documentTypeID, mediaFileID, documentStatusID, nombreArchivo, uploadDate, deleted, version, renewalDate) VALUES
(7, 1, 8, 1, 'ID_LuisGarcia.png', GETDATE(), 0, '1.0', DATEADD(day, 1460, GETDATE())),
(8, 1, 9, 1, 'ID_HectorSoto.pdf', GETDATE(), 0, '1.0', DATEADD(day, 1460, GETDATE())),
(9, 1, 10, 2, 'ID_JuanPerez.pdf', GETDATE(), 0, '1.0', DATEADD(day, 1460, GETDATE())),
(10, 1, 11, 2, 'ID_LauraFernandez.png', GETDATE(), 0, '1.0', DATEADD(day, 1460, GETDATE())),
(11, 1, 12, 2, 'ID_MiguelVazquez.pdf', GETDATE(), 0, '1.0', DATEADD(day, 1460, GETDATE())),
(12, 1, 13, 3, 'ID_CarlosRodriguez.png', GETDATE(), 0, '1.0', DATEADD(day, 1460, GETDATE())),
(13, 1, 14, 4, 'ID_DanielaFlores.png', GETDATE(), 0, '1.0', DATEADD(day, 1460, GETDATE())),
(14, 1, 15, 5, 'ID_JorgeCastro.pdf', GETDATE(), 0, '1.0', DATEADD(day, 1460, GETDATE())),
(15, 2, 16, 2, 'Personeria_MOPT.docx', GETDATE(), 0, '1.0', DATEADD(day, 365, GETDATE())),
(16, 2, 17, 2, 'Personeria_TechInnovators.pdf', GETDATE(), 0, '1.0', DATEADD(day, 365, GETDATE())),
(17, 3, 18, 2, 'Propuesta_Semaforos_Inteligentes.pdf', GETDATE(), 0, '1.0', DATEADD(day, 30, GETDATE())),
(18, 3, 19, 2, 'Propuesta_Educacion_Adultos.pdf', GETDATE(), 0, '1.0', DATEADD(day, 30, GETDATE())),
(19, 3, 20, 2, 'Propuesta_SugarMe_v1.docx', GETDATE(), 0, '1.0', DATEADD(day, 30, GETDATE())),
(20, 3, 21, 2, 'Propuesta_SugarMe_v2.docx', GETDATE(), 0, '1.0', DATEADD(day, 30, GETDATE())),
(21, 3, 22, 2, 'Propuesta_Plataforma_Comercio.pdf', GETDATE(), 0, '1.0', DATEADD(day, 30, GETDATE())),
(22, 3, 23, 2, 'Propuesta_Bicicletas_Urbanas.docx', GETDATE(), 0, '1.0', DATEADD(day, 30, GETDATE())),
(23, 4, 24, 2, 'Estudio_Uso_Bicicletas.pdf', GETDATE(), 0, '1.0', NULL);
GO

DECLARE @docID_Luis INT = (SELECT documentID FROM pvDB.pv_documents WHERE nombreArchivo = 'ID_LuisGarcia.png');
DECLARE @docID_Hector INT = (SELECT documentID FROM pvDB.pv_documents WHERE nombreArchivo = 'ID_HectorSoto.pdf');
DECLARE @docID_Juan INT = (SELECT documentID FROM pvDB.pv_documents WHERE nombreArchivo = 'ID_JuanPerez.pdf');
DECLARE @docID_Laura INT = (SELECT documentID FROM pvDB.pv_documents WHERE nombreArchivo = 'ID_LauraFernandez.png');
DECLARE @docID_Miguel INT = (SELECT documentID FROM pvDB.pv_documents WHERE nombreArchivo = 'ID_MiguelVazquez.pdf');
DECLARE @docID_Carlos INT = (SELECT documentID FROM pvDB.pv_documents WHERE nombreArchivo = 'ID_CarlosRodriguez.png');
DECLARE @docID_Daniela INT = (SELECT documentID FROM pvDB.pv_documents WHERE nombreArchivo = 'ID_DanielaFlores.png');
DECLARE @docID_Jorge INT = (SELECT documentID FROM pvDB.pv_documents WHERE nombreArchivo = 'ID_JorgeCastro.pdf');
DECLARE @docID_MOPT INT = (SELECT documentID FROM pvDB.pv_documents WHERE nombreArchivo = 'Personeria_MOPT.docx');
DECLARE @docID_TechInc INT = (SELECT documentID FROM pvDB.pv_documents WHERE nombreArchivo = 'Personeria_TechInnovators.pdf');
DECLARE @docID_Semaf INT = (SELECT documentID FROM pvDB.pv_documents WHERE nombreArchivo = 'Propuesta_Semaforos_Inteligentes.pdf');
DECLARE @docID_Educ INT = (SELECT documentID FROM pvDB.pv_documents WHERE nombreArchivo = 'Propuesta_Educacion_Adultos.pdf');
DECLARE @docID_SugarV1 INT = (SELECT documentID FROM pvDB.pv_documents WHERE nombreArchivo = 'Propuesta_SugarMe_v1.docx');
DECLARE @docID_SugarV2 INT = (SELECT documentID FROM pvDB.pv_documents WHERE nombreArchivo = 'Propuesta_SugarMe_v2.docx');
DECLARE @docID_Comercio INT = (SELECT documentID FROM pvDB.pv_documents WHERE nombreArchivo = 'Propuesta_Plataforma_Comercio.pdf');
DECLARE @docID_Bicis INT = (SELECT documentID FROM pvDB.pv_documents WHERE nombreArchivo = 'Propuesta_Bicicletas_Urbanas.docx');
DECLARE @docID_CommentStudy INT = (SELECT documentID FROM pvDB.pv_documents WHERE nombreArchivo = 'Estudio_Uso_Bicicletas.pdf');

INSERT INTO pvDB.pv_userDocuments (userID, documentID) VALUES
(1, @docID_Luis), -- (Pendiente de revision)
(2, @docID_Hector), --(Pendiente)
(3, @docID_Juan), -- (Verified)
(5, @docID_Laura), -- (Verified)
(10, @docID_Miguel), -- (Verified)
(23, @docID_Carlos), -- (Bajo revisión)
(24, @docID_Daniela); -- (Rechazado)
GO

INSERT INTO pvDB.pv_organizationDocuments (organizationID, documentID) VALUES
(1, @docID_MOPT), -- MOPT's Personería Jurídica
(2, @docID_TechInc), -- Tech Innovators Inc.'s
(1, @docID_Semaf), -- Semáforos inteligentes - MOPT
(1, @docID_Bicis), -- Bicicletas compartidas - MOPT
(2, @docID_SugarV2); -- Sugar.me v2 - Tech Innovators Inc.
GO

DECLARE @propSugarV1 INT = (SELECT proposalID FROM pvDB.pv_proposals WHERE title = 'Aplicación para conocer Sugars');
DECLARE @propSugarV2 INT = (SELECT proposalID FROM pvDB.pv_proposals WHERE title = 'Sugar.me');
DECLARE @propSemaf INT = (SELECT proposalID FROM pvDB.pv_proposals WHERE title = 'Semáforos inteligentes en San José');
DECLARE @propEduc INT = (SELECT proposalID FROM pvDB.pv_proposals WHERE title = 'Programa de educación para adultos mayores de secundaria en zonas rurales');
DECLARE @propComercio INT = (SELECT proposalID FROM pvDB.pv_proposals WHERE title = 'Plataforma de comercio para pequeños productores');
DECLARE @propBicis INT = (SELECT proposalID FROM pvDB.pv_proposals WHERE title = 'Red de bicicletas compartidas en zonas urbanas');

INSERT INTO pvDB.pv_proposalDocuments (proposalID, documentID) VALUES
(@propSemaf, @docID_Semaf), -- Semáforos proposal
(@propEduc, @docID_Educ), -- Adult Education proposal
(@propSugarV1, @docID_SugarV1), -- Sugar.me v1 proposal
(@propSugarV2, @docID_SugarV2), -- Sugar.me v2 proposal
(@propComercio,@docID_Comercio), -- Commerce Platform
(@propBicis, @docID_Bicis); -- Bike Sharing proposal
GO

INSERT INTO pvDB.pv_entityType (entityTypeID, entity) VALUES
(1, 'Ciudadano'),
(2, 'Organización'),
(3, 'Gobierno'),
(4, 'Inversionista'),
(5, 'Aceleradora'),
(6, 'Incubadora'),
(7, 'Auditoría');
GO

DECLARE @docTypePersoneria INT = (SELECT documentTypeID FROM pvDB.pv_documentTypes WHERE documentType = 'Personería Jurídica');
DECLARE @docTypeCartaAval INT = (SELECT documentTypeID FROM pvDB.pv_documentTypes WHERE documentType = 'Carta de Aval Municipal');
INSERT INTO pvDB.pv_requiredDocuments (requiredDocumentID, documentTypeID, entityTypeID, mandatory) VALUES
(1, @docTypePersoneria, 6, 1), -- Incubadora
(2, @docTypePersoneria, 2, 1), -- Con fines de lucro
(3, @docTypePersoneria, 2, 0), -- Sin fines de lucro
(4, @docTypeCartaAval, 3, 1), -- Ministerios
(5, @docTypeCartaAval, 3, 0); -- Municipalidades
GO