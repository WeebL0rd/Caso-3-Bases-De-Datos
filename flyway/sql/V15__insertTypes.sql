USE pvDB;
GO

INSERT INTO pvDB.pv_transactionTypes ("name") VALUES
('Inversión de crowdfunding'),
('Repartición de dividendos');

INSERT INTO pvDB.pv_transactionSubtypes ("name") VALUES
('Ingreso'),
('Egreso');

INSERT INTO pvDB.pv_crowfundingStatuses (crowfundingStatusID, "name") VALUES
(1, 'Programado'),
(2, 'En curso'),
(3, 'Cancelado'),
(4, 'Cerrado');


INSERT INTO pvDB.pv_paymentStatuses (paymentStatusID, "name") VALUES
(1, 'Pendiente'),
(2, 'Confirmado');

INSERT INTO pvDB.pv_countries (name) VALUES ('Costa Rica');
INSERT INTO pvDB.pv_countries (name) VALUES ('Estados Unidos');

DECLARE @CostaRicaCountryID INT;
DECLARE @USACountryID INT;

SELECT @CostaRicaCountryID = countryID FROM pvDB.pv_countries WHERE name = 'Costa Rica';
SELECT @USACountryID = countryID FROM pvDB.pv_countries WHERE name = 'Estados Unidos';

INSERT INTO pvDB.pv_currencies (name, acronym, symbol, countryID)
VALUES ('Colón Costarricense', 'CRC', '₡', @CostaRicaCountryID);

INSERT INTO pvDB.pv_currencies (name, acronym, symbol, countryID)
VALUES ('Dólar Estadounidense', 'USD', '$', @USACountryID);

DECLARE @CRC_currencyID INT;
DECLARE @USD_currencyID INT;
DECLARE @today DATE = GETDATE();

SELECT @CRC_currencyID = currencyID FROM pvDB.pv_currencies WHERE acronym = 'CRC';
SELECT @USD_currencyID = currencyID FROM pvDB.pv_currencies WHERE acronym = 'USD';

INSERT INTO pvDB.pv_exchangeCurrencies (sourceID, destinyID, startDate, endDate, exchange_rate, enabled, currentExchange)
    VALUES
        (@USD_currencyID, @CRC_currencyID, @today, NULL, 520.00, 1, 1),
        (@CRC_currencyID, @USD_currencyID, @today, NULL, 1.0 / 520.0, 1, 1),
        (@USD_currencyID, @USD_currencyID, @today, NULL, 1.0, 1, 1),
        (@CRC_currencyID, @CRC_currencyID, @today, NULL, 1.0, 1, 1);


-- Insertar logtypes, severity y sources


INSERT INTO pvDB.pv_logTypes (name, reference1Description, reference2Description, value1Description, value2Description)
VALUES
    ('Pago', 'ID de Pago', 'ID de Usuario', 'Monto', 'Moneda'),
    ('Inversión', 'ID de Crowdfunding', 'ID de Inversor', 'Cantidad Invertida', 'Meta de Financiamiento'),
    ('Error del Sistema', 'Módulo/Función', 'Mensaje de Error', 'Código de Error', NULL),
    ('Acceso de Usuario', 'ID de Usuario', 'Tipo de Acceso', NULL, NULL),
    ('Actualización de Datos', '', 'ID de Registro', 'Campo Modificado', 'Valor Nuevo'),
	('Actualización de Inversión', 'ID de Investment', 'ID de Registro', 'Valor viejo', 'Valor Nuevo'),
	('Voto emitido', 'ID de usuario', 'ID de pregunta', 'ID de propuesta', 'ID de votacion'),
	('Consulta auditada', 'ID de usuario', '', '', '');

INSERT INTO pvDB.pv_logsSeverity(name)
VALUES
    ('Informativo'),
    ('Advertencia'),
    ('Error'),
    ('Crítico'),
    ('Depuración');

INSERT INTO pvDB.pv_logSources (name)
VALUES
    ('API de Pagos'),
    ('Motor de Crowdfunding'),
    ('Servicio de Usuarios'),
    ('Backend General'),
    ('Interfaz de Usuario'),
	('Motor de votos');