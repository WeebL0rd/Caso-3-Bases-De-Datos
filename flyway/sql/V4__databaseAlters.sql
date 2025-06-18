use pvDB;

ALTER TABLE pvDB.pv_proposals ADD enableComments BIT default 1;

EXEC sp_rename 'pvDB.pv_proposals.current', 'currentProposal', 'COLUMN';
EXEC sp_rename 'pvDB.pv_logsSererity.logSererityID', 'logSeverityID', 'COLUMN';
EXEC sp_rename 'pvDB.pv_logsSererity', 'pv_logsSeverity', 'OBJECT';

DROP TABLE IF EXISTS pvDB.pv_organization_type_has_pv_documentType;
