use portal
select B.BoardID, A.Korean from BD.BoardText A
inner Join BD.BoardINfo B
on A.TextID=B.BoardID
where Boardrootid='SITE02'