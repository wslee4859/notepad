/*
CH����	IM_00001
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
*/




select * from [dbo].[lotte_sync_bulk_user] where name = '���ȣ'

begin tran
update [dbo].[lotte_sync_bulk_user]
set group_code = 'IM_00013'
where name = '������'


commit



select * from [dbo].[lotte_sync_bulk_user] where name = '������'

begin tran
update [dbo].[lotte_sync_bulk_user]
set end_dt = '2015-10-14 00:00:00.000'
where name = '������' 

commit


[dbo].[org_group]






