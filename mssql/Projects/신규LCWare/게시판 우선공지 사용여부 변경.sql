use Portal
select * from [BD].[BoardBase]



-- �Խ��� �̸�
use portal
select B.BoardID, A.Korean from BD.BoardText A
inner Join BD.BoardINfo B
on A.TextID=B.BoardID
where Boardrootid='SITE02'


select * from [BD].[BoardInfo] WHere BoardRootID = 'SITE02' AND BoardID = '88'



--�Խ��� �켱���� ��� ���� Y/N
begin tran
update Portal.BD.BoardInfo
set IsNotice = 'Y'
WHERE BoardRootID = 'SITE02' AND BoardID = '88'
--commit


--��ü �Խ��� �켱���� ��� ���� Y/N
-- 49�� �Խ��� 
begin tran
update Portal.BD.BoardInfo
set IsNotice = 'N'
WHERE BoardRootID = 'SITE02'
commit