use Portal
select * from [BD].[BoardBase]



-- 게시판 이름
use portal
select B.BoardID, A.Korean from BD.BoardText A
inner Join BD.BoardINfo B
on A.TextID=B.BoardID
where Boardrootid='SITE02'


select * from [BD].[BoardInfo] WHere BoardRootID = 'SITE02' AND BoardID = '88'



--게시판 우선공지 사용 변경 Y/N
begin tran
update Portal.BD.BoardInfo
set IsNotice = 'Y'
WHERE BoardRootID = 'SITE02' AND BoardID = '88'
--commit


--전체 게시판 우선공지 사용 변경 Y/N
-- 49개 게시판 
begin tran
update Portal.BD.BoardInfo
set IsNotice = 'N'
WHERE BoardRootID = 'SITE02'
commit