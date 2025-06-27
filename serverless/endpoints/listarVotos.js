const { User, UserSession, Log, LogsSeverity, LogTypes, LogSources, sequelize } = require('./models');
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

        // await saveLog(user);
        
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

async function getLastUserVoteLogs(user) {
    const severity = await LogsSeverity.findOne({ where: { name: 'Informativo' } });
    const source = await LogSources.findOne({ where: { name: 'Motor de votos' } });
    const type = await LogTypes.findOne({ where: { name: 'Voto emitido' } });


    let votes = {};

    if (severity && source && type){
        votes = await Log.findAll({
            where: {
                reference11Description: user.userID
            },
            limit: 5,
            order: [['postTime', 'DESC']]
        });
    }

    console.log(votes);
    return votes;
}

async function saveLog(user ) {
    const severity = await LogsSeverity.findOne({ where: { name: 'Informativo' } });
    const source = await LogSources.findOne({ where: { name: 'Servicio de Usuarios' } });
    const type = await LogTypes.findOne({ where: { name: 'Consulta auditada' } });

    const checksum = crypto.createHash('sha256')
    .update(Buffer.from(user.User.name, 'utf8'))
    .digest();

    transaction = await sequelize.transaction();

    const newLog = await Log.create({
      description: 'Votos de usuario auditados',
      computer: 'WEB-SERVER',
      username: user.User.name,
      trace: '',
      reference1Id: user.userID,
      checksum: checksum,
      logSeverityID: severity.logSeverityID,
      logTypesID: type.logTypesID,
      logSourcesID: source.logSourcesID,
      // postTime Sequelize.NOW 
    }, { transaction });

    await transaction.commit();
}

// function validateUserIdentity(params) {
    
// }

// console.log("Evento entrante");
//     console.log("Evento recibido:", event);
//     const sessionToken = event.queryStringParameters.token;

//     console.log(sessionToken);

//     const user = await getUserFromSessionToken(sessionToken);

//     if (user == null) {
//         return {
//         statusCode: 400,
//         body: JSON.stringify({ message: "El usuario no existe o no posee una sesión activa" }),
//     };
//     }