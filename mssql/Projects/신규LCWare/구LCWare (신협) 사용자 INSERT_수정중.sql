-- 신협 신입사원 추가 하기 

-- 1. 프로세스 인사에 등록 안되고, IM에 바로 수기로  계정생성하므로 인사 쪽 프로세스는 무시
-- 2. IM 에서부터 시작하며, ERP_EKW_DTS 프로세스로 시작 
-- 3. IM_USER에 INSERT
-- 4. IM_DEPT_USER에 INSERT
-- 5. 음료 IM-EKW 총괄 실행
-- 6. 전자결재 및 사용자 정보 입력 위해 메일사서함, 메일 계정 UPDATE 
use ERP_EKW_DTS
select * from [dbo].[IM_USER] where userName = '도수자'


select * from [dbo].[IM_USER] where userName = '이재원'
select * from [dbo].[IM_DEPT] where deptName like '%신협%'     -- 01461   
select * from [dbo].[IM_CODE_SUB]
select * from [dbo].[IM_DEPT_USER] where empID = '8267'
select * from [dbo].[IM_USER] where empID in ('19026','8267')


--이전에 등록한 사용자 조회하여 해당 사용자와 다른 정보는 같에 입력하고 사번이랑 부서만 다르게 입력한다. 
use ERP_EKW_DTS
begin tran
insert into [dbo].[IM_USER]
select 
'8273',   --사번
'이재원',   --UserName
PersonID,
Phone,
Address,
HandPhone,
BirthDay,
LunarYN,
Jo,
SEX,
PS,
EntDate,
EnableYN,
'bbodagu111@lottechilsung.co.kr',
'bbodagu111'
FROM [dbo].[IM_USER]
WHERE EmpID = '8270'

--이전에 등록한 사용자 조회하여 해당 사용자와 다른 정보는 같에 입력하고 사번이랑 부서만 다르게 입력한다. 
use ERP_EKW_DTS
begin tran
insert into dbo.IM_DEPT_USER 
select 
'8273',   --사번
'01430',   --부서
JikGeupID,
JikMuID,
JikChaekID,
PositionOrder,
FrDate,
DisplayYN
FROM dbo.IM_DEPT_USER 
WHERE EmpID = '8273'


commit
rollback

-- 음료 작업 IM-EKW 총괄 실행 

-- 8267    
-- 8268    
-- 8269    
select * from eManage.[dbo].[TB_USER] WHERE EmpID = '8273'

-- 로그인 아이디 입력 -- 구 전자결재 사용하기 위해서는 신규 포탈 계정, 메일주소, 메일사서함(임의) 로 값을 업데이트 해줘야 함. 
begin tran 
update eManage.[dbo].[TB_USER]
set UserAccount = 'bbodagu111',
	MailAddress = 'bbodagu111@lottechilsung.co.kr',
	MailServer = 'ekw2bMail2'
where EmpID = '8273'

commit
select @@trancount
--rollback










