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
