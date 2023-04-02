/*
CH음료	IM_00001
임원실(CH)	IM_00002
안성공장(CH)	IM_00003
청원공장(CH)	IM_00004
양주공장(CH)	IM_00005
안성생산지원담당(CH)	IM_00006
안성생산담당(CH)	IM_00007
안성배합담당(CH)	IM_00008
안성품질보증담당(CH)	IM_00009
안성환경기술담당(CH)	IM_00010
청원관리지원담당(CH)	IM_00011
청원생산담당(CH)	IM_00012
청원품질환경담당(CH)	IM_00013
양주관리지원담당(CH)	IM_00014
양주생산담당(CH)	IM_00015
양주품질환경담당(CH)	IM_00016
*/




select * from [dbo].[lotte_sync_bulk_user] where name = '노상호'

begin tran
update [dbo].[lotte_sync_bulk_user]
set group_code = 'IM_00013'
where name = '정동배'


commit



select * from [dbo].[lotte_sync_bulk_user] where name = '김정훈'

begin tran
update [dbo].[lotte_sync_bulk_user]
set end_dt = '2015-10-14 00:00:00.000'
where name = '김정훈' 

commit


[dbo].[org_group]






