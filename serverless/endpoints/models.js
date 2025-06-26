// endpoints/models.js
const { Sequelize, DataTypes, Op } = require('sequelize');

// Configuración de Sequelize apuntando al esquema pvDB
const sequelize = new Sequelize('pvDB', 'userORM', 'VotoPuravida', {
  host: 'localhost',
  dialect: 'mssql',
  dialectOptions: { encrypt: false, trustServerCertificate: true },
  logging: false,
  define: {
    schema: 'pvDB'
  }
});

// Modelos definidos con el esquema 'pvDB'

const UserSession = sequelize.define('pv_userSessions', {
  userSessionID: { type: DataTypes.INTEGER, primaryKey: true, field: 'userSessionID' },
  userID:         { type: DataTypes.INTEGER, allowNull: false, field: 'userID' },
  expirationDate: { type: DataTypes.DATE,    allowNull: false, field: 'expirationDate' }
}, { tableName: 'pv_userSessions', timestamps: false });

const Proposal = sequelize.define('pv_proposals', {
  proposalID:     { type: DataTypes.INTEGER, primaryKey: true, field: 'proposalID' },
  enableComments: { type: DataTypes.BOOLEAN, allowNull: false, field: 'enableComments' }
}, { tableName: 'pv_proposals', timestamps: false });

const Comment = sequelize.define('pv_comments', {
  commentID:       { type: DataTypes.INTEGER, primaryKey: true, autoIncrement: true, field: 'commentID' },
  proposeID:       { type: DataTypes.INTEGER, allowNull: false, field: 'proposeID' },
  userID:          { type: DataTypes.INTEGER, allowNull: false, field: 'userID' },
  title:           { type: DataTypes.STRING(80), field: 'title' },
  text:            { type: DataTypes.TEXT, field: 'text' },
  date:            { type: DataTypes.DATE, field: 'date' },
  commentStatusID: { type: DataTypes.SMALLINT, allowNull: false, field: 'commentStatusID' }
}, { tableName: 'pv_comments', timestamps: false });

const Voting = sequelize.define('pv_votes', {
  voteID:          { type: DataTypes.INTEGER, primaryKey: true, autoIncrement: true, field: 'voteID' },
  proposalID:      { type: DataTypes.INTEGER, allowNull: false, field: 'proposalID' },
  startDate:       { type: DataTypes.DATE, allowNull: false, field: 'startDate' },
  endDate:         { type: DataTypes.DATE, allowNull: false, field: 'endDate' },
  commentsEnabled: { type: DataTypes.BOOLEAN, allowNull: false, field: 'commentsEnabled' }
}, { tableName: 'pv_votes', timestamps: false });

const VoteOption = sequelize.define('pv_voteOptions', {
  voteOptionID:    { type: DataTypes.INTEGER, primaryKey: true, autoIncrement: true, field: 'voteOptionID' },
  voteQuestionID:  { type: DataTypes.INTEGER, allowNull: false, field: 'voteQuestionID' },
  optionText:      { type: DataTypes.STRING(100), allowNull: false, field: 'optionText' },
  creationDate:    { type: DataTypes.DATE, allowNull: false, field: 'creationDate' },
  enabled:         { type: DataTypes.BOOLEAN, allowNull: false, field: 'enabled' }
}, { tableName: 'pv_voteOptions', timestamps: false });

const VoteDemographic = sequelize.define('pv_voteDemographics', {
  voteDemographicID: { type: DataTypes.INTEGER, primaryKey: true, autoIncrement: true, field: 'voteDemographicID' },
  voteID:            { type: DataTypes.INTEGER, allowNull: false, field: 'voteID' },
  targetDemographicID:{ type: DataTypes.INTEGER, allowNull: false, field: 'targetDemographicID' }
}, { tableName: 'pv_voteDemographics', timestamps: false });

const UserProposal = sequelize.define('pv_userProposals', {
  id:            { type: DataTypes.INTEGER, primaryKey: true, autoIncrement: true, field: 'id' },
  proposalID:    { type: DataTypes.INTEGER, allowNull: false, field: 'proposalID' },
  userID:        { type: DataTypes.INTEGER, allowNull: false, field: 'userID' }
}, { tableName: 'pv_userProposals', timestamps: false });

const OrgProposal = sequelize.define('pv_organizationProposals', {
  id:              { type: DataTypes.INTEGER, primaryKey: true, autoIncrement: true, field: 'id' },
  proposalID:      { type: DataTypes.INTEGER, allowNull: false, field: 'proposalID' },
  organizationID:  { type: DataTypes.INTEGER, allowNull: false, field: 'organizationID' }
}, { tableName: 'pv_organizationProposals', timestamps: false });

const UserOrganization = sequelize.define('pv_userOrganization', {
  id:              { type: DataTypes.INTEGER, primaryKey: true, autoIncrement: true, field: 'id' },
  userID:          { type: DataTypes.INTEGER, allowNull: false, field: 'userID' },
  organizationID:  { type: DataTypes.INTEGER, allowNull: false, field: 'organizationID' }
}, { tableName: 'pv_userOrganization', timestamps: false });

module.exports = {
  sequelize, Op,
  UserSession, Proposal, Comment,
  Voting, VoteOption, VoteDemographic,
  UserProposal, OrgProposal, UserOrganization
};
