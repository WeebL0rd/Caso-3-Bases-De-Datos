// endpoints/models.js
const { Sequelize, DataTypes, Op } = require('sequelize');

const defineConfig = {
  host: 'localhost',
  dialect: 'mssql',
  dialectOptions: { encrypt: false, trustServerCertificate: true },
  logging: false,
  define: { schema: 'pvDB' }
};
const sequelize = new Sequelize('pvDB', 'userORM', 'VotoPuravida', defineConfig);

// User sessions
const UserSession = sequelize.define('pv_userSessions', {
  userSessionID: { type: DataTypes.INTEGER, primaryKey: true, field: 'userSessionID' },
  userID:         { type: DataTypes.INTEGER, allowNull: false, field: 'userID' },
  expirationDate: { type: DataTypes.DATE,    allowNull: false, field: 'expirationDate' }
}, { tableName: 'pv_userSessions', timestamps: false });

// Proposals
const Proposal = sequelize.define('pv_proposals', {
  proposalID:     { type: DataTypes.INTEGER, primaryKey: true, field: 'proposalID' },
  enableComments: { type: DataTypes.BOOLEAN, allowNull: false, field: 'enableComments' }
}, { tableName: 'pv_proposals', timestamps: false });

// Comments
const Comment = sequelize.define('pv_comments', {
  commentID:       { type: DataTypes.INTEGER, primaryKey: true, autoIncrement: true, field: 'commentID' },
  proposeID:       { type: DataTypes.INTEGER, allowNull: false, field: 'proposeID' },
  userID:          { type: DataTypes.INTEGER, allowNull: false, field: 'userID' },
  title:           { type: DataTypes.STRING(80), field: 'title' },
  text:            { type: DataTypes.TEXT, field: 'text' },
  date:            { type: DataTypes.DATE, field: 'date' },
  commentStatusID: { type: DataTypes.SMALLINT, allowNull: false, field: 'commentStatusID' }
}, { tableName: 'pv_comments', timestamps: false });

// Votes
const Voting = sequelize.define('pv_votes', {
  voteID:            { type: DataTypes.INTEGER, primaryKey: true, autoIncrement: true, field: 'voteID' },
  topic:             { type: DataTypes.STRING(100), allowNull: false, field: 'topic' },
  voteTypeID:        { type: DataTypes.INTEGER, allowNull: false, field: 'voteTypeID' },
  voteStatusID:      { type: DataTypes.SMALLINT, allowNull: false, field: 'voteStatusID' },
  proposalID:        { type: DataTypes.INTEGER, allowNull: false, field: 'proposalID' },
  approvalTypeID:    { type: DataTypes.INTEGER, allowNull: false, field: 'approvalTypeID' },
  approvalCriteria:  { type: DataTypes.STRING(80), allowNull: false, field: 'approvalCriteria' },
  strictDemographic: { type: DataTypes.BOOLEAN, allowNull: false, field: 'strictDemographic' },
  startDate:         { type: DataTypes.DATE, allowNull: false, field: 'startDate' },
  endDate:           { type: DataTypes.DATE, allowNull: false, field: 'endDate' },
  creationDate:      { type: DataTypes.DATE, allowNull: false, field: 'creationDate' },
  lastUpdate:        { type: DataTypes.DATE, allowNull: false, field: 'lastUpdate' },
  commentsEnabled:   { type: DataTypes.BOOLEAN, allowNull: false, field: 'commentsEnabled' }
}, { tableName: 'pv_votes', timestamps: false });

// Vote questions
const VoteQuestion = sequelize.define('pv_voteQuestions', {
  voteQuestionID:  { type: DataTypes.INTEGER, primaryKey: true, autoIncrement: true, field: 'voteQuestionID' },
  voteID:          { type: DataTypes.INTEGER, allowNull: false, field: 'voteID' },
  question:        { type: DataTypes.STRING(100), allowNull: false, field: 'question' },
  answerQuantity:  { type: DataTypes.SMALLINT, allowNull: false, field: 'answerQuantity' },
  creationDate:    { type: DataTypes.DATE, allowNull: false, field: 'creationDate' },
  deleted:         { type: DataTypes.BLOB, allowNull: false, field: 'deleted' },
  checksum:        { type: DataTypes.BLOB, allowNull: false, field: 'checksum' }
}, { tableName: 'pv_voteQuestions', timestamps: false });

// Vote options
const VoteOption = sequelize.define('pv_voteOptions', {
  voteOptionID:   { type: DataTypes.INTEGER, primaryKey: true, autoIncrement: true, field: 'voteOptionID' },
  voteQuestionID: { type: DataTypes.INTEGER, allowNull: false, field: 'voteQuestionID' },
  optionText:     { type: DataTypes.STRING(100), allowNull: false, field: 'optionText' },
  optionNumber:   { type: DataTypes.SMALLINT, allowNull: false, field: 'optionNumber' },
  value:          { type: DataTypes.STRING(20), allowNull: false, field: 'value' },
  creationDate:   { type: DataTypes.DATE, allowNull: false, field: 'creationDate' },
  enabled:        { type: DataTypes.BOOLEAN, allowNull: false, field: 'enabled' },
  deleted:        { type: DataTypes.BLOB, allowNull: false, field: 'deleted' },
  checksum:       { type: DataTypes.BLOB, allowNull: false, field: 'checksum' }
}, { tableName: 'pv_voteOptions', timestamps: false });

// Demographics link (actualizado)
const VoteDemographic = sequelize.define('pv_voteDemographics', {
  voteDemographicID:   { type: DataTypes.INTEGER, primaryKey: true, autoIncrement: true, field: 'voteDemographicID' },
  voteID:              { type: DataTypes.INTEGER, allowNull: false, field: 'voteID' },
  targetDemographicID: { type: DataTypes.INTEGER, allowNull: false, field: 'targetDemographicID' },
  creationDate:        { type: DataTypes.DATE,    allowNull: false, field: 'creationDate' },
  deleted:             { type: DataTypes.BOOLEAN, allowNull: false, field: 'deleted' }
}, { tableName: 'pv_voteDemographics', timestamps: false });

// Proposal ownership
const UserProposal = sequelize.define('pv_UserProposals', {
  userProposalID: { type: DataTypes.INTEGER, primaryKey: true, field: 'userProposalID' },
  proposalID:     { type: DataTypes.INTEGER, allowNull: false, field: 'proposalID' },
  userID:         { type: DataTypes.INTEGER, allowNull: false, field: 'userID' }
}, { tableName: 'pv_UserProposals', timestamps: false });

const OrgProposal = sequelize.define('pv_organizationProposals', {
  id:             { type: DataTypes.INTEGER, primaryKey: true, autoIncrement: true, field: 'id' },
  proposalID:     { type: DataTypes.INTEGER, allowNull: false, field: 'proposalID' },
  organizationID: { type: DataTypes.INTEGER, allowNull: false, field: 'organizationID' }
}, { tableName: 'pv_organizationProposals', timestamps: false });

const UserOrganization = sequelize.define('pv_userOrganization', {
  id:             { type: DataTypes.INTEGER, primaryKey: true, autoIncrement: true, field: 'id' },
  userID:         { type: DataTypes.INTEGER, allowNull: false, field: 'userID' },
  organizationID: { type: DataTypes.INTEGER, allowNull: false, field: 'organizationID' }
}, { tableName: 'pv_userOrganization', timestamps: false });

module.exports = {
  sequelize,
  Op,
  UserSession,
  Proposal,
  Comment,
  Voting,
  VoteQuestion,
  VoteOption,
  VoteDemographic,
  UserProposal,
  OrgProposal,
  UserOrganization
};
