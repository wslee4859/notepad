
-- �Խ��� (���Խ���)
select F.FolderName, E.FolderName,D.FolderName, C.FolderName, B.FolderName, A.CREATEDATE, A.SUBJECT, A.CREATORDEPTNAME from [dbo].[TB_BOARD] A
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
where A.DELETEDATE > getdate()


use eGW
select F.FolderName, E.FolderName,D.FolderName, C.FolderName, B.FolderName, A.CREATEDATE, A.SUBJECT, A.CREATORDEPTNAME, A.DELETEDATE from [dbo].[TB_BOARD] A
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
	AND B.FolderName like '%���''''������%' 
ORDER BY CREATEDATE DESC







--�������� ��ȸ
select CREATEDATE, SUBJECT, CREATORDEPTNAME from [dbo].[TB_NOTICE] where DeleteDate > getdate() 
order by createdate desc
