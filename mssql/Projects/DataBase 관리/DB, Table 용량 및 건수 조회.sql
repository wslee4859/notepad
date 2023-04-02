
-- DataBase ���� 
sp_helpdb 'im80'


-- TABLE �뷮

SELECT CONVERT(VARCHAR(30), MIN(o.name)) AS t_name
     , LTRIM(STR(SUM(reserved) * 8192.0 / 1024.0, 15, 0) + ' KB') AS t_size
FROM   sysindexes i
           INNER JOIN sysobjects o ON o.id = i.id
WHERE  i.indid IN (0, 1, 255)
   AND o.xtype = 'U'
GROUP BY
       i.id
ORDER BY
       -- t_name ASC
       SUM(reserved) * 8192.0 / 1024.0 DESC



-- table �Ǽ� 
SELECT o.name
     , i.rows
FROM   sysindexes i
           INNER JOIN sysobjects o ON i.id = o.id
WHERE  i.indid < 2
   AND o.xtype = 'U'
ORDER BY
       i.rows DESC