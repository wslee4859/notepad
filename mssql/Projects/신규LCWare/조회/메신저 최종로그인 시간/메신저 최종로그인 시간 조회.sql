
/************************************************************
**** Lync 사용자 리스트(최종로그인 시간 뽑기) **************
* 10.120.6.94   sa // lcsekwadmin1!
* 조회시 필드 대소문자 구분!!
*************************************************************/


-- User  에 대한 최종로그인 시간 조회
use LcsCDR
select * from [dbo].[Users] AS U
left join [dbo].[UserStatistics] AS US
on U.UserId = US.UserId



-- select * from [dbo].[Users] where UserUri like '%wslee%'
--[dbo].[UserStatistics] where UserId = '23'





