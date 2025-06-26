USE pvDB;
GO

SET IDENTITY_INSERT pvDB.pv_workflowTypes ON;
INSERT INTO pvDB.pv_workflowTypes (workflowTypeID, type) VALUES
(1, 'Verificación de Documento de Usuario'), -- Verificación de documentos subidos por usuarios
(2, 'Verificación de Documento de Organización'), -- Verificación de documentos de organizaciones
(3, 'Verificación de Documento de Propuesta'); -- Verificación de documentos de organizaciones
SET IDENTITY_INSERT pvDB.pv_workflowTypes OFF;
GO

SET IDENTITY_INSERT pvDB.pv_workflows ON;
INSERT INTO pvDB.pv_workflows (workflowID, name, description, endpointUrl, enabled, workflowTypeID) VALUES
(1, 'Flujo Verificación Documento Usuario', '', '', 1, 1),
(2, 'Flujo Verificación Documento Organización', '', '', 1, 2),
(3, 'Flujo Verificación Documento Propuesta', '', '', 1, 3);
SET IDENTITY_INSERT pvDB.pv_workflows OFF;
GO

INSERT INTO pvDB.pv_workflowParameters (workflowID, parameter, dataType, required, description, defaultValue) VALUES
(1, 'ApproversRequired', 'STRING', 1, 'Número de aprobadores requerido', '1'),
(1, 'AutoApproveDays', 'STRING', 1, 'Días para autoaprobación automática', '7'),
(2, 'ApproversRequired', 'STRING', 1, 'Número de aprobadores requerido (revisión dual)', '2'),
(2, 'AutoApproveDays', 'STRING', 1, 'Días para autoaprobación automática', '14');
GO

INSERT INTO pvDB.pv_documentTypeWorkflows (documentTypeID, workflowID, deleted, lastUpdate) VALUES
(1, 1, 0, GETDATE()), -- Documentos de Identificación Oficial
(2, 2, 0, GETDATE()), -- Documentos de Personería Jurídica
(3, 3, 0, GETDATE()); -- Documentos de Generales de Propuesta
GO

INSERT INTO pvDB.pv_workflowHeaders (workflowID, name, value) VALUES
(1, 'Luis Revisión', 'Pendiente de revisión'),
(1, 'Hector Revisión', 'Pendiente de revisión'),
(1, 'Juan Aprobado', 'Aprobado'),
(1, 'Laura Aprobado', 'Aprobado'),
(1, 'Miguel Aprobado', 'Aprobado'),
(1, 'Carlos Revisión', 'Revisión Escalada'),
(1, 'Daniela Rechazado', 'Rechazado'),
(2, 'MOPT Revision', 'Revision completada'),
(2, 'TechInnovators Revision', 'Revision completada');
GO
