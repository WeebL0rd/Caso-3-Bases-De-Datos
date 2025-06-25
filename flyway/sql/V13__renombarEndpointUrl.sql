USE [pvDB];
GO

EXEC sys.sp_rename 
     @objname = N'pvDB.pv_workflows.enpointUrl', 
     @newname = N'endpointUrl', 
     @objtype = N'COLUMN';
GO
