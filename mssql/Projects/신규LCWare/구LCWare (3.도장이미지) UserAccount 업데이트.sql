/***************************
 개인 사용자 용 *************
 ****************************/
 -- 구 전자결재 사용하기 위해서는 신규 포탈 계정, 메일주소, 메일사서함(임의) 로 값을 업데이트 해줘야 함. 
 -- 도장이미지는 erp 사용자만도 등록가능하므로 사번으로 로그인 하는 사람은 아래 정보 업데이트 안해도됨 
 select * from  eManage.[dbo].[TB_USER] where UserCD = '20146174'

use eManage
begin tran
update [dbo].[TB_USER] 
set UserAccount = 'sgwb' ,
	MailAddress = 'sgwb@lottechilsung.co.kr' ,
	MailServer = 'ekw2bmail1'
where UserCD = '20150869'

--commit
rollback


 select * from  eManage.[dbo].[TB_USER] where UserCD in ( '20146174', '20150807')
  select * from  eManage.[dbo].[TB_USER] where UserName = '이완상'
