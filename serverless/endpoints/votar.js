require('dotenv').config();
const { sequelize, Op, UserSession, Users, Proposal, Voting, confirmedVotes, tokens, UserDemographics, VoteDemographic } = require('./models');


module.exports.votar = async (event) => {
	const { userID, proposalID, voteID, voteToken, decision } = JSON.parse(event.body || '{}');
	if (!userID || !proposalID || !voteID || !voteToken || !decision ) {
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
		const encryptedToken = crypto.createHash('sha256');
		encryptedToken.update(voteToken);
		return encryptedToken.digest(); 
		const token = await tokens.findOne({
		  where: { voteToken: tokenHash }
		});
		if (token.isUsed == 0) {
		  return { statusCode: 405, body: JSON.stringify({ error: 'Este token ya fue usado.' }) };
		}
		
		//Verificar userDemographic con voteDemographic
		const checksum = '0x01'
		const [userDemo, voteDemo] = await Promise.all([
		  UserDemographic.findOne({ where: { userID } }),
		  Proposal.findOne({ where: {proposalID} }),
		  VoteDemographic.findOne({ where: { voteID } })
		]);
		if (userDemo.demographicTypeID !== voteDemo.targetDemographicID) {
		  return {
			statusCode: 406, body: JSON.stringify({ error: 'No tiene permisos de votar por sus características demográficas.' })};
		}
		
		const newComment = await confirmedVotes.create({
        optionVoteID: 1,
        weight: 1,
        encryptedVote: checksum,
        tokenID: voteToken,
        checksum
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
