select * from [dbo].[lotte_sync_bulk_user] where name = 'Ȳ����'

begin tran
update [dbo].[lotte_sync_bulk_user]
set group_code = 'IM_00012'
where code = '20132011C'

update [dbo].[lotte_sync_bulk_user]
set group_code = 'IM_00013'
where code = '20142005C'

--commit

select * from [dbo].[org_group] where code = 'IM_00013'
select * from [dbo].[org_group] where sec_level = '2'
�ӿ���(CH)	IM_00002
�ȼ�����(CH)	IM_00003
û������(CH)	IM_00004
���ְ���(CH)	IM_00005
�ȼ������������(CH)	IM_00006
�ȼ�������(CH)	IM_00007
�ȼ����մ��(CH)	IM_00008
�ȼ�ǰ���������(CH)	IM_00009
�ȼ�ȯ�������(CH)	IM_00010
û�������������(CH)	IM_00011
û��������(CH)	IM_00012
û��ǰ��ȯ����(CH)	IM_00013
���ְ����������(CH)	IM_00014
���ֻ�����(CH)	IM_00015
����ǰ��ȯ����(CH)	IM_00016