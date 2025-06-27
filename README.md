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
```

## revisarPropuesta
```javascript


```

## invertir
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
```

## repartirDividendos
```javascript


```

## votar
```javascript


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
```sql

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





