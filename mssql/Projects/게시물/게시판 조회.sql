use eGW
select A.MESSAGEID,F.FolderName, E.FolderName,D.FolderName, C.FolderName, B.FolderName, A.CREATEDATE, A.SUBJECT, A.CREATORDEPTNAME, A.DELETEDATE 
from [dbo].[TB_BOARD] A
	left JOIN eManage.[dbo].[TB_FOLDER] AS B
	ON B.FolderID = A.FolderID
	left JOIN eManage.[dbo].[TB_FOLDER] AS C
	ON B.ParentFolderID = C.FolderID
	left JOIN eManage.[dbo].[TB_FOLDER] AS D
	ON C.ParentFolderID = D.FolderID
	left JOIN eManage.[dbo].[TB_FOLDER] AS E
	ON D.ParentFolderID = E.FolderID
	left JOIN eManage.[dbo].[TB_FOLDER] AS F
	ON E.ParentFolderID = F.FolderID
where  1= 1
	AND A.DELETEDATE > getdate() 
	AND B.FolderName like '%관리직%' 
ORDER BY CREATEDATE DESC

use eGW
select A.MESSAGEID,F.FolderName, E.FolderName,D.FolderName, C.FolderName, B.FolderName, A.CREATEDATE, A.SUBJECT, A.CREATORDEPTNAME, A.DELETEDATE 
from [dbo].[TB_BOARD] A
	left JOIN eManage.[dbo].[TB_FOLDER] AS B
	ON B.FolderID = A.FolderID
	left JOIN eManage.[dbo].[TB_FOLDER] AS C
	ON B.ParentFolderID = C.FolderID
	left JOIN eManage.[dbo].[TB_FOLDER] AS D
	ON C.ParentFolderID = D.FolderID
	left JOIN eManage.[dbo].[TB_FOLDER] AS E
	ON D.ParentFolderID = E.FolderID
	left JOIN eManage.[dbo].[TB_FOLDER] AS F
	ON E.ParentFolderID = F.FolderID
where  1= 1
	AND A.DELETEDATE > getdate() 
	AND B.FolderName like '%일반직%' 
	AND C.FolderName like '%인사발령%'
ORDER BY CREATEDATE DESC

use eGW
select A.MESSAGEID,F.FolderName, E.FolderName,D.FolderName, C.FolderName, B.FolderName, A.CREATEDATE, A.SUBJECT, A.CREATORDEPTNAME, A.DELETEDATE 
from [dbo].[TB_BOARD] A
	left JOIN eManage.[dbo].[TB_FOLDER] AS B
	ON B.FolderID = A.FolderID
	left JOIN eManage.[dbo].[TB_FOLDER] AS C
	ON B.ParentFolderID = C.FolderID
	left JOIN eManage.[dbo].[TB_FOLDER] AS D
	ON C.ParentFolderID = D.FolderID
	left JOIN eManage.[dbo].[TB_FOLDER] AS E
	ON D.ParentFolderID = E.FolderID
	left JOIN eManage.[dbo].[TB_FOLDER] AS F
	ON E.ParentFolderID = F.FolderID
where  1= 1
	AND A.DELETEDATE > getdate() 
	AND B.FolderName like '%전사 게시판%'
ORDER BY CREATEDATE DESC


use eGW
select A.MESSAGEID,F.FolderName, E.FolderName,D.FolderName, C.FolderName, B.FolderName, A.CREATEDATE, A.SUBJECT, A.CREATORDEPTNAME, A.DELETEDATE 
from [dbo].[TB_BOARD] A
	left JOIN eManage.[dbo].[TB_FOLDER] AS B
	ON B.FolderID = A.FolderID
	left JOIN eManage.[dbo].[TB_FOLDER] AS C
	ON B.ParentFolderID = C.FolderID
	left JOIN eManage.[dbo].[TB_FOLDER] AS D
	ON C.ParentFolderID = D.FolderID
	left JOIN eManage.[dbo].[TB_FOLDER] AS E
	ON D.ParentFolderID = E.FolderID
	left JOIN eManage.[dbo].[TB_FOLDER] AS F
	ON E.ParentFolderID = F.FolderID
where  1= 1
	AND A.DELETEDATE > getdate() 
	AND B.FolderName like '%연말정산%'
	AND C.FolderName like '%인사정보 관련%'
ORDER BY CREATEDATE DESC

use eGW
select A.MESSAGEID,F.FolderName, E.FolderName,D.FolderName, C.FolderName, B.FolderName, A.CREATEDATE, A.SUBJECT, A.CREATORDEPTNAME, A.DELETEDATE 
from [dbo].[TB_BOARD] A
	left JOIN eManage.[dbo].[TB_FOLDER] AS B
	ON B.FolderID = A.FolderID
	left JOIN eManage.[dbo].[TB_FOLDER] AS C
	ON B.ParentFolderID = C.FolderID
	left JOIN eManage.[dbo].[TB_FOLDER] AS D
	ON C.ParentFolderID = D.FolderID
	left JOIN eManage.[dbo].[TB_FOLDER] AS E
	ON D.ParentFolderID = E.FolderID
	left JOIN eManage.[dbo].[TB_FOLDER] AS F
	ON E.ParentFolderID = F.FolderID
where  1= 1
	AND A.DELETEDATE > getdate() 
	AND B.FolderName like '%승진자격 시험%'
	AND C.FolderName like '%인사정보 관련%'
ORDER BY CREATEDATE DESC


use eGW
select A.MESSAGEID,F.FolderName, E.FolderName,D.FolderName, C.FolderName, B.FolderName, A.CREATEDATE, A.SUBJECT, A.CREATORDEPTNAME, A.DELETEDATE 
from [dbo].[TB_BOARD] A
	left JOIN eManage.[dbo].[TB_FOLDER] AS B
	ON B.FolderID = A.FolderID
	left JOIN eManage.[dbo].[TB_FOLDER] AS C
	ON B.ParentFolderID = C.FolderID
	left JOIN eManage.[dbo].[TB_FOLDER] AS D
	ON C.ParentFolderID = D.FolderID
	left JOIN eManage.[dbo].[TB_FOLDER] AS E
	ON D.ParentFolderID = E.FolderID
	left JOIN eManage.[dbo].[TB_FOLDER] AS F
	ON E.ParentFolderID = F.FolderID
where  1= 1
	AND A.DELETEDATE > getdate() 
	AND B.FolderName like '%D/W 시스템 정보%'
	AND C.FolderName like '%전산정보 관련%'
ORDER BY CREATEDATE DESC


use eGW
select A.MESSAGEID,F.FolderName, E.FolderName,D.FolderName, C.FolderName, B.FolderName, A.CREATEDATE, A.SUBJECT, A.CREATORDEPTNAME, A.DELETEDATE 
from [dbo].[TB_BOARD] A
	left JOIN eManage.[dbo].[TB_FOLDER] AS B
	ON B.FolderID = A.FolderID
	left JOIN eManage.[dbo].[TB_FOLDER] AS C
	ON B.ParentFolderID = C.FolderID
	left JOIN eManage.[dbo].[TB_FOLDER] AS D
	ON C.ParentFolderID = D.FolderID
	left JOIN eManage.[dbo].[TB_FOLDER] AS E
	ON D.ParentFolderID = E.FolderID
	left JOIN eManage.[dbo].[TB_FOLDER] AS F
	ON E.ParentFolderID = F.FolderID
where  1= 1
	AND A.DELETEDATE > getdate() 
	AND B.FolderName like '%전산변경사항(생산)%'
	AND C.FolderName like '%전산정보 관련%'
ORDER BY CREATEDATE DESC

use eGW
select A.MESSAGEID,F.FolderName, E.FolderName,D.FolderName, C.FolderName, B.FolderName, A.CREATEDATE, A.SUBJECT, A.CREATORDEPTNAME, A.DELETEDATE 
from [dbo].[TB_BOARD] A
	left JOIN eManage.[dbo].[TB_FOLDER] AS B
	ON B.FolderID = A.FolderID
	left JOIN eManage.[dbo].[TB_FOLDER] AS C
	ON B.ParentFolderID = C.FolderID
	left JOIN eManage.[dbo].[TB_FOLDER] AS D
	ON C.ParentFolderID = D.FolderID
	left JOIN eManage.[dbo].[TB_FOLDER] AS E
	ON D.ParentFolderID = E.FolderID
	left JOIN eManage.[dbo].[TB_FOLDER] AS F
	ON E.ParentFolderID = F.FolderID
where  1= 1
	AND A.DELETEDATE > getdate() 
	AND B.FolderName like '%ISO 관련%'
	--AND C.FolderName like '%전산정보 관련%'
ORDER BY CREATEDATE DESC


use eGW
select A.MESSAGEID,F.FolderName, E.FolderName,D.FolderName, C.FolderName, B.FolderName, A.CREATEDATE, A.SUBJECT, A.CREATORDEPTNAME, A.DELETEDATE 
from [dbo].[TB_BOARD] A
	left JOIN eManage.[dbo].[TB_FOLDER] AS B
	ON B.FolderID = A.FolderID
	left JOIN eManage.[dbo].[TB_FOLDER] AS C
	ON B.ParentFolderID = C.FolderID
	left JOIN eManage.[dbo].[TB_FOLDER] AS D
	ON C.ParentFolderID = D.FolderID
	left JOIN eManage.[dbo].[TB_FOLDER] AS E
	ON D.ParentFolderID = E.FolderID
	left JOIN eManage.[dbo].[TB_FOLDER] AS F
	ON E.ParentFolderID = F.FolderID
where  1= 1
	AND A.DELETEDATE > getdate() 
	AND B.FolderName like '%광고정보%'
	AND C.FolderName like '%제품/사내외 정보 관련%'
ORDER BY CREATEDATE DESC

use eGW
select A.MESSAGEID,F.FolderName, E.FolderName,D.FolderName, C.FolderName, B.FolderName, A.CREATEDATE, A.SUBJECT, A.CREATORDEPTNAME, A.DELETEDATE 
from [dbo].[TB_BOARD] A
	left JOIN eManage.[dbo].[TB_FOLDER] AS B
	ON B.FolderID = A.FolderID
	left JOIN eManage.[dbo].[TB_FOLDER] AS C
	ON B.ParentFolderID = C.FolderID
	left JOIN eManage.[dbo].[TB_FOLDER] AS D
	ON C.ParentFolderID = D.FolderID
	left JOIN eManage.[dbo].[TB_FOLDER] AS E
	ON D.ParentFolderID = E.FolderID
	left JOIN eManage.[dbo].[TB_FOLDER] AS F
	ON E.ParentFolderID = F.FolderID
where  1= 1
	AND A.DELETEDATE > getdate() 
	AND B.FolderName like '%사내주소/전화번호%'
	AND C.FolderName like '%자유정보 관련%'
ORDER BY CREATEDATE DESC


use eGW
select A.MESSAGEID,F.FolderName, E.FolderName,D.FolderName, C.FolderName, B.FolderName, A.CREATEDATE, A.SUBJECT, A.CREATORDEPTNAME, A.DELETEDATE 
from [dbo].[TB_BOARD] A
	left JOIN eManage.[dbo].[TB_FOLDER] AS B
	ON B.FolderID = A.FolderID
	left JOIN eManage.[dbo].[TB_FOLDER] AS C
	ON B.ParentFolderID = C.FolderID
	left JOIN eManage.[dbo].[TB_FOLDER] AS D
	ON C.ParentFolderID = D.FolderID
	left JOIN eManage.[dbo].[TB_FOLDER] AS E
	ON D.ParentFolderID = E.FolderID
	left JOIN eManage.[dbo].[TB_FOLDER] AS F
	ON E.ParentFolderID = F.FolderID
where  1= 1
	AND A.DELETEDATE > getdate() 
	AND B.FolderName like '%기타정보%'
	AND C.FolderName like '%자유정보 관련%'
ORDER BY CREATEDATE DESC

use eGW
select A.MESSAGEID,F.FolderName, E.FolderName,D.FolderName, C.FolderName, B.FolderName, A.CREATEDATE, A.SUBJECT, A.CREATORDEPTNAME, A.DELETEDATE 
from [dbo].[TB_BOARD] A
	left JOIN eManage.[dbo].[TB_FOLDER] AS B
	ON B.FolderID = A.FolderID
	left JOIN eManage.[dbo].[TB_FOLDER] AS C
	ON B.ParentFolderID = C.FolderID
	left JOIN eManage.[dbo].[TB_FOLDER] AS D
	ON C.ParentFolderID = D.FolderID
	left JOIN eManage.[dbo].[TB_FOLDER] AS E
	ON D.ParentFolderID = E.FolderID
	left JOIN eManage.[dbo].[TB_FOLDER] AS F
	ON E.ParentFolderID = F.FolderID
where  1= 1
	AND A.DELETEDATE > getdate() 
	AND B.FolderName like '%기타정보 관련%'
	--AND C.FolderName like '%자유정보 관련%'
ORDER BY CREATEDATE DESC


use eGW
select A.MESSAGEID,F.FolderName, E.FolderName,D.FolderName, C.FolderName, B.FolderName, A.CREATEDATE, A.SUBJECT, A.CREATORDEPTNAME, A.DELETEDATE 
from [dbo].[TB_BOARD] A
	left JOIN eManage.[dbo].[TB_FOLDER] AS B
	ON B.FolderID = A.FolderID
	left JOIN eManage.[dbo].[TB_FOLDER] AS C
	ON B.ParentFolderID = C.FolderID
	left JOIN eManage.[dbo].[TB_FOLDER] AS D
	ON C.ParentFolderID = D.FolderID
	left JOIN eManage.[dbo].[TB_FOLDER] AS E
	ON D.ParentFolderID = E.FolderID
	left JOIN eManage.[dbo].[TB_FOLDER] AS F
	ON E.ParentFolderID = F.FolderID
where  1= 1
	AND A.DELETEDATE > getdate() 
	AND B.FolderName like '%일반직%'
	AND C.FolderName like '%관공서 제출서류%'
ORDER BY CREATEDATE DESC

use eGW
select A.MESSAGEID,F.FolderName, E.FolderName,D.FolderName, C.FolderName, B.FolderName, A.CREATEDATE, A.SUBJECT, A.CREATORDEPTNAME, A.DELETEDATE 
from [dbo].[TB_BOARD] A
	left JOIN eManage.[dbo].[TB_FOLDER] AS B
	ON B.FolderID = A.FolderID
	left JOIN eManage.[dbo].[TB_FOLDER] AS C
	ON B.ParentFolderID = C.FolderID
	left JOIN eManage.[dbo].[TB_FOLDER] AS D
	ON C.ParentFolderID = D.FolderID
	left JOIN eManage.[dbo].[TB_FOLDER] AS E
	ON D.ParentFolderID = E.FolderID
	left JOIN eManage.[dbo].[TB_FOLDER] AS F
	ON E.ParentFolderID = F.FolderID
where  1= 1
	AND A.DELETEDATE > getdate() 
	AND B.FolderName like '%사내장터%'
	--AND C.FolderName like '%기타정보 관련%'
ORDER BY CREATEDATE DESC

use eGW
select A.MESSAGEID,F.FolderName, E.FolderName,D.FolderName, C.FolderName, B.FolderName, A.CREATEDATE, A.SUBJECT, A.CREATORDEPTNAME, A.DELETEDATE 
from [dbo].[TB_BOARD] A
	left JOIN eManage.[dbo].[TB_FOLDER] AS B
	ON B.FolderID = A.FolderID
	left JOIN eManage.[dbo].[TB_FOLDER] AS C
	ON B.ParentFolderID = C.FolderID
	left JOIN eManage.[dbo].[TB_FOLDER] AS D
	ON C.ParentFolderID = D.FolderID
	left JOIN eManage.[dbo].[TB_FOLDER] AS E
	ON D.ParentFolderID = E.FolderID
	left JOIN eManage.[dbo].[TB_FOLDER] AS F
	ON E.ParentFolderID = F.FolderID
where  1= 1
	AND A.DELETEDATE > getdate() 
	AND B.FolderName like '%노무정보 관련%'
	--AND C.FolderName like '%기타정보 관련%'
ORDER BY CREATEDATE DESC


use eGW
select A.MESSAGEID,F.FolderName, E.FolderName,D.FolderName, C.FolderName, B.FolderName, A.CREATEDATE, A.SUBJECT, A.CREATORDEPTNAME, A.DELETEDATE 
from [dbo].[TB_BOARD] A
	left JOIN eManage.[dbo].[TB_FOLDER] AS B
	ON B.FolderID = A.FolderID
	left JOIN eManage.[dbo].[TB_FOLDER] AS C
	ON B.ParentFolderID = C.FolderID
	left JOIN eManage.[dbo].[TB_FOLDER] AS D
	ON C.ParentFolderID = D.FolderID
	left JOIN eManage.[dbo].[TB_FOLDER] AS E
	ON D.ParentFolderID = E.FolderID
	left JOIN eManage.[dbo].[TB_FOLDER] AS F
	ON E.ParentFolderID = F.FolderID
where  1= 1
	AND A.DELETEDATE > getdate() 
	AND B.FolderName like '%회사표준 제개정현황%'
	--AND C.FolderName like '%기타정보 관련%'
ORDER BY CREATEDATE DESC

use eGW
select A.MESSAGEID,F.FolderName, E.FolderName,D.FolderName, C.FolderName, B.FolderName, A.CREATEDATE, A.SUBJECT, A.CREATORDEPTNAME, A.DELETEDATE 
from [dbo].[TB_BOARD] A
	left JOIN eManage.[dbo].[TB_FOLDER] AS B
	ON B.FolderID = A.FolderID
	left JOIN eManage.[dbo].[TB_FOLDER] AS C
	ON B.ParentFolderID = C.FolderID
	left JOIN eManage.[dbo].[TB_FOLDER] AS D
	ON C.ParentFolderID = D.FolderID
	left JOIN eManage.[dbo].[TB_FOLDER] AS E
	ON D.ParentFolderID = E.FolderID
	left JOIN eManage.[dbo].[TB_FOLDER] AS F
	ON E.ParentFolderID = F.FolderID
where  1= 1
	AND A.DELETEDATE > getdate() 
	AND B.FolderName like '%신용협동조합%'
	--AND C.FolderName like '%기타정보 관련%'
ORDER BY CREATEDATE DESC


use eGW
select A.MESSAGEID,F.FolderName, E.FolderName,D.FolderName, C.FolderName, B.FolderName, A.CREATEDATE, A.SUBJECT, A.CREATORDEPTNAME, A.DELETEDATE 
from [dbo].[TB_BOARD] A
	left JOIN eManage.[dbo].[TB_FOLDER] AS B
	ON B.FolderID = A.FolderID
	left JOIN eManage.[dbo].[TB_FOLDER] AS C
	ON B.ParentFolderID = C.FolderID
	left JOIN eManage.[dbo].[TB_FOLDER] AS D
	ON C.ParentFolderID = D.FolderID
	left JOIN eManage.[dbo].[TB_FOLDER] AS E
	ON D.ParentFolderID = E.FolderID
	left JOIN eManage.[dbo].[TB_FOLDER] AS F
	ON E.ParentFolderID = F.FolderID
where  1= 1
	AND A.DELETEDATE > getdate() 
	AND B.FolderName like '%정보보호%'
	--AND C.FolderName like '%기타정보 관련%'
ORDER BY CREATEDATE DESC


use eGW
select A.MESSAGEID,F.FolderName, E.FolderName,D.FolderName, C.FolderName, B.FolderName, A.CREATEDATE, A.SUBJECT, A.CREATORDEPTNAME, A.DELETEDATE 
from [dbo].[TB_BOARD] A
	left JOIN eManage.[dbo].[TB_FOLDER] AS B
	ON B.FolderID = A.FolderID
	left JOIN eManage.[dbo].[TB_FOLDER] AS C
	ON B.ParentFolderID = C.FolderID
	left JOIN eManage.[dbo].[TB_FOLDER] AS D
	ON C.ParentFolderID = D.FolderID
	left JOIN eManage.[dbo].[TB_FOLDER] AS E
	ON D.ParentFolderID = E.FolderID
	left JOIN eManage.[dbo].[TB_FOLDER] AS F
	ON E.ParentFolderID = F.FolderID
where  1= 1
	AND A.DELETEDATE > getdate() 
	AND B.FolderName like '%영업 게시판%'
	--AND C.FolderName like '%기타정보 관련%'
ORDER BY CREATEDATE DESC

use eGW
select A.MESSAGEID,F.FolderName, E.FolderName,D.FolderName, C.FolderName, B.FolderName, A.CREATEDATE, A.SUBJECT, A.CREATORDEPTNAME, A.DELETEDATE 
from [dbo].[TB_BOARD] A
	left JOIN eManage.[dbo].[TB_FOLDER] AS B
	ON B.FolderID = A.FolderID
	left JOIN eManage.[dbo].[TB_FOLDER] AS C
	ON B.ParentFolderID = C.FolderID
	left JOIN eManage.[dbo].[TB_FOLDER] AS D
	ON C.ParentFolderID = D.FolderID
	left JOIN eManage.[dbo].[TB_FOLDER] AS E
	ON D.ParentFolderID = E.FolderID
	left JOIN eManage.[dbo].[TB_FOLDER] AS F
	ON E.ParentFolderID = F.FolderID
where  1= 1
	AND A.DELETEDATE > getdate() 
	AND B.FolderName like '%건의사항%'
	--AND C.FolderName like '%기타정보 관련%'
ORDER BY CREATEDATE DESC



--공지사항 조회
select MESSAGEID, CREATEDATE, SUBJECT, CREATORDEPTNAME from [dbo].[TB_NOTICE] where DeleteDate > getdate() 
order by createdate desc




use eGW
select A.MESSAGEID,F.FolderName, E.FolderName,D.FolderName, C.FolderName, B.FolderName, A.CREATEDATE, A.SUBJECT, A.CREATORDEPTNAME, A.DELETEDATE 
from [dbo].[TB_BOARD] A
	left JOIN eManage.[dbo].[TB_FOLDER] AS B
	ON B.FolderID = A.FolderID
	left JOIN eManage.[dbo].[TB_FOLDER] AS C
	ON B.ParentFolderID = C.FolderID
	left JOIN eManage.[dbo].[TB_FOLDER] AS D
	ON C.ParentFolderID = D.FolderID
	left JOIN eManage.[dbo].[TB_FOLDER] AS E
	ON D.ParentFolderID = E.FolderID
	left JOIN eManage.[dbo].[TB_FOLDER] AS F
	ON E.ParentFolderID = F.FolderID
where  1= 1
	AND A.DELETEDATE > getdate() 
	AND B.FolderName like '%표준계약서%'
	--AND C.FolderName like '%기타정보 관련%'
ORDER BY CREATEDATE DESC
