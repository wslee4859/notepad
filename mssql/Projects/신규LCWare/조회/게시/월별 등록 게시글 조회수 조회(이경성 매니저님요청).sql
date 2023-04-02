/*************************************
* �Խñ� ��� �Ǽ� (�̰漺 �Ŵ����� ��û)
*************************************/

SELECT 
T.Korean
,M.BoardID
,M.CreateDate
,M.Title
,M.ViewCnt
,M.UserName
,M.DeptName
FROM [BD].[BoardBase] AS M
INNER JOIN [BD].[BoardText] AS T
ON M.BoardID = T.TextID
INNER JOIN [BD].[BoardInfo] AS I
ON I.BoardID = M.BoardID AND BoardRootID = 'SITE01'
WHERE M.CreateDate > '2018-01-01' AND M.CreateDate < '2018-03-01'
order by M.createDate





SELECT 
T.Korean
,M.BoardID
,M.CreateDate
,M.Title
,M.ViewCnt
,M.UserName
,M.DeptName
FROM [BD].[BoardBase] AS M
INNER JOIN [BD].[BoardText] AS T
ON M.BoardID = T.TextID
INNER JOIN [BD].[BoardInfo] AS I
ON I.BoardID = M.BoardID AND BoardRootID = 'SITE01'
WHERE M.CreateDate > '2018-03-01' AND M.CreateDate < '2018-05-01'
order by M.createDate