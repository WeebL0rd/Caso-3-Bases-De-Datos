# Caso 3 Bases De Datos: Pura Vida DB

---

# Integrantes


Efraim Cuevas Aguilar <br>
Carné: 2024109746 <br>
Username: WeebL0rd <br>

<br>

Rachell Daniela Leiva Abarca <br>
Carné: 2024220640   <br>
Username: RachellLeiva <br>

<br>

Lindsay Nahome Marín Sánchez <br>
Carné: 2024163904 <br>
Username: CholiRat <br>

<br>


# ENDPOINTS
## crearActualizarPropuesta
Este endpoint permite crear o actualizar una propuesta a partir de un ID de propuesta

Parámetros de entrada  
proposalID (sql.Int)  
Identificador entero único de la propuesta a crear o modificar.  

isUser (sql.Bit)  
Valor booleano que indica si quien realiza la operación es un usuario registrado (1) o un sistema/organización (0).  

userID (sql.Int)  
Identificador entero del usuario que está realizando la acción, si aplica.  

organizationID (sql.Int)  
ID entero de la organización asociada a la propuesta.  

proposalTitle (sql.VARCHAR(75))  
Título corto de la propuesta (máximo 75 caracteres).  

proposalDesc (sql.VARCHAR(300))  
Descripción detallada de la propuesta (máximo 300 caracteres).  

proposalType (sql.VARCHAR(30))  
Categoría o tipo de propuesta (máximo 30 caracteres).  

proposalComments (sql.Bit)  
Booleano que habilita (1) o deshabilita (0) los comentarios sobre la propuesta.  

documents (sql.NVARCHAR(MAX))  
Texto en formato NVARCHAR que puede incluir rutas, enlaces o estructuras (ej. JSON) con los documentos relacionados.  

demographics (sql.NVARCHAR(MAX))  
Cadena larga en formato JSON con criterios demográficos requeridos para la propuesta.  

Parámetro de salida  
ResultMessage (sql.VarChar(100))  
Mensaje de resultado que informa si la operación fue exitosa o si ocurrió un error (hasta 100 caracteres).

```javascript

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
```

## revisarPropuesta
Con este endpoint un usuario puede revisar la propuesta.
Parámetros de entrada  
reviewerID (sql.Int)  
Identificador entero del usuario revisor que está evaluando la propuesta.  

proposalID (sql.Int)  
ID entero de la propuesta que se desea revisar.  

Parámetros de salida  
ResultMessage (sql.VarChar(100))  
Cadena de hasta 100 caracteres que describe el resultado de la revisión, como "Revisión completada" o "Propuesta no encontrada".  

ResultCode (sql.Int)  
Código de resultado numérico que puede representar el estado de la operación (por ejemplo: 0 = éxito, 1 = error lógico, 2 = error de permisos).

```javascript
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

```

## invertir

Parámetros: Ninguno

sessionToken: Es una cadena de carácteres que usará para buscar si el usuario está autenticado con una sesión abierta en la base de datos.

crowdfundingID: Es un integer, y este representa el evento de crowdfunding en el que el usuario desea invertir.

payMethodID: Es un integer, y representa el ID del método de pago seleccionado por el usuario

cantidadInversion: Es un decimal y por aquí se pasa la cantidad que se desea invertir en el evento de crowdfunding

```javascript
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
```

## repartirDividendos
Esta función decide como darle los dividendos a los usuarios inversores.

Parámetro de entrada  
CrowdfundingID (sql.Int)  
Identificador entero del evento de crowdfunding sobre el cual se desea consultar o realizar una operación.  

Parámetros de salida  
ResultMessage (sql.VarChar(100))  
Mensaje descriptivo de hasta 100 caracteres que resume el resultado de la operación (por ejemplo: "Inversión registrada" o "Evento no válido").  

ResultCode (sql.Int)  
Código numérico que representa el estado de la operación (ej. 0 = éxito, 1 = error de validación, 2 = no encontrado).


```javascript

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
```

## votar
```javascript
require('dotenv').config();
const crypto = require('crypto');
const { sequelize, Op, UserSession, Users, Proposal, Voting, confirmedVotes, VoteQuestion, VoteOption, tokens, UserDemographics, VoteDemographic, Log, LogSources, LogType, LogSeverity } = require('./models');

module.exports.votar = async (event) => {
	const { userID, proposalID, voteID, voteToken, voteQuestionID, optionText } = JSON.parse(event.body || '{}');
	if (!userID || !proposalID || !voteID || !voteToken || !questionID || !decision ) {
		return { statusCode: 400, body: JSON.stringify({ error: 'Faltan parámetros' }) };
	}
	
	try {
		await sequelize.authenticate();

		// Verificar sesión activa
		const ses = await UserSession.findOne({
		  where: { userID, expirationDate: { [Op.gt]: new Date() } }
		});
		if (!ses) {
		  return { statusCode: 401, body: JSON.stringify({ error: 'Usuario no autenticado.' }) };
		}
		// Verificar usuario activo
		const usuario = await Users.findOne({
		  where: { userID }
		});
		if (usuario.statusID !== 2) {
		  return { statusCode: 402, body: JSON.stringify({ error: 'El usuario no esta activo.' }) };
		}
		// Verificar propuesta existente
		const proposal = await Proposal.findOne({
		  where: { proposalID }
		});
		if (!proposal) {
		  return { statusCode: 403, body: JSON.stringify({ error: 'La propuesta no existe.' }) };
		}
		// Verificar que la votación exista
		const votacion = await Voting.findOne({
		  where: { voteID, endDate: { [Op.gt]: new Date() } }
		});
		if (!votacion) {
		  return { statusCode: 404, body: JSON.stringify({ error: 'La votacion no existe.' }) };
		}
		// Verificar que el token no este utilizado
		const encryptedToken = crypto.createHash('sha256').update(voteToken).digest();  
 
		const token = await tokens.findOne({
		  where: { voteToken: tokenHash }
		});
		if (token.isUsed == 0) {
		  return { statusCode: 405, body: JSON.stringify({ error: 'Este token ya fue usado.' }) };
		}
		
		const question = await VoteQuestion.findOne({
		where: { voteQuestionID }});
		const optionID = await VoteOption.findOne({
		where: { questionID, optionText }});
		
		const checksum = fn('concat', optionID, votacion.weight , encryptedToken)
		
		const newComment = await confirmedVotes.create({
        optionVoteID: optionID,
        weight: votacion.weight,
        encryptedVote: encryptedToken,
        tokenID: encryptedToken,
        checksum
		});
		
		const logSourceID = await LogSources.findOne({
		where: { name: 'Motor de votos' }});
		const logTypeID = await LogType.findOne({
		where: { name: 'Voto emitido' }});
		const logSeverityID = await LogSeverity.findOne({
		where: { name: 'Informativo' }});
		
		checksum = fn('concat', 'Voto agregado en ' + votacion.topic, new Date(), 'PC de ' + usuario.name + usuario.lastname, usuario.name + usuario.lastname, userID, questionID, proposalID, voteID, logSeverityID, logTypeID, logSourceID)
	
		const newLog = await Logs.create({
	    description: 'Voto agregado en ' + votacion.topic,
	    postTime: new Date(),
        computer: 'PC de ' + usuario.name + usuario.lastname,
        username: usuario.name + usuario.lastname,
        trace: ' ',
        referenceId1: userID,
        referenceId2: questionID,
        value1: proposalID,
        value2: voteID,
        checksum,
        logSeverityID: logSeverityID,
        logTypesID: logTypeID,
        logSourcesID: logSeverityID
		});
	
		return {
		statusCode: 200,
		body: JSON.stringify({message: "Voto registrado con éxito", resultado}),
	  };
	} 
	catch (err) {
    console.error('Error al votar:', err);
    return { statusCode: 500, body: JSON.stringify({ error: 'Error interno al procesar la votacion.' }) };
    }
  
};
```

## comentar
```javascript

require('dotenv').config();
const { sequelize, Op, UserSession, Proposal, Comment } = require('./models');

module.exports.comentar = async (event) => {
  const { userID, proposalID, title, text } = JSON.parse(event.body || '{}');
  if (!userID || !proposalID || !text) {
    return { statusCode: 400, body: JSON.stringify({ error: 'Faltan parámetros: userID, proposalID y text.' }) };
  }

  try {
    await sequelize.authenticate();

    // Verificar sesión activa
    const ses = await UserSession.findOne({
      where: { userID, expirationDate: { [Op.gt]: new Date() } }
    });
    if (!ses) {
      return { statusCode: 401, body: JSON.stringify({ error: 'Usuario no autenticado.' }) };
    }

    // Verificar comentarios habilitados
    const prop = await Proposal.findOne({ where: { proposalID, enableComments: true } });
    if (!prop) {
      return { statusCode: 403, body: JSON.stringify({ error: 'Comentarios deshabilitados.' }) };
    }

    // Insertar comentario
    const newComment = await Comment.create({
      proposeID: proposalID,
      userID,
      title: title || null,
      text,
      date: new Date(),
      commentStatusID: 1
    });

    return { statusCode: 201, body: JSON.stringify({ commentID: newComment.commentID }) };
  } catch (err) {
    console.error('Error en comentar:', err);
    return { statusCode: 500, body: JSON.stringify({ error: 'Error interno al procesar comentario.' }) };
  }
};
```

## listarVotos 
```javascript
const { User, UserSession, sequelize } = require('./models');
const crypto = require('crypto');
//ඞ
module.exports.listarVotos = async (event) => {
    let sessionToken;

    // Primero se valida que se haya pasado el token del usuario
    if (event.queryStringParameters && event.queryStringParameters.token && event.queryStringParameters.token.trim() !== "") {
        sessionToken = event.queryStringParameters.token;
    } else {
        return {
            statusCode: 400,
            body: JSON.stringify({ message: "Falta el token en la URL de la solicitud." })
        };
    }

    try {
        await sequelize.authenticate();

        const user = await getUserFromSessionToken(sessionToken);
        
        if (user == null) {
            return {
            statusCode: 400,
            body: JSON.stringify({ message: "El usuario no existe o no posee una sesión activa" }),
        };}


        return {
            statusCode: 200,
            body: JSON.stringify({ message: "Hola listaVotos pueba!", usuario: user }),
        };
    } catch (err) {
        console.error('Error en listarVotos:', err);
        return { 
            statusCode: 500, 
            body: JSON.stringify({ error: 'Error interno al listar votos.' }) 
        };
    }

    
 
};


async function getUserFromSessionToken(token) {
    const hashedToken = crypto.createHash('sha256')
    .update(Buffer.from(token, 'utf8'))
    .digest();

    const result = await UserSession.findOne({
        where: { token: hashedToken},
        include: [{
            model: User,
            attributes: ['name', 'lastName', 'email']
        }]
    });

    console.log(result);

    return result;
}

async function getLastUserVoteLogs() {
    const severity = await LogsSeverity.findOne({ where: { name: severityName } });
    const source = await LogSources.findOne({ where: { name: sourceName } });
    const type = await LogType.findOne({ where: { name: typeName } });
}

async function saveLog() {
    
}
```

## configurarVotacion
```javascript

require('dotenv').config();
const crypto = require('crypto');
const {
  sequelize,
  UserProposal,
  OrgProposal,
  UserOrganization,
  Voting,
  VoteQuestion,
  VoteOption,
  VoteDemographic
} = require('./models');

module.exports.configurarVotacion = async (event) => {
  const {
    userID,
    proposalID,
    topic,
    startDate,
    endDate,
    questions,
    demographics,
    voteTypeID,
    voteStatusID,
    approvalTypeID,
    approvalCriteria,
    strictDemographic
  } = JSON.parse(event.body || '{}');

  if (
    !userID || !proposalID || !topic || !startDate || !endDate ||
    !Array.isArray(questions) || questions.length < 1 ||
    !Array.isArray(demographics) ||
    !voteTypeID || !voteStatusID || !approvalTypeID ||
    typeof approvalCriteria !== 'string' ||
    typeof strictDemographic !== 'boolean'
  ) {
    return { statusCode: 400, body: JSON.stringify({ error: 'Parámetros faltantes o inválidos.' }) };
  }

  try {
    await sequelize.authenticate();

    // Verificar permisos
    let hasPermission = !!(await UserProposal.findOne({ where: { proposalID, userID } }));
    if (!hasPermission) {
      const userOrgs = (await UserOrganization.findAll({ where: { userID } }))
        .map(o => o.organizationID);
      const orgProps = await OrgProposal.findAll({ where: { proposalID } });
      hasPermission = orgProps.some(o => userOrgs.includes(o.organizationID));
    }
    if (!hasPermission) {
      return { statusCode: 403, body: JSON.stringify({ error: 'Sin permisos para esta propuesta.' }) };
    }

    const now = new Date();

    // Crear votación
    const vote = await Voting.create({
      topic,
      voteTypeID,
      voteStatusID,
      proposalID,
      approvalTypeID,
      approvalCriteria,
      strictDemographic,
      startDate:      new Date(startDate),
      endDate:        new Date(endDate),
      creationDate:   now,
      lastUpdate:     now,
      commentsEnabled: true
    });

    // Preguntas y opciones
    for (const q of questions) {
      if (!q.question || !Array.isArray(q.options) || q.options.length < 2) {
        throw new Error('Cada pregunta debe tener texto y al menos dos opciones.');
      }
      const qChecksum = Buffer.from(
        crypto.createHash('sha256').update(q.question).digest('hex'),
        'hex'
      );
      const qRec = await VoteQuestion.create({
        voteID:         vote.voteID,
        question:       q.question,
        answerQuantity: q.options.length,
        creationDate:   now,
        deleted:        Buffer.from([0]),
        checksum:       qChecksum
      });

      const opts = q.options.map((opt, i) => ({
        voteQuestionID: qRec.voteQuestionID,
        optionText:     opt,
        optionNumber:   i + 1,
        value:          opt,
        creationDate:   now,
        enabled:        true,
        deleted:        Buffer.from([0]),
        checksum:       Buffer.from(
          crypto.createHash('sha256').update(opt).digest('hex'),
          'hex'
        )
      }));
      await VoteOption.bulkCreate(opts);
    }

    // Demographics
    const demLinks = demographics.map(id => ({
      voteID:              vote.voteID,
      targetDemographicID: id,
      creationDate:        now,
      deleted:             false
    }));
    await VoteDemographic.bulkCreate(demLinks);

    return { statusCode: 201, body: JSON.stringify({ voteID: vote.voteID }) };

  } catch (err) {
    console.error('Error in configurarVotacion:', err);
    return { statusCode: 500, body: JSON.stringify({ error: 'Error interno al configurar votación.' }) };
  }
};

```





