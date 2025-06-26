USE pvDB;
--Status de comentarios
INSERT INTO pvDB.pv_commentStatus (commentStatusID, [name])
VALUES (1, 'Pendiente'),
       (2, 'Aprobado'),
       (3, 'Rechazado');



-- Tipos de votación
INSERT INTO pvDB.pv_voteTypes (voteType)
VALUES 
  ('Aprobación de propuesta'),
  ('Calificación');


-- Estados de votación
INSERT INTO pvDB.pv_voteStatus (voteStatusID, [name])
VALUES
  (1, 'Abierta'),
  (2, 'Cerrada'),
  (3, 'Pendiente aprobación');

-- Tipos de criterio de aprobación
INSERT INTO pvDB.pv_approvalCriteriaTypes ([type])
VALUES
  ('Porcentaje de votos minimo'),
  ('Tiempo'),
  ('Unanimidad');
