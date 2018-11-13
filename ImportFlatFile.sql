SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

Create procedure [dbo].[ImportFlatFile] @path As varChar(128), @filename As varChar(128), @emailRecipient As varChar(128)
As

Begin

If OBJECT_ID('dbo.tblFlatFileIn') Is Not Null
	Drop Table [dbo].[tblFlatFileIn]

Create Table [dbo].[tblFlatFileIn] (col001 varchar(max))

Declare @BulkCmd As nvarChar(4000)
Set		@BulkCmd = "BULK INSERT tblFlatFileIn FROM '"+@path+@filename+"' WITH (ROWTERMINATOR = '0x0a')"
Exec	(@BulkCmd)

Insert	Into [dbo].[tblFlatFile]
Select	Distinct
		SubString(col001,01,10) As [field01]
,		SubString(col001,11,10) As [field02]
,		SubString(col001,21,10) As [field03]
,		SubString(col001,31,10) As [field05]
,		SubString(col001,41,10) As [field07]
,		SubString(col001,51,10) As [field08]
,		SubString(col001,61,10) As [field09]
,		SubString(col001,71,10) As [field10]
From	[dbo].[tblFlatFileIn]

Declare @body As varChar(max), @kount As int
Set @kount=(Select COUNT(*) From [tblFlatFileIn])

-- Send email confirmation of import
	Set	@body='<style>table{font-family:"Trebuchet MS", Arial, Helvetica, sans-serif;width:100%;border-collapse:collapse;}</style>'
	+Cast(@kount As varchar(10))+' records added to dbo.tblFlatFileIn<br /><br /> From file: '+@filename
	+'<br /><br /><br /><small>SQL Job: JobName [ImportFlatFile]</small>'

	-- Email the excel file
	EXEC msdb..sp_send_dbmail 
		@profile_name='YourMailProfile',
		@recipients=@emailRecipient,
		@subject='Flat File Import Completed',
		@body=@body,
		@body_format='HTML'
		
-- Housekeeping
If OBJECT_ID('dbo.tblFlatFileIn') Is Not Null
	Drop Table [dbo].[tblFlatFileIn]
	
End
