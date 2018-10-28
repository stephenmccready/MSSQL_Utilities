SET TRANSACTION ISOLATION LEVEL 
                        READ UNCOMMITTED
SELECT TOP 50
 ROUND(s.avg_total_user_cost *
       s.avg_user_impact
        * (s.user_seeks + s.user_scans),0)
                 AS TotalCost
 ,d.[statement] AS TableName
 ,equality_columns
 ,inequality_columns
 ,included_columns
FROM sys.dm_db_missing_index_groups AS g
INNER JOIN sys.dm_db_missing_index_group_stats AS s
  		ON s.group_handle = g.index_group_handle
INNER JOIN sys.dm_db_missing_index_details AS d
		ON d.index_handle = g.index_handle
ORDER BY TotalCost DESC
