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

module.exports.crearActualizarPropuesta = async (event) => {
	
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
        console.error('Error en la función crearActualizarPropuesta:', error);
        return {
            statusCode: 500,
            body: JSON.stringify({ message: "Error interno del servidor.", error: error.message }),
        };
    }
		
};

/*
E: Un JSON
S: Un resultMessage
Esta función ejecuta el SP y retorna el resultado
*/ 
async function callStoredProcedure(data) {
    const proposalID = data.proposalID;
    const isUser = data.isUser;
    const userID = data.userID;
    const organizationID = data.organizationID;
    const proposalTitle = data.proposalTitle;
    const proposalDesc = data.proposalDesc;
    const proposalType = data.proposalType;
	const proposalComments = data.proposalComments;
	const proposalDocuments = data.proposalDocuments;
	const proposalDemographics = data.proposalDemographics;

    try {
        const pool = await sql.connect(config);

        const request = pool.request();

        request
        .input('proposalID', sql.Int, proposalID)
        .input('isUser', sql.Bit, isUser)
        .input('userID', sql.Int, userID)
        .input('organizationID', sql.Int, organizationID)
		.input('proposalTitle', sql.VARCHAR(75), proposalTitle)
        .input('proposalDesc', sql.VARCHAR(300), proposalDesc)
        .input('proposalType', sql.VARCHAR(30), proposalType)
        .input('proposalComments', sql.Bit, proposalComments)
		.input('documents', sql.NVARCHAR(MAX), proposalDocuments)
        .input('demographics', sql.NVARCHAR(MAX), proposalDemographics)
        .output('ResultMessage', sql.VarChar(100));

        const result = await request.execute('[pvDB].[crearActualizarPropuesta]');
        return result.output;
        
    } catch (err) {
        console.error("Error ejecutando el SP:", err);
        throw err;
        
    } finally {
        sql.close();
    }
}
