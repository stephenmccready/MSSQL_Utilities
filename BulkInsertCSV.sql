SET QUOTED_IDENTIFIER OFF

Declare @lastRow As Int

create table ##tempfile (line varchar(255) null)
insert ##tempfile exec master..xp_cmdshell 'type C:\data\myfile.csv'
Set @lastRow=(select count(*) as NumLines from ##tempfile)-1 --replace 1 with the number of header+footer lines

Drop Table ##tempfile

Declare @BulkCmd As nvarChar(4000)
Set @BulkCmd = "BULK INSERT tbl_myTable FROM "
+"'C:\data\myfile.csv' "
+"WITH (FIRSTROW=2,LASTROW="+CAST(@lastRow As varchar(11))+",FIELDTERMINATOR=',',ROWTERMINATOR='"+CHAR(10)+"')"

Exec	(@BulkCmd)

Select * 
From [dbo].[tbl_myTable]
