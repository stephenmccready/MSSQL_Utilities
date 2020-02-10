SELECT	QUOTENAME(SCHEMA_NAME(sOBJ.schema_id)) + '.' + QUOTENAME(sOBJ.name) AS [TableName], SUM(sPTN.Rows) AS [RowCount], SUM(a.used_pages) * 8 AS UsedSpaceKB
FROM	sys.objects AS sOBJ
JOIN	sys.partitions AS sPTN
		ON sOBJ.object_id = sPTN.object_id
JOIN	sys.allocation_units a 
		ON sPTN.partition_id = a.container_id
WHERE	sOBJ.type = 'U'
AND		sOBJ.is_ms_shipped = 0x0
AND		index_id < 2
GROUP	BY sOBJ.schema_id, sOBJ.name
ORDER	BY [TableName]
