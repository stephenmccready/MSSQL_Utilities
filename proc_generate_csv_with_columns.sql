SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create procedure [dbo].[proc_generate_csv_with_columns]
(
    @db_name    varchar(100),
    @table_name varchar(100),   
    @file_name  varchar(100)
)
as

--Generate column names as a recordset
declare @columns varchar(max), @sql varchar(max), @data_file varchar(100)
select 
    @columns=coalesce(@columns+',','')+'['+column_name+'] as '+replace(column_name,' ','')+''
--    @columns=coalesce(@columns+',','')+column_name+' as '+column_name 
from 
    information_schema.columns
where 
    table_name=@table_name
select @columns=''''''+replace(replace(@columns,' as ',''''' as '),',',',''''')

--Create a dummy file to have actual data
select @data_file=substring(@file_name,1,len(@file_name)-charindex('\',reverse(@file_name)))+'\data_file.csv'

--Generate column names in the passed CSV file
set @sql='exec master..xp_cmdshell ''bcp " select * from (select '+@columns+') as t" queryout "'+@file_name+'" -c -t, -T'''
exec(@sql)

--Generate data in the dummy file
set @sql='exec master..xp_cmdshell ''bcp "select * from '+@db_name+'.dbo.'+@table_name+'" queryout "'+@data_file+'" -c -t, -T'''
exec(@sql)

--Copy dummy file to passed CSV file
set @sql= 'exec master..xp_cmdshell ''type '+@data_file+' >> "'+@file_name+'"'''
exec(@sql)

--Delete dummy file 
set @sql= 'exec master..xp_cmdshell ''del '+@data_file+''''
exec(@sql)
