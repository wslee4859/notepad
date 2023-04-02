

--신규 LCWare FAX 사용자 조회 2015-10-23일 
--수정자 이완상 
-- User_code 가 없는 경우는 IM80 DB에서 User_id 로 조회 (퇴직자)

SELECT DISTINCT User_code, group_name, parent_group_name, User_name
--a.userid, c.deptname, b.username
from common.[IM].[VIEW_USER]
where 1=1 
and user_code in (
'22259',
'23137',
'246248',
'254133',
'25759',
'26388',
'26426',
'26715',
'27966',
'30758',
'73541',
'sherp'
)
order by user_code

  
 
  22259
  23137
  246248
  254133
  25759
  26388
  26426
  26715
  27966
  30758
  73541
  sherp



  
  
  
  
  
  
  
  
  
  
  

  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  

  
  
  
  
  



  
  
  
  
  
  
  
  
  
  
  
  
  









 select top 100 * from common.[IM].[VIEW_USER] where user_name = '장오복'
 select top 100 * from common.[IM].[VIEW_USER] where user_code = '136745'
 select top 100 * from [10.103.1.108].[im80].[dbo].[org_user] where user_id = '136745'

 select top 100 * from [10.120.1.23].emanage.dbo.tb_user where userid = '136745'


 136745
 22774
 25061
 25759
 27012
 42237 
 52444 
 52457
 52473 
 72433 

