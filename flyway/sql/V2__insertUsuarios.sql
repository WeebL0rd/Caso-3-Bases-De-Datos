USE pvDB;
GO

-- Estados de usuario
INSERT INTO pvDB.pv_userStatuses (statusID, name) VALUES
(1,'Pendiente de revision'),
(2,'Activo'),
(3,'Inactivo'),
(4,'Bajo revision'),
(5,'Rechazado'),
(6,'Eliminado'),
(7,'Bloqueado'),
(8,'Suspendido');

--Usuaurios
-- StatusID 1: Pendiente de revisión
INSERT INTO pvDB.pv_users (name, lastName, email, password, creationDate, statusID) VALUES
('Luis', 'Garcia', 'luis.garcia@example.com', HASHBYTES('SHA2_256', 'luispasscode'), '2024-02-01', 1),
('Hector', 'Soto', 'hector.s@example.com', HASHBYTES('SHA2_256', 'hector.pass'), '2024-05-10', 1);

-- StatusID 2: Activo
INSERT INTO pvDB.pv_users (name, lastName, email, password, creationDate, statusID) VALUES
('Juan', 'Perez', 'juan.perez@example.com', HASHBYTES('SHA2_256', 'password123'), '2024-01-01', 2),
('Maria', 'Gomez', 'maria.gomez@example.com', HASHBYTES('SHA2_256', 'securepass456'), '2024-01-05', 2),
('Laura', 'Fernandez', 'laura.f@example.com', HASHBYTES('SHA2_256', 'laura.pass'), '2024-01-15', 2),
('Ana', 'Martinez', 'ana.m@example.com', HASHBYTES('SHA2_256', 'anamartinez123'), '2024-01-25', 2),
('Sofia', 'Hernandez', 'sofia.h@example.com', HASHBYTES('SHA2_256', 'sofia.pwd'), '2024-02-05', 2),
('Diego', 'Gonzalez', 'diego.g@example.com', HASHBYTES('SHA2_256', 'diegosecure'), '2024-02-10', 2),
('Javier', 'Ramirez', 'javier.r@example.com', HASHBYTES('SHA2_256', 'javier.123'), '2024-02-20', 2),
('Miguel', 'Vazquez', 'miguel.v@example.com', HASHBYTES('SHA2_256', 'miguel.pass'), '2024-03-01', 2),
('Ricardo', 'Morales', 'ricardo.m@example.com', HASHBYTES('SHA2_256', 'ricardosafepass'), '2024-03-10', 2),
('Fernando', 'Reyes', 'fernando.r@example.com', HASHBYTES('SHA2_256', 'fernando_pass'), '2024-03-20', 2),
('Sergio', 'Silva', 'sergio.s@example.com', HASHBYTES('SHA2_256', 'sergio.pass'), '2024-04-01', 2),
('Camila', 'Mendoza', 'camila.m@example.com', HASHBYTES('SHA2_256', 'camilapwd'), '2024-04-05', 2),
('Paula', 'Ortiz', 'paula.o@example.com', HASHBYTES('SHA2_256', 'paula_safe'), '2024-04-15', 2),
('Martin', 'Guerrero', 'martin.g@example.com', HASHBYTES('SHA2_256', 'martin.pwd'), '2024-04-20', 2),
('Roberto', 'Delgado', 'roberto.d@example.com', HASHBYTES('SHA2_256', 'roberto_pwd'), '2024-05-01', 2),
('Mariana', 'Ruiz', 'mariana.r@example.com', HASHBYTES('SHA2_256', 'mariana.secure'), '2024-05-05', 2),
('Viviana', 'Nuñez', 'viviana.n@example.com', HASHBYTES('SHA2_256', 'viviana_safe'), '2024-05-15', 2);

-- StatusID 3: Inactivo
INSERT INTO pvDB.pv_users (name, lastName, email, password, creationDate, statusID) VALUES
('Pedro', 'Lopez', 'pedro.lopez@example.com', HASHBYTES('SHA2_256', 'pedro_safe'), '2024-01-20', 3),
('Gabriela', 'Torres', 'gabriela.t@example.com', HASHBYTES('SHA2_256', 'gabrielasecret'), '2024-02-25', 3),
('Manuel', 'Ibarra', 'manuel.i@example.com', HASHBYTES('SHA2_256', 'manuel.pwd'), '2024-05-20', 3);

-- StatusID 4: Bajo revisión
INSERT INTO pvDB.pv_users (name, lastName, email, password, creationDate, statusID) VALUES
('Carlos', 'Rodriguez', 'carlos.r@example.com', HASHBYTES('SHA2_256', 'mysecretpwd'), '2024-01-10', 4);

-- StatusID 5: Rechazado
INSERT INTO pvDB.pv_users (name, lastName, email, password, creationDate, statusID) VALUES
('Daniela', 'Flores', 'daniela.f@example.com', HASHBYTES('SHA2_256', 'dani_pwd'), '2024-03-05', 5);

-- StatusID 6: Eliminado
INSERT INTO pvDB.pv_users (name, lastName, email, password, creationDate, statusID) VALUES
('Jorge', 'Castro', 'jorge.c@example.com', HASHBYTES('SHA2_256', 'jorge.pass'), '2024-04-10', 6);

-- StatusID 7: Bloqueado
INSERT INTO pvDB.pv_users (name, lastName, email, password, creationDate, statusID) VALUES
('Andrea', 'Guzman', 'andrea.g@example.com', HASHBYTES('SHA2_256', 'andrea.secure'), '2024-03-25', 7);

-- StatusID 8: Suspendido
INSERT INTO pvDB.pv_users (name, lastName, email, password, creationDate, statusID) VALUES
('Natalia', 'Salazar', 'natalia.s@example.com', HASHBYTES('SHA2_256', 'natalia.pass'), '2024-04-25', 8);

