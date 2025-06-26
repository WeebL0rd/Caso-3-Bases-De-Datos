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

module.exports.revisarPropuesta = async (event) => {
    try {
        const requestBodyString = event.body;
        let requestData;

        // Validar existencia y parseo del body
        if (requestBodyString) {
            try {
                requestData = JSON.parse(requestBodyString);
                console.log('Body:', requestData);

                // Validar campos requeridos y proposalID > 0
                if (!checkBodyStructure(requestData)) {
                    return {
                        statusCode: 400,
                        body: JSON.stringify({ message: "Solicitud inválida: El body no contiene los atributos necesarios o son inválidos." })
                    };
                }
            } catch (jsonError) {
                console.error('Error al parsear JSON del body:', jsonError);
                return {
                    statusCode: 400,
                    body: JSON.stringify({ message: "Solicitud inválida: El body no es un JSON válido.", error: jsonError.message })
                };
            }
        } else {
            console.log('No se proporcionó body en la solicitud.');
            return {
                statusCode: 400,
                body: JSON.stringify({ message: "Solicitud inválida: No se proporcionó body en la solicitud." })
            };
        }

        // Llamar al procedimiento almacenado SP_RevisarPropuesta
        const spResult = await callStoredProcedure(requestData);

        // Evaluar el código de resultado del SP
        if (spResult.ResultCode !== 0) {
            return {
                statusCode: 400,
                body: JSON.stringify({ message: spResult.ResultMessage })
            };
        }
        // Éxito: retornar mensaje del SP
        return {
            statusCode: 200,
            body: JSON.stringify({ message: spResult.ResultMessage })
        };

    } catch (error) {
        console.error('Error en la función revisarPropuesta:', error);
        return {
            statusCode: 500,
            body: JSON.stringify({ message: "Error interno del servidor.", error: error.message })
        };
    }
};

// Llama al procedimiento almacenado y retorna los parámetros de salida
async function callStoredProcedure(data) {
    try {
        const pool = await sql.connect(config);
        const request = pool.request();
        request
            .input('reviewerID', sql.Int, data.reviewerID)
            .input('proposalID', sql.Int, data.proposalID)
            .output('ResultMessage', sql.VarChar(100))
            .output('ResultCode', sql.Int);
        const result = await request.execute('[pvDB].[SP_RevisarPropuesta]');
        return result.output;
    } catch (err) {
        console.error("Error ejecutando SP_RevisarPropuesta:", err);
        throw err;
    } finally {
        // Asegurar cierre de conexión SQL siempre
        sql.close();
    }
}

// Valida que el JSON tenga los campos requeridos y proposalID válido
function checkBodyStructure(json) {
    const requiredKeys = ['proposalID', 'reviewerID'];
    for (const key of requiredKeys) {
        if (!(key in json) || json[key] === null || json[key] === undefined) {
            console.log(`Campo faltante o nulo: ${key}`);
            return false;
        }
    }
    if (json.proposalID <= 0) {
        console.log("proposalID inválido (debe ser > 0).");
        return false;
    }
    return true;
}
