USE pvDB;
--Status de comentarios
INSERT INTO pvDB.pv_commentStatus (commentStatusID, [name])
VALUES (1, 'Pendiente'),
       (2, 'Aprobado'),
       (3, 'Rechazado');



-- Tipos de votaci�n
INSERT INTO pvDB.pv_voteTypes (voteType)
VALUES 
  ('Aprobaci�n de propuesta'),
  ('Calificaci�n');


-- Estados de votaci�n
INSERT INTO pvDB.pv_voteStatus (voteStatusID, [name])
VALUES
  (1, 'Abierta'),
  (2, 'Cerrada'),
  (3, 'Pendiente aprobaci�n');

-- Tipos de criterio de aprobaci�n
INSERT INTO pvDB.pv_approvalCriteriaTypes ([type])
VALUES
  ('Porcentaje de votos minimo'),
  ('Tiempo'),
  ('Unanimidad');
