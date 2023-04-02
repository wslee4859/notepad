use Portal
select B.BoardID, A.Korean from BD.BoardText A
inner Join BD.BoardINfo B
on A.TextID=B.BoardID
where Boardrootid='SITE01'  -- 사이트코드
AND BoardID = '1490'




use Portal
select B.BoardID, A.Korean, A.English, BACL.UnitName, BACL.Permission, ParentID, Depth, B.OrderNumber 
from BD.BoardText A
inner Join BD.BoardINfo B
on A.TextID=B.BoardID
inner JOIN [BD].[BoardACL] BACL
ON B.BoardID = BACL.ResourceID
where Boardrootid='SITE01'  -- 사이트코드
order by BoardID, Depth, OrderNumber


WITH T AS
	(
		SELECT 
			 B.BoardID, B.parentID, A.Korean, A.English, B.Depth, B.OrderNumber
		FROM BD.BoardText AS A 	
		inner Join BD.BoardINfo B
		on A.TextID=B.BoardID	
		where Boardrootid='SITE01' AND B.BoardID in ('250')

		UNION ALL
		SELECT 
			 B.BoardID, B.parentID, A.Korean, A.English, B.Depth, B.OrderNumber
		FROM BD.BoardText AS A 	
		inner Join BD.BoardINfo B
		on A.TextID=B.BoardID	
		INNER JOIN T AS T
		ON B.ParentID = T.BoardID	
		       
	)
	select * from T 
