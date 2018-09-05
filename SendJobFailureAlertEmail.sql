USE [master]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

Alter PROCEDURE [dbo].[usp_SendAlertEmail]
As 

set nocount on

declare @body NVARCHAR(4000)
declare @subject NVARCHAR(255)

DECLARE	@SQL NVARCHAR(72),@jobID UNIQUEIDENTIFIER,@jobName SYSNAME
SET	@SQL = 'SET @guid = CAST(' + SUBSTRING(APP_NAME(), 30, 34) + ' AS UNIQUEIDENTIFIER)'
EXEC sp_executesql @SQL, N'@guid UNIQUEIDENTIFIER OUT', @guid = @jobID OUT

SELECT @jobName = name FROM msdb..sysjobs WHERE	job_id = @jobID

set @body = 'SQL Job <b>' + @jobName + '</b> on <b>' + @@servername + '</b> failed.<br / ><br />Check the error log'
set @subject = 'IMPORTANT: SQL Job ' + @jobName + ' on ' + @@servername + ' failed'

EXEC msdb.dbo.sp_send_dbmail
@profile_name = 'yourprofile',
@recipients = 'your recipients@yourorganization.com',
@body = @body,
@subject = @subject,
@body_format='HTML',
@importance='High'
;

GO
