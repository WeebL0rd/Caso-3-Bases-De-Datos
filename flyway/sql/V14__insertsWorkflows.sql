USE pvDB;
GO

INSERT INTO pvDB.pv_workflowTypes (workflowTypeID, type) VALUES
(1, 'Verificaci�n de Documento de Usuario'), -- Verificaci�n de documentos subidos por usuarios
(2, 'Verificaci�n de Documento de Organizaci�n'); -- Verificaci�n de documentos de organizaciones
GO

INSERT INTO pvDB.pv_workflows (workflowID, name, description, endpointUrl, enabled, workflowTypeID) VALUES
(3, 'Flujo Verificaci�n Documento Usuario', '', '', 1, 1),
(4, 'Flujo Verificaci�n Documento Organizaci�n', '', '', 1, 2);
GO

INSERT INTO pvDB.pv_workflowParameters (parameterID, workflowID, parameter, dataType, required, description, defaultValue) VALUES
(3, 3, 'ApproversRequired', 'STRING', 1, 'N�mero de aprobadores requerido', '1'),
(4, 3, 'AutoApproveDays', 'STRING', 1, 'D�as para autoaprobaci�n autom�tica', '7'),
(5, 4, 'ApproversRequired', 'STRING', 1, 'N�mero de aprobadores requerido (revisi�n dual)', '2'),
(6, 4, 'AutoApproveDays', 'STRING', 1, 'D�as para autoaprobaci�n autom�tica', '14');
GO

INSERT INTO pvDB.pv_documentTypeWorkflows (documentTypeWorkflowID, documentTypeID, workflowID, deleted, lastUpdate) VALUES
(3, 1, 3, 0, GETDATE()), -- Documentos de Identificaci�n Oficial
(4, 2, 4, 0, GETDATE()); -- Documentos de Personer�a Jur�dica
GO

INSERT INTO pvDB.pv_workflowHeaders (headerID, workflowID, name, value) VALUES
(1, 1, 'Luis Revisi�n', 'Pendiente de revisi�n'),
(2, 1, 'Hector Revisi�n', 'Pendiente de revisi�n'),
(3, 1, 'Juan Aprobado', 'Aprobado'),
(4, 1, 'Laura Aprobado', 'Aprobado'),
(5, 1, 'Miguel Aprobado', 'Aprobado'),
(6, 1, 'Carlos Revisi�n', 'Revisi�n Escalada'),
(7, 1, 'Daniela Rechazado', 'Rechazado'),
(8, 2, 'MOPT Revision', 'Revision completada'),
(9, 2, 'TechInnovators Revision', 'Revision completada');
GO