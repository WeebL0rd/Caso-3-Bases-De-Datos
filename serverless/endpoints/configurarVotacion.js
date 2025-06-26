// endpoints/configurarVotacion.js
require('dotenv').config();
const { sequelize, Proposal, Voting, VoteOption, VoteDemographic, UserProposal, OrgProposal, UserOrganization } = require('./models');

module.exports.configurarVotacion = async (event) => {
  const { userID, proposalID, startDate, endDate, options, demographics } = JSON.parse(event.body || '{}');
  if (!userID || !proposalID || !startDate || !endDate || !Array.isArray(options) || !Array.isArray(demographics)) {
    return { statusCode: 400, body: JSON.stringify({ error: 'Faltan parámetros: userID, proposalID, startDate, endDate, options[] y demographics[].' }) };
  }

  try {
    await sequelize.authenticate();

    // 1) Permisos: autor usuario u organización
    let hasPermission = false;
    const isUserAuthor = await UserProposal.findOne({ where: { proposalID, userID } });
    if (isUserAuthor) hasPermission = true;
    if (!hasPermission) {
      const userOrgs = await UserOrganization.findAll({ where: { userID } });
      const orgIDs = userOrgs.map(uo => uo.organizationID);
      const orgProps = await OrgProposal.findAll({ where: { proposalID } });
      if (orgProps.some(op => orgIDs.includes(op.organizationID))) hasPermission = true;
    }
    if (!hasPermission) {
      return { statusCode: 403, body: JSON.stringify({ error: 'Sin permisos para configurar esta propuesta.' }) };
    }

    // 2) Crear registro en pv_votes
    const voting = await Voting.create({ proposalID, startDate: new Date(startDate), endDate: new Date(endDate), commentsEnabled: true });

    // 3) Opciones de voto
    const opts = options.map(text => ({ voteQuestionID: voting.voteID, optionText: text, creationDate: new Date(), enabled: true }));
    await VoteOption.bulkCreate(opts);

    // 4) Demográficos meta
    const demLinks = demographics.map(id => ({ voteID: voting.voteID, targetDemographicID: id }));
    await VoteDemographic.bulkCreate(demLinks);

    return { statusCode: 201, body: JSON.stringify({ voteID: voting.voteID }) };
  } catch (err) {
    console.error('Error en configurarVotacion:', err);
    return { statusCode: 500, body: JSON.stringify({ error: 'Error interno al configurar votación.' }) };
  }
};
