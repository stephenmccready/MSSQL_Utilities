Bulk Insert [dbo].[tbl_MyTable] 
From 'C:\data\myfile.txt'
With (FIELDTERMINATOR = '\t', ROWTERMINATOR = '\n');
