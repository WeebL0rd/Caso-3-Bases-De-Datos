// endpoints/comentar.js
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

