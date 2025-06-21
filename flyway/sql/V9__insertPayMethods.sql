-- Payment methods

INSERT INTO pvDB.pv_payMethod (name, apiURL, secretKey, "key", logoIconURL, "enabled") VALUES
('PayPal', 'https://api.paypal.com/v1/', HASHBYTES('SHA2_256', 'paypal_secret_key_123'), 'paypal_public_key_abc', 'https://example.com/paypal_logo.png', 1),
('Visa', 'https://api.visa.com/checkout/', HASHBYTES('SHA2_256', 'visa_secret_key_456'), 'visa_public_key_def', 'https://example.com/visa_logo.png', 1),
('Mastercard', 'https://api.mastercard.com/gateway/', HASHBYTES('SHA2_256', 'mc_secret_key_789'), 'mc_public_key_ghi', 'https://example.com/mastercard_logo.png', 1);
GO


DECLARE @paypalMethodID INT;
DECLARE @visaMethodID INT;
DECLARE @mastercardMethodID INT;


SELECT @paypalMethodID = payMethodID FROM pvDB.pv_payMethod WHERE name = 'PayPal';
SELECT @visaMethodID = payMethodID FROM pvDB.pv_payMethod WHERE name = 'Visa';
SELECT @mastercardMethodID = payMethodID FROM pvDB.pv_payMethod WHERE name = 'Mastercard';

-- Available payment methods para cada usuario
INSERT INTO pvDB.pv_availablePayMethods (name, userID, token, expToken, maskAccount, methodID) VALUES
('My PayPal', (SELECT userID FROM pvDB.pv_users WHERE email = 'juan.perez@example.com'), HASHBYTES('SHA2_256', 'paypal_token_juan'), '2027-12-31', 'juan@example.com', @paypalMethodID),
('My Visa', (SELECT userID FROM pvDB.pv_users WHERE email = 'maria.gomez@example.com'), HASHBYTES('SHA2_256', 'visa_token_maria'), '2028-05-31', '************4321', @visaMethodID),
('My Mastercard', (SELECT userID FROM pvDB.pv_users WHERE email = 'laura.f@example.com'), HASHBYTES('SHA2_256', 'mc_token_laura'), '2029-01-31', '************5678', @mastercardMethodID),
('Ana''s PayPal', (SELECT userID FROM pvDB.pv_users WHERE email = 'ana.m@example.com'), HASHBYTES('SHA2_256', 'paypal_token_ana'), '2027-11-30', 'ana@example.com', @paypalMethodID),
('Sofia''s Visa', (SELECT userID FROM pvDB.pv_users WHERE email = 'sofia.h@example.com'), HASHBYTES('SHA2_256', 'visa_token_sofia'), '2028-08-31', '************1122', @visaMethodID),
('Diego''s MC', (SELECT userID FROM pvDB.pv_users WHERE email = 'diego.g@example.com'), HASHBYTES('SHA2_256', 'mc_token_diego'), '2029-03-31', '************3344', @mastercardMethodID),
('Javier''s PayPal', (SELECT userID FROM pvDB.pv_users WHERE email = 'javier.r@example.com'), HASHBYTES('SHA2_256', 'paypal_token_javier'), '2027-10-31', 'javier@example.com', @paypalMethodID),
('Miguel''s Visa', (SELECT userID FROM pvDB.pv_users WHERE email = 'miguel.v@example.com'), HASHBYTES('SHA2_256', 'visa_token_miguel'), '2028-07-31', '************5566', @visaMethodID),
('Ricardo''s MC', (SELECT userID FROM pvDB.pv_users WHERE email = 'ricardo.m@example.com'), HASHBYTES('SHA2_256', 'mc_token_ricardo'), '2029-02-28', '************7788', @mastercardMethodID),
('Fernando''s PayPal', (SELECT userID FROM pvDB.pv_users WHERE email = 'fernando.r@example.com'), HASHBYTES('SHA2_256', 'paypal_token_fernando'), '2027-09-30', 'fernando@example.com', @paypalMethodID),
('Sergio''s Visa', (SELECT userID FROM pvDB.pv_users WHERE email = 'sergio.s@example.com'), HASHBYTES('SHA2_256', 'visa_token_sergio'), '2028-06-30', '************9900', @visaMethodID),
('Camila''s MC', (SELECT userID FROM pvDB.pv_users WHERE email = 'camila.m@example.com'), HASHBYTES('SHA2_256', 'mc_token_camila'), '2029-04-30', '************1212', @mastercardMethodID),
('Paula''s PayPal', (SELECT userID FROM pvDB.pv_users WHERE email = 'paula.o@example.com'), HASHBYTES('SHA2_256', 'paypal_token_paula'), '2027-08-31', 'paula@example.com', @paypalMethodID),
('Martin''s Visa', (SELECT userID FROM pvDB.pv_users WHERE email = 'martin.g@example.com'), HASHBYTES('SHA2_256', 'visa_token_martin'), '2028-09-30', '************3434', @visaMethodID),
('Roberto''s MC', (SELECT userID FROM pvDB.pv_users WHERE email = 'roberto.d@example.com'), HASHBYTES('SHA2_256', 'mc_token_roberto'), '2029-05-31', '************5656', @mastercardMethodID),
('Mariana''s PayPal', (SELECT userID FROM pvDB.pv_users WHERE email = 'mariana.r@example.com'), HASHBYTES('SHA2_256', 'paypal_token_mariana'), '2027-07-31', 'mariana@example.com', @paypalMethodID),
('Viviana''s Visa', (SELECT userID FROM pvDB.pv_users WHERE email = 'viviana.n@example.com'), HASHBYTES('SHA2_256', 'visa_token_viviana'), '2028-10-31', '************7878', @visaMethodID);
GO