// Variables globales de conexión SQL
const sql = require('mssql');
const config = {
  user: 'userSP',
  password: 'VotoPuravida',
  server: 'localhost',
  database: 'pvDB',
  options: {
    encrypt: false,
    trustServerCertificate: true
  }
};

module.exports.repartirDividendos = async (event) => {
    try {
        // Verificar que exista el body en la petición
        const requestBodyString = event.body;
        if (!requestBodyString) {
            console.log('No se proporcionó body en la solicitud.');
            return {
                statusCode: 400,
                body: JSON.stringify({ message: "Solicitud inválida: No se proporcionó body en la solicitud." })
            };
        }

        // Parsear el body a JSON
        let requestData;
        try {
            requestData = JSON.parse(requestBodyString);
            console.log('Body:', requestData);
        } catch (jsonError) {
            console.error('Error al parsear JSON del body:', jsonError);
            return {
                statusCode: 400,
                body: JSON.stringify({ message: "Solicitud inválida: El body no es un JSON válido.", error: jsonError.message })
            };
        }

        // Validar que solo exista el campo crowdfundingID
        const keys = Object.keys(requestData);
        if (keys.length !== 1 || !requestData.hasOwnProperty('crowdfundingID')) {
            console.log('El body debe contener exclusivamente el campo crowdfundingID.');
            return {
                statusCode: 400,
                body: JSON.stringify({ message: "Solicitud inválida: El body debe contener solo el atributo crowdfundingID." })
            };
        }

        // Validar crowdfundingID
        const crowdfundingID = parseInt(requestData.crowdfundingID, 10);
        if (isNaN(crowdfundingID) || crowdfundingID <= 0) {
            console.log('crowdfundingID inválido:', requestData.crowdfundingID);
            return {
                statusCode: 400,
                body: JSON.stringify({ message: "Solicitud inválida: crowdfundingID debe ser un entero mayor que 0." })
            };
        }

        // Llamar al procedimiento almacenado con parámetros de entrada/salida
        const spResult = await callStoredProcedure(crowdfundingID);

        // Revisar resultado del SP
        if (spResult.ResultCode !== 0) {
            // El SP devolvió un código de error (>0)
            return {
                statusCode: 400,
                body: JSON.stringify({ message: spResult.ResultMessage })
            };
        }

        // Éxito
        return {
            statusCode: 200,
            body: JSON.stringify({ message: spResult.ResultMessage })
        };

    } catch (error) {
        console.error('Error en la función repartirDividendos:', error);
        return {
            statusCode: 500,
            body: JSON.stringify({ message: "Error interno del servidor.", error: error.message })
        };
    }
};

// Función auxiliar que invoca el SP [pvDB].[repartirDividendos]
async function callStoredProcedure(crowdfundingID) {
    try {
        const pool = await sql.connect(config);
        const request = pool.request();
        // Agregar parámetro de entrada y parámetros de salida (output):contentReference[oaicite:2]{index=2}
        request
            .input('CrowdfundingID', sql.Int, crowdfundingID)
            .output('ResultMessage', sql.VarChar(100))
            .output('ResultCode', sql.Int);
        const result = await request.execute('[pvDB].[repartirDividendos]');
        // Los valores de salida del SP quedan en result
        return result.output;
    } catch (err) {
        console.error('Error ejecutando el SP repartirDividendos:', err);
        throw err;
    } finally {
        sql.close();
    }
}
