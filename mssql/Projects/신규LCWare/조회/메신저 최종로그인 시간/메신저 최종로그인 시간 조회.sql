
/************************************************************
**** Lync ����� ����Ʈ(�����α��� �ð� �̱�) **************
* 10.120.6.94   sa // lcsekwadmin1!
* ��ȸ�� �ʵ� ��ҹ��� ����!!
*************************************************************/


-- User  �� ���� �����α��� �ð� ��ȸ
use LcsCDR
select * from [dbo].[Users] AS U
left join [dbo].[UserStatistics] AS US
on U.UserId = US.UserId



-- select * from [dbo].[Users] where UserUri like '%wslee%'
--[dbo].[UserStatistics] where UserId = '23'





