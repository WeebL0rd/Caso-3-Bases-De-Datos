-- NO MIGRAR TODAV�A SI PIENSAN QUE HAY QUE AGREGARLE UN "FILENAME" A LOS DOCUMENTS
-- TENGO OTRA VERSI�N CON "FILENAME" INCLUIDO, PONGO COMENTARIO PORQUE LUEGO SE ME
-- OLVIDA PREGUNAR QUE LES PARECE

USE pvDB;
GO

INSERT INTO pvDB.pv_mediaTypes (mediaTypeID, type) VALUES
(1, 'Imagen'),
(2, 'Video'),
(3, 'PDF'),
(4, 'Docx');
GO

INSERT INTO pvDB.pv_documentTypes (documentTypeID, documentType, daysUntilRenewal) VALUES
(1, 'Identificaci�n Oficial', 1460), -- Documento de identidad / 4 a�os de vigencia
(2, 'Personer�a Jur�dica', 365), -- Registro legal de organizaci�n / 1 a�o de vigencia
(3, 'Documento de Propuesta', 30), -- Documento principal de una propuesta / 30 d�as de vigencia
(4, 'Anexo de Comentario', NULL), -- Archivo adjunto a un comentario
(5, 'Carta de Aval Municipal', 90); -- Carta de aval emitida por municipalidad / 90 d�as de vigencia
GO

INSERT INTO pvDB.pv_entityType (entityTypeID, entity) VALUES
  (1, 'Persona'),
  (2, 'Organizaci�n'),
  (3, 'Partido Pol�tico'),
  (4, 'Movimiento Social'),
  (5, 'Sindicato'),
  (6, 'Asociaci�n Civil'),
  (7, 'Municipio');
GO


INSERT INTO pvDB.pv_documentStatus (documentStatusID, name) VALUES
(1, 'Pendiente de revisi�n'),
(2, 'Aprobado'),
(3, 'Bajo revisi�n'),
(4, 'Rechazado'),
(5, 'Eliminado');
GO

INSERT INTO pvDB.pv_mediaFile (mediaFileID, encryptedUrl, mediaTypeID) VALUES
(8, 0x, 1),
(9, 0x, 3),
(10, 0x, 3),
(11, 0x, 1),
(12, 0x, 3),
(13, 0x, 1),
(14, 0x, 1),
(15, 0x, 3),
(16, 0x, 4),
(17, 0x, 3),
(18, 0x, 3),
(19, 0x, 4),
(20, 0x, 4),
(21, 0x, 3),
(22, 0x, 4),
(23, 0x, 4),
(24, 0x, 3);
GO

INSERT INTO pvDB.pv_documents (documentID, documentTypeID, mediaFileID, documentStatusID, uploadDate, deleted, version, renewalDate) VALUES
(7,  1, 8,  1, GETDATE(), 0x00, '1.2', DATEADD(day, 1460, GETDATE())),
(8,  1, 9,  1, GETDATE(), 0x00, '1.12', DATEADD(day, 1460, GETDATE())),
(9,  1, 10, 2, GETDATE(), 0x00, '1.0', DATEADD(day, 1460, GETDATE())),
(10, 1, 11, 2, GETDATE(), 0x00, '1.9', DATEADD(day, 1460, GETDATE())),
(11, 1, 12, 2, GETDATE(), 0x00, '2.0', DATEADD(day, 1460, GETDATE())),
(12, 1, 13, 3, GETDATE(), 0x00, '3.0', DATEADD(day, 1460, GETDATE())),
(13, 1, 14, 4, GETDATE(), 0x00, '1.5', DATEADD(day, 1460, GETDATE())),
(14, 1, 15, 5, GETDATE(), 0x00, '1.0', DATEADD(day, 1460, GETDATE())),
(15, 2, 16, 2, GETDATE(), 0x00, '1.4', DATEADD(day, 365, GETDATE())),
(16, 2, 17, 2, GETDATE(), 0x00, '1.0', DATEADD(day, 365, GETDATE())),
(17, 3, 18, 2, GETDATE(), 0x00, '2.0', DATEADD(day, 30, GETDATE())),
(18, 3, 19, 2, GETDATE(), 0x00, '1.6', DATEADD(day, 30, GETDATE())),
(19, 3, 20, 2, GETDATE(), 0x00, '1.0', DATEADD(day, 30, GETDATE())),
(20, 3, 21, 2, GETDATE(), 0x00, '2.0', DATEADD(day, 30, GETDATE())),
(21, 3, 22, 2, GETDATE(), 0x00, '2.9', DATEADD(day, 30, GETDATE())),
(22, 3, 23, 2, GETDATE(), 0x00, '1.0', DATEADD(day, 30, GETDATE())),
(23, 4, 24, 2, GETDATE(), 0x00, '3.9', NULL);
GO

INSERT INTO pvDB.pv_userDocuments (userDocumentID, userID, documentID) VALUES
(3,  1,  7), -- Luis Garcia (Pendiente de verificaci�n)
(4,  2,  8), -- H�ctor Soto (Pendiente de verificaci�n)
(5,  3,  9), -- Juan P�rez (Identificaci�n verificada)
(6,  5,  10), -- Laura Fern�ndez (Identificaci�n verificada)
(7,  10, 11), -- Miguel V�zquez (Identificaci�n verificada)
(8,  23, 12), -- Carlos Rodr�guez (En revisi�n escalada)
(9,  24, 13); -- Daniela Flores (Identificaci�n rechazada)
GO

INSERT INTO pvDB.pv_organizationDocuments (organizationDocumentID, organizationID, documentID) VALUES
(3, 1, 15), -- (MOPT) - Personer�a Jur�dica
(4, 2, 16), -- (Tech Innovators) - Personer�a Jur�dica
(5, 1, 17), -- (MOPT) - Propuesta "Sem�foros inteligentes"
(6, 1, 22), -- (MOPT) - Propuesta "Red de bicicletas compartidas"
(7, 2, 20); -- (Tech Innovators) - Propuesta "Sugar.me v2"
GO

INSERT INTO pvDB.pv_proposalDocuments (proposalDocumentID, proposalID, documentID) VALUES
(3, 3, 17), -- Documento "Sem�foros inteligentes en San Jos�"
(4, 4, 18), -- Documento "Programa de educaci�n para adultos mayores"
(5, 1, 19), -- Documento "Aplicaci�n para conocer Sugars"
(6, 2, 20), -- Documento "Sugar.me"
(7, 5, 21), -- Documento "Plataforma de comercio para peque�os productores"
(8, 6, 22); -- Documento "Red de bicicletas compartidas en zonas urbanas"
GO

INSERT INTO pvDB.pv_comments (commentID, userID, proposeID, commentStatusID, title, text, date, previousCommentID) VALUES
(3, 8, 6, 1, '', 'Hemos realizado un estudio sobre el uso de bicicletas, adjunto los resultados.', GETDATE(), NULL);
GO

INSERT INTO pvDB.pv_commentDocuments (commentDocID, commentID, documentID) VALUES
(3, 3, 23); 
GO

INSERT INTO pvDB.pv_requiredDocuments (requiredDocumentID, entityTypeID, documentTypeID, mandatory) VALUES
(3, 2, 2, 1), -- Incubadora requiere Personer�a Jur�dica
(4, 2, 2, 1), -- Con fines de lucro requiere Personer�a Jur�dica
(5, 6, 2, 1), -- Sin fines de lucro requiere Personer�a Jur�dica
(6, 2, 2, 1), -- Ministerios requieren Personer�a Jur�dica
(7, 7, 2, 1), -- Municipalidades requieren Personer�a Jur�dica
(8, 7, 5, 1); -- Propuestas de tipo "Proyecto municipal" requieren Carta de Aval Municipal
GO