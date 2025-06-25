USE pvDB;
GO

ALTER TABLE pvDB.pv_documents 
    ADD nombreArchivo NVARCHAR(250);
ALTER TABLE pvDB.pv_documents 
    ALTER COLUMN nombreArchivo NVARCHAR(250) NOT NULL;