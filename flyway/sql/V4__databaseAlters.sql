use pvDB;

ALTER TABLE pvDB.pv_proposals ADD enableComments BIT default 1;
ALTER TABLE pvDB.pv_proposals ADD checksum VARBINARY(300);

EXEC sp_rename 'pvDB.pv_proposals.current', 'currentProposal', 'COLUMN';
EXEC sp_rename 'pvDB.pv_logsSererity.logSererityID', 'logSeverityID', 'COLUMN';
EXEC sp_rename 'pvDB.pv_logsSererity', 'pv_logsSeverity', 'OBJECT';

DROP TABLE IF EXISTS pvDB.pv_organization_type_has_pv_documentType;

ALTER TABLE pvDB.pv_targetDemographics DROP CONSTRAINT pv_targetDemographics$fk_pv_targetDemographics_pv_targetTypes1;
ALTER TABLE pvDB.pv_targetDemographics DROP COLUMN targetTypeID;
DROP TABLE IF EXISTS pvDB.pv_targetTypes;
