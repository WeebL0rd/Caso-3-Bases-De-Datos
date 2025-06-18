USE pvDB;
GO

-- Tipos de organizaciones
INSERT INTO pvDB.pv_organizationTypes (organizationTypeID, type) VALUES
(1,'Incubadora'),
(2, 'Con fines de lucro'),
(3, 'Sin fines de lucro'),
(4, 'Ministerios'),
(5,'Municipalidades');
GO

-- Status de organizaciones
INSERT INTO pvDB.pv_organizationStatuses (status) VALUES
('Pendiente de revision'),
('Activo'),
('Bajo revisión'),
('Rechazado'),
('Eliminado');
GO

INSERT INTO pvDB.pv_organizations (name, legalName, dateRegister, registryNumber, description, userId, organizationTypeId, statusID) VALUES
-- 1. MOPT (Ministerio de Obras Públicas y Transportes) - Ministerio
('MOPT', 'Ministerio de Obras Públicas y Transportes', '2020-01-15', 100123456, 'Ministerio encargado de la infraestructura vial y transporte de Costa Rica.', 5, 4, 2), -- UserID 5, Type: Ministerios, Status: Activo
-- 2. Tech Innovators Inc. - Incubadora
('Tech Innovators', 'Tech Innovators S.A.', '2023-06-01', 300456789, 'Empresa dedicada a la incubación y aceleración de startups tecnológicas.', 10, 1, 2); -- UserID 10, Type: Incubadora, Status: Activo
GO


