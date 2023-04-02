/***************************************************
* 그룹웨어 첫 개인타이틀(개인포틀릿) 이름 변경 건
****************************************************/


[CM].[Member] where id = '36391'
[IM].[VIEW_USER] where user_name = '정이연'

begin tran 
update [CM].[Member]
set name = '정이연'
where id = '36391'

commit