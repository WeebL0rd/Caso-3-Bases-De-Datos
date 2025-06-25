USE pvDB;
GO

SET IDENTITY_INSERT pvDB.pv_mediaTypes ON;
INSERT INTO pvDB.pv_mediaTypes (mediaTypeID, type)
VALUES
(1, 'Imagen'),
(2, 'Video'),
(3, 'PDF'),
(4, 'Docx');
GO
SET IDENTITY_INSERT pvDB.pv_mediaTypes OFF;
GO

INSERT INTO pvDB.pv_documentTypes (documentTypeID, documentType, daysUntilRenewal) VALUES
(1, 'Identificación Oficial', 1460),
(2, 'Personería Jurídica', 365),
(3, 'Documento de Propuesta', 30),
(4, 'Anexo de Comentario', 120),
(5, 'Carta de Aval Municipal', 90); 
GO

INSERT INTO pvDB.pv_documentStatus (documentStatusID, name) VALUES
(1, 'Pendiente de revision'),
(2, 'Aprobado'),
(3, 'Bajo revisión'),
(4, 'Rechazado'),
(5, 'Eliminado');
GO

SET IDENTITY_INSERT pvDB.pv_mediaFile ON;
INSERT INTO pvDB.pv_mediaFile (mediaFileID, encryptedUrl, mediaTypeID)
VALUES
(1, 0xA1B2C3D4E5F60718293A4B5C6D7E8F90, 1),
(2, 0xB1C2D3E4F5061728394A5B6C7D8E9F01, 3),
(3, 0xC1D2E3F405061728394A5B6C7D8E9F02, 3),
(4, 0xD1E2F30405061728394A5B6C7D8E9F03, 1),
(5, 0xE1F2030405061728394A5B6C7D8E9F04, 3),
(6, 0xF102030405061728394A5B6C7D8E9F05, 1),
(7, 0x0102030405061728394A5B6C7D8E9F06, 1),
(8, 0x102030405061728394A5B6C7D8E9F070, 3),
(9, 0x2030405061728394A5B6C7D8E9F07081, 4),
(10, 0x30405061728394A5B6C7D8E9F0708192, 3),
(11, 0x405061728394A5B6C7D8E9F0708192A3, 3),
(12, 0x5061728394A5B6C7D8E9F0708192A3B4, 3),
(13, 0x61728394A5B6C7D8E9F0708192A3B4C5, 4),
(14, 0x728394A5B6C7D8E9F0708192A3B4C5D6, 4),
(15, 0x8394A5B6C7D8E9F0708192A3B4C5D6E7, 3),
(16, 0x94A5B6C7D8E9F0708192A3B4C5D6E7F8, 4),
(17, 0xA5B6C7D8E9F0708192A3B4C5D6E7F809, 3);
SET IDENTITY_INSERT pvDB.pv_mediaFile OFF;
GO

INSERT INTO pvDB.pv_documents (documentTypeID, mediaFileID, documentStatusID, nombreArchivo, uploadDate, deleted, version, renewalDate) VALUES
(1, 1, 1, 'ID_LuisGarcia.png', GETDATE(), 0, '1.3', DATEADD(day, 1460, GETDATE())),
(3, 2, 1, 'ID_HectorSoto.pdf', GETDATE(), 0, '1.6', DATEADD(day, 1460, GETDATE())),
(3, 3, 2, 'ID_JuanPerez.pdf', GETDATE(), 0, '1.8', DATEADD(day, 1460, GETDATE())),
(1, 4, 2, 'ID_LauraFernandez.png', GETDATE(), 0, '2.0', DATEADD(day, 1460, GETDATE())),
(3, 5, 2, 'ID_MiguelVazquez.pdf', GETDATE(), 0, '4.1', DATEADD(day, 1460, GETDATE())),
(1, 6, 3, 'ID_CarlosRodriguez.png', GETDATE(), 0, '1.0', DATEADD(day, 1460, GETDATE())),
(1, 7, 4, 'ID_DanielaFlores.png', GETDATE(), 0, '1.2', DATEADD(day, 1460, GETDATE())),
(3, 8, 5, 'ID_JorgeCastro.pdf', GETDATE(), 0, '1.0', DATEADD(day, 1460, GETDATE())),
(4, 9, 2, 'Personeria_MOPT.docx', GETDATE(), 0, '1.0', DATEADD(day, 365, GETDATE())),
(3, 10, 2, 'Personeria_TechInnovators.pdf', GETDATE(), 0, '2.2', DATEADD(day, 365, GETDATE())),
(3, 11, 2, 'Propuesta_Semaforos_Inteligentes.pdf', GETDATE(), 0, '3.0', DATEADD(day, 30, GETDATE())),
(3, 12, 2, 'Propuesta_Educacion_Adultos.pdf', GETDATE(), 0, '1.0', DATEADD(day, 30, GETDATE())),
(4, 13, 2, 'Propuesta_SugarMe_v1.docx', GETDATE(), 0, '1.1', DATEADD(day, 30, GETDATE())),
(4, 14, 2, 'Propuesta_SugarMe_v2.docx', GETDATE(), 0, '1.4', DATEADD(day, 30, GETDATE())),
(3, 15, 2, 'Propuesta_Plataforma_Comercio.pdf', GETDATE(), 0, '1.9', DATEADD(day, 30, GETDATE())),
(4, 16, 2, 'Propuesta_Bicicletas_Urbanas.docx', GETDATE(), 0, '1.0', DATEADD(day, 30, GETDATE())),
(3, 17, 2, 'Estudio_Uso_Bicicletas.pdf', GETDATE(), 0, '6.9', DATEADD(day, 15, GETDATE()));
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

INSERT INTO pvDB.pv_organizationDocuments (organizationID, documentID) VALUES
(1, @docID_MOPT), -- MOPT's Personería Jurídica
(2, @docID_TechInc), -- Tech Innovators Inc.'s
(1, @docID_Semaf), -- Semáforos inteligentes - MOPT
(1, @docID_Bicis), -- Bicicletas compartidas - MOPT
(2, @docID_SugarV2); -- Sugar.me v2 - Tech Innovators Inc.

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

SET IDENTITY_INSERT pvDB.pv_entityType ON;
INSERT INTO pvDB.pv_entityType (entityTypeID, entity) VALUES
(1, 'Ciudadano'),
(2, 'Organización'),
(3, 'Gobierno'),
(4, 'Inversionista'),
(5, 'Aceleradora'),
(6, 'Incubadora'),
(7, 'Auditoría');
SET IDENTITY_INSERT pvDB.pv_entityType OFF;
GO

DECLARE @docTypePersoneria INT = (SELECT documentTypeID FROM pvDB.pv_documentTypes WHERE documentType = 'Personería Jurídica');
DECLARE @docTypeCartaAval INT = (SELECT documentTypeID FROM pvDB.pv_documentTypes WHERE documentType = 'Carta de Aval Municipal');
INSERT INTO pvDB.pv_requiredDocuments (documentTypeID, entityTypeID, mandatory) VALUES
(@docTypePersoneria, 6, 1), -- Incubadora
(@docTypePersoneria, 2, 1), -- Con fines de lucro
(@docTypePersoneria, 2, 0), -- Sin fines de lucro
(@docTypeCartaAval, 3, 1), -- Ministerios
(@docTypeCartaAval, 3, 0); -- Municipalidades
GO
