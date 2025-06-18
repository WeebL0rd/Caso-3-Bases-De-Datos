-- Sesiones de usuarios activos
USE pvDB;
GO

CREATE NONCLUSTERED INDEX IX_pv_userSessions_Token
ON pvDB.pv_userSessions (token);
GO

INSERT INTO pvDB.pv_userSessions (userID, sessionID, token, refreshToken, lastRevision, expirationDate) VALUES
(3, 'session_juan_perez_1', HASHBYTES('SHA2_256', 'a8d7f63a-b91e-46c9-8120-8a23e1f56f5c'), HASHBYTES('SHA2_256', 'f11b2c0e-f2a6-4bc1-8e3f-33b512c4e899'), GETDATE(), DATEADD(month, 3, GETDATE())),
(4, 'session_maria_gomez_1', HASHBYTES('SHA2_256', 'b1c5e62f-9c2b-4b5e-aef2-5ab8c17b63d1'), HASHBYTES('SHA2_256', 'c3d1f278-a13b-47b2-805e-43e01b83f032'), GETDATE(), DATEADD(month, 3, GETDATE())),
(5, 'session_laura_fernandez_1', HASHBYTES('SHA2_256', '3f2b8d1a-33a1-4bce-9817-2cd7983ea5f5'), HASHBYTES('SHA2_256', '7fa4d122-8d4f-41ec-bfa2-7f0c6a561b0d'), GETDATE(), DATEADD(month, 3, GETDATE())),
(6, 'session_ana_martinez_1', HASHBYTES('SHA2_256', 'ae18797b-f682-4ee1-94d7-b42fd53189fb'), HASHBYTES('SHA2_256', '1089f379-c134-4fbb-9a21-81e205f6e92c'), GETDATE(), DATEADD(month, 3, GETDATE())),
(7, 'session_sofia_hernandez_1', HASHBYTES('SHA2_256', 'eeb3540c-f22f-470e-8f43-c60b6c31b0c6'), HASHBYTES('SHA2_256', '4b3f5c78-9dd4-4d92-9793-94e451db5ef6'), GETDATE(), DATEADD(month, 3, GETDATE())),
(8, 'session_diego_gonzalez_1', HASHBYTES('SHA2_256', '06c41a7d-1a54-4b78-bf87-57baf3ec68a2'), HASHBYTES('SHA2_256', 'd20ab098-ec8b-49fc-b535-463e51096f15'), GETDATE(), DATEADD(month, 3, GETDATE())),
(9, 'session_javier_ramirez_1', HASHBYTES('SHA2_256', 'b0b70a4c-4cd7-4d9e-b512-e65c84bc97fa'), HASHBYTES('SHA2_256', '72ce3ea1-0504-4d8c-8828-999ab36a1de4'), GETDATE(), DATEADD(month, 3, GETDATE())),
(10, 'session_miguel_vazquez_1', HASHBYTES('SHA2_256', 'c9ec5ae8-9c99-4cdd-8fd4-870b9b627d43'), HASHBYTES('SHA2_256', '3b8f28e3-d20b-48a1-a29a-13f03bfb0cc5'), GETDATE(), DATEADD(month, 3, GETDATE())),
(11, 'session_ricardo_morales_1', HASHBYTES('SHA2_256', '2f11cefc-42cc-401f-8594-9b7f508e979f'), HASHBYTES('SHA2_256', '6f25745c-7ea9-4d2f-bca4-9fa5fc71deec'), GETDATE(), DATEADD(month, 3, GETDATE())),
(12, 'session_fernando_reyes_1', HASHBYTES('SHA2_256', '1ae2d7f8-f5e5-4cb3-b293-186ea1092c1f'), HASHBYTES('SHA2_256', 'fc2c9d71-16a3-4879-a0aa-5e263ae8479e'), GETDATE(), DATEADD(month, 3, GETDATE())),
(13, 'session_sergio_silva_1', HASHBYTES('SHA2_256', '3ab986da-107c-4ce9-9618-91c7cb06f93e'), HASHBYTES('SHA2_256', '9bca01a3-0d9a-40cb-9e1e-0a30e03705ea'), GETDATE(), DATEADD(month, 3, GETDATE())),
(14, 'session_camila_mendoza_1', HASHBYTES('SHA2_256', '9a7a95b0-f8ef-4d93-a9b8-46cd3b2fbb33'), HASHBYTES('SHA2_256', 'a1bfb402-0fa1-4c0a-905f-3a860a4ffda4'), GETDATE(), DATEADD(month, 3, GETDATE())),
(15, 'session_paula_ortiz_1', HASHBYTES('SHA2_256', '6ddc1a75-b6ec-44a2-846f-f9ed2cb9298e'), HASHBYTES('SHA2_256', 'a5c49384-3681-4c0b-a16e-9bc4cb539f9f'), GETDATE(), DATEADD(month, 3, GETDATE())),
(16, 'session_martin_guerrero_1', HASHBYTES('SHA2_256', 'e0f03cd6-9cd7-4d56-893f-517db78d317b'), HASHBYTES('SHA2_256', '5d124a2b-eec2-44cc-89f8-3c9353643e7b'), GETDATE(), DATEADD(month, 3, GETDATE())),
-- 17, 'session_roberto_delgado_1'  No tendrá sesión activa
-- 18, 'session_mariana_ruiz_1'		No tendrá sesión activa
(19, 'session_viviana_nunez_1', HASHBYTES('SHA2_256', '91379bc0-3ab0-41f2-b67d-9e3a39df0d6a'), HASHBYTES('SHA2_256', 'd882a7e4-7e3e-40a2-850d-2cfa64ac5855'), GETDATE(), DATEADD(month, 3, GETDATE()));
