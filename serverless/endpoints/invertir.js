//Variables globales de sql
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



module.exports.invertir = async (event) => {

    try {
        // Acceder al body como string
        const requestBodyString = event.body;

        // Parsear el body a un JSON
        let requestData;
        if (requestBodyString) {
            try {
                
                requestData = JSON.parse(requestBodyString);
                console.log('Body :', requestData);

                // Se revisa que el JSON traiga todos los atributos para ejecutar el SP
                if (!checkBodyStucture(requestData)){
                    return {
                        statusCode: 400,
                        body: JSON.stringify({ message: "Solicitud inválida: El body no contiene los atributos necesarios."})
                    };
                }

            } catch (jsonError) {
                console.error('Error al parsear JSON del body:', jsonError);
                return {
                    statusCode: 400,
                    body: JSON.stringify({ message: "Solicitud inválida: El body no es un JSON válido.", error: jsonError.message }),
                };
            }

        } else {
            console.log('No se proporcionó body en la solicitud.');
            responseBody.message = "No se proporcionó body en la solicitud.";
            return {
                    statusCode: 400,
                    body: JSON.stringify({ message: "Solicitud inválida: No se proporcionó body en la solicitud." }),
                };
        }

        // Se llama al SP
        const spResult = await callStoredProcedure(requestData);

        // Si lo que retornó no fue un resultado exitoso
        if (spResult.ResultCode !== 0) {
            return {
                statusCode: 400,
                body: JSON.stringify({ message: spResult.ResultMessage})
            };
        }

        // Si la transacción se hizo con éxito
        return {
            statusCode: 200,
            body: JSON.stringify({ message: spResult.ResultMessage })
        };

    } catch (error) {
        console.error('Error en la función invertir:', error);
        return {
            statusCode: 500,
            body: JSON.stringify({ message: "Error interno del servidor.", error: error.message }),
        };
    }

};

/*
E: Un JSON
S: Un resultMessage y resultCode en un objeto
Esta función ejecuta el SP y retorna el resultado
*/ 
async function callStoredProcedure(data) {
    const sessionToken = data.sessionToken;
    const payMethodID = data.payMethodID;
    const crowdfundingID = data.crowdfundingID;
    const investment = data.investment;


    try {
        const pool = await sql.connect(config);

        const request = pool.request();

        request
        .input('CrowdfundingID', sql.Int, crowdfundingID)
        .input('UserToken', sql.VarChar(110), sessionToken)
        .input('UserSelectedPayMethodID', sql.Int, payMethodID)
        .input('CantidadInversion', sql.Decimal(18, 5), investment)
        .output('ResultMessage', sql.VarChar(100))
        .output('ResultCode', sql.Int);

        const result = await request.execute('[pvDB].[SP_Invertir]');
        return result.output;
        
    } catch (err) {
        console.error("Error ejecutando el SP:", err);
        throw err;
        
    } finally {
        sql.close();
    }
}

/*
E: JSON
S: Boolean
Esta función revisa que el JSON enviado tenga los atributos que se esperan recibir en el endpoint
*/
function checkBodyStucture(json) {
  
    const requiredKeys = ["sessionToken", "payMethodID", "crowdfundingID", "investment"];
  
    for (const key of requiredKeys) {
        if (
            !(key in json) || 
            json[key] === null || 
            json[key] === undefined || 
            json[key] === ""
        ) {
            console.log(`Clave faltante o inválida: ${key}`);
            return false;
        }
    }

    if (json.investment <= 0){
        console.log("La cantidad a invertir no es válida.");
        return false;
    }

    console.log("El JSON es válido");
    return true;
}