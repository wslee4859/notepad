use Portal
select B.BoardID, A.Korean from BD.BoardText A
inner Join BD.BoardINfo B
on A.TextID=B.BoardID
where Boardrootid='SITE04'  -- ����Ʈ�ڵ�






-- ����ǰ ���� ������
begin tran
insert into [PT].[ProductMng] values ('5','SITE05',null)
commit



-- ����Ʈ�� ����ǰ���� �Խ��� ����Ʈ �������� 
insert into [PT].[ProductPermission] (SITEIDX, PERMISSION_SITEIDX) values ('6','6')
commit