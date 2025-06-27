
const { Sequelize, DataTypes, Op } = require('sequelize');

const defineConfig = {
  host: 'localhost',
  dialect: 'mssql',
  dialectOptions: { encrypt: false, trustServerCertificate: true },
  logging: false,
  define: { schema: 'pvDB' }
};
const sequelize = new Sequelize('pvDB', 'userORM', 'VotoPuravida', defineConfig);

// Modelos definidos con el esquema 'pvDB'
const User = sequelize.define('User', {
  userID: {type: DataTypes.INTEGER, primaryKey: true, autoIncrement: true},
  name: {type: DataTypes.STRING(60), allowNull: false },
  lastName: {type: DataTypes.STRING(60), allowNull: false},
  email: {type: DataTypes.STRING(80), allowNull: false, unique: true},
  statusID: {type: DataTypes.TINYINT,allowNull: false}
  },
  { tableName: 'pv_users', timestamps: false});

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

// Demographics 
const VoteDemographic = sequelize.define('pv_voteDemographics', {
  voteDemographicID:   { type: DataTypes.INTEGER, primaryKey: true, autoIncrement: true, field: 'voteDemographicID' },
  voteID:              { type: DataTypes.INTEGER, allowNull: false, field: 'voteID' },
  targetDemographicID: { type: DataTypes.INTEGER, allowNull: false, field: 'targetDemographicID' },
  creationDate:        { type: DataTypes.DATE,    allowNull: false, field: 'creationDate' },
  deleted:             { type: DataTypes.BOOLEAN, allowNull: false, field: 'deleted' }
}, { tableName: 'pv_voteDemographics', timestamps: false });

// Proposal owner
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

  const confirmedVotes = sequelize.define('pv_confirmedVotes', {
    confirmedVoteID: { type: DataTypes.BIGINT, primaryKey: true, autoIncrement: true, field: 'confirmedVoteID' },
    optionVoteID:    { type: DataTypes.INTEGER, allowNull: false },
    weight:          { type: DataTypes.DECIMAL(5, 2), allowNull: false },
    encryptedVote:   { type: DataTypes.BLOB, allowNull: false },
    tokenID:         { type: DataTypes.BIGINT, allowNull: false },
    checksum:        { type: DataTypes.BLOB, allowNull: false }
  }, {tableName: 'pv_confirmedVotes', timestamps: false });

  const tokens = sequelize.define('pv_tokens', {
    tokenID:      { type: DataTypes.BIGINT, primaryKey: true, autoIncrement: true, field: 'tokenID' },
    tokenHash:    { type: DataTypes.BLOB, allowNull: false, field: 'tokenHash' },
    creationDate: { type: DataTypes.DATE, allowNull: false, field: 'creationDate' },
    postDate:     { type: DataTypes.DATE, allowNull: false, field: 'postDate' },
    isUsed:       { type: DataTypes.BOOLEAN, allowNull: false, field: 'isUsed' }
  }, {tableName: 'pv_tokens', timestamps: false });

const UserDemographics = sequelize.define('pv_userDemographics', {
    userDemographicID: { type: DataTypes.INTEGER, primaryKey: true, autoIncrement: true, field: 'userDemographicID' },
    value:             { type: DataTypes.STRING(100), allowNull: false, field: 'tokenHash' },
    userID:            { type: DataTypes.INTEGER, allowNull: false, field: 'userID' },
    demographicTypeID: { type: DataTypes.INTEGER, allowNull: false, field: 'demographicTypeID' },
    creationDate:      { type: DataTypes.DATE, allowNull: false, field: 'creationDate' },
    deleted:           { type: DataTypes.BOOLEAN, allowNull: false, field: 'deleted' }
  }, {tableName: 'pv_userDemographics', timestamps: false });
  
const Users = sequelize.define('pv_users', {
  userID:       { type: DataTypes.INTEGER,       primaryKey: true, autoIncrement: true, field: 'userID' },
  name:         { type: DataTypes.STRING(60),    allowNull: false, field: 'name' },
  lastName:     { type: DataTypes.STRING(60),    allowNull: false, field: 'lastName' },
  email:        { type: DataTypes.STRING(80),    allowNull: false, field: 'email' },
  password:     { type: DataTypes.BLOB,          allowNull: false, field: 'password' },
  creationDate: { type: DataTypes.DATE,          allowNull: false, field: 'creationDate' },
  statusID:     { type: DataTypes.TINYINT,       allowNull: false, field: 'statusID' }
}, {tableName: 'pv_users', timestamps: false});



const LogsSeverity = sequelize.define('LogsSeverity', {
  logSeverityID: { type: DataTypes.INTEGER, primaryKey: true, autoIncrement: true },
  name: { type: DataTypes.STRING(45), allowNull: false }
}, {
  tableName: 'pv_logsSeverity',
  timestamps: false
});

const LogSources = sequelize.define('LogSources', {
  logSourcesID: { type: DataTypes.INTEGER, primaryKey: true, autoIncrement: true },
  name: { type: DataTypes.STRING(45), allowNull: false }
}, {
  tableName: 'pv_logSources',
  timestamps: false
});


const LogTypes = sequelize.define('LogTypes', {
  logTypesID: { type: DataTypes.INTEGER, primaryKey: true, autoIncrement: true },
  name: { type: DataTypes.STRING(45), allowNull: false },
  reference1Description: { type: DataTypes.STRING(75), allowNull: true },
  reference2Description: { type: DataTypes.STRING(75), allowNull: true },
  value1Description: { type: DataTypes.STRING(75), allowNull: true },
  value2Description: { type: DataTypes.STRING(75), allowNull: true }
}, {
  tableName: 'pv_logTypes',
  timestamps: false
});


const Log = sequelize.define('Log', {
  log_id: { type: DataTypes.INTEGER, primaryKey: true, autoIncrement: true },
  description: { type: DataTypes.STRING(200), allowNull: false },
  postTime: { type: DataTypes.DATE, allowNull: false, defaultValue: Sequelize.NOW },
  computer: { type: DataTypes.STRING(75), allowNull: false },
  username: { type: DataTypes.STRING(50), allowNull: false },
  trace: { type: DataTypes.STRING(100), allowNull: true },
  reference1Id: { type: DataTypes.BIGINT, allowNull: true },
  reference2Id: { type: DataTypes.BIGINT, allowNull: true },
  value1: { type: DataTypes.STRING(180), allowNull: true },
  value2: { type: DataTypes.STRING(180), allowNull: true },
  checksum: { type: DataTypes.BLOB('long'), allowNull: false },
  logSeverityID: { type: DataTypes.INTEGER, allowNull: false, references: { model: 'LogSeverity', key: 'logSeverityID' }},
  logTypesID: { type: DataTypes.INTEGER, allowNull: false, references: { model: 'LogType', key: 'logTypesID' } },
  logSourcesID: { type: DataTypes.INTEGER, allowNull: false, references: { model: 'LogSource',key: 'logSourcesID' } }
}, {
  tableName: 'pv_logs',
  timestamps: false // No createdAt/updatedAt, 'postTime' serves this purpose
});

UserSession.belongsTo(User, { foreignKey: 'userID' });
User.hasMany(UserSession, { foreignKey: 'userID' });

Log.belongsTo(LogsSeverity, { foreignKey: 'logSeverityID' });
LogsSeverity.hasMany(Log, { foreignKey: 'logSeverityID' });

Log.belongsTo(LogSources, { foreignKey: 'logSourcesID' });
LogSources.hasMany(Log, { foreignKey: 'logSourcesID' });

Log.belongsTo(LogTypes, { foreignKey: 'logTypesID' });
LogTypes.hasMany(Log, { foreignKey: 'logTypesID' });

module.exports = {
  sequelize, Op,
  User, Log, LogsSeverity, LogSources, LogTypes,
  UserSession, Proposal, Comment,
  Voting, VoteOption, VoteDemographic,
  UserProposal, OrgProposal, UserOrganization,
  confirmedVotes,
  tokens,
  UserDemographics,
  Users
};
