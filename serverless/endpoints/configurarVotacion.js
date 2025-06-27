
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
