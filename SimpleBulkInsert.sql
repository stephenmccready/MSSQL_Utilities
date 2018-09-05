-- Create Table [myDB].[dbo].[myTable] (col1 varchar(max) null)

Truncate Table [myDB].[dbo].[myTable]

Bulk Insert [myDB].[dbo].[myTable] 
From 'C:\data\myfile.dat' With (FormatFile='c:\scripts\myfile.xml');

Select	*
From	[myDB].[dbo].[myTable]

