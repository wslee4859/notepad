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
	AND B.FolderName like '%������%' 
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
	AND B.FolderName like '%�Ϲ���%' 
	AND C.FolderName like '%�λ�߷�%'
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
	AND B.FolderName like '%���� �Խ���%'
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
	AND B.FolderName like '%��������%'
	AND C.FolderName like '%�λ����� ����%'
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
	AND B.FolderName like '%�����ڰ� ����%'
	AND C.FolderName like '%�λ����� ����%'
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
	AND B.FolderName like '%D/W �ý��� ����%'
	AND C.FolderName like '%�������� ����%'
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
	AND B.FolderName like '%���꺯�����(����)%'
	AND C.FolderName like '%�������� ����%'
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
	AND B.FolderName like '%ISO ����%'
	--AND C.FolderName like '%�������� ����%'
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
	AND B.FolderName like '%��������%'
	AND C.FolderName like '%��ǰ/�系�� ���� ����%'
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
	AND B.FolderName like '%�系�ּ�/��ȭ��ȣ%'
	AND C.FolderName like '%�������� ����%'
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
	AND B.FolderName like '%��Ÿ����%'
	AND C.FolderName like '%�������� ����%'
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
	AND B.FolderName like '%��Ÿ���� ����%'
	--AND C.FolderName like '%�������� ����%'
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
	AND B.FolderName like '%�Ϲ���%'
	AND C.FolderName like '%������ ���⼭��%'
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
	AND B.FolderName like '%�系����%'
	--AND C.FolderName like '%��Ÿ���� ����%'
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
	AND B.FolderName like '%�빫���� ����%'
	--AND C.FolderName like '%��Ÿ���� ����%'
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
	AND B.FolderName like '%ȸ��ǥ�� ��������Ȳ%'
	--AND C.FolderName like '%��Ÿ���� ����%'
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
	AND B.FolderName like '%�ſ���������%'
	--AND C.FolderName like '%��Ÿ���� ����%'
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
	AND B.FolderName like '%������ȣ%'
	--AND C.FolderName like '%��Ÿ���� ����%'
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
	AND B.FolderName like '%���� �Խ���%'
	--AND C.FolderName like '%��Ÿ���� ����%'
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
	AND B.FolderName like '%���ǻ���%'
	--AND C.FolderName like '%��Ÿ���� ����%'
ORDER BY CREATEDATE DESC



--�������� ��ȸ
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
	AND B.FolderName like '%ǥ�ذ�༭%'
	--AND C.FolderName like '%��Ÿ���� ����%'
ORDER BY CREATEDATE DESC
