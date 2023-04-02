--음료 폴더정보
use Portal

--select * from BD.BoardText
--select * from BD.BoardINfo

select B.BoardID, A.Korean from BD.BoardText A
inner Join BD.BoardINfo B
on A.TextID=B.BoardID
where Boardrootid='SITE02'


--게시글정보
select  * from Bd.BoardBase
WHERE 1=1 
	--AND MigMessageID is not null 
	AND Title like '%erp%'

DELETE  Bd.BoardBase
WHERE MigMessageID IN ('622','665')


UPDATE Bd.BoardBase
SET BoardID='262'
WHERE MigMessageID IN ('111','1111')
262



select * from BD.BoardText
select * from BD.BoardINfo


--게시글정보
select  * from Bd.BoardBase
WHERE 1=1 
	AND MigMessageID in ('23881', '23271')

	