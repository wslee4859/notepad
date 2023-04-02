
/*********************************
-- 결재중인 결재문서 결재선 변경 
-- 1. [WF].[PROCESS_SIGNER] 수정    -- 결재선안의 결재정보이고
-- 2. [WF].[WORK_ITEM] 수정			-- 여기가 수정되어야 결재함이랑 이런곳으로 보내지고 함.
**********************************/

--변경 할 결재문서 조회 
select * from EWF.[WF].[PROCESS_SIGNER] where process_instance_oid = 'P262376016EFF4E34B67D5942CDCC80F5'
select * from EWF.[WF].[WORK_ITEM] where process_instance_oid = 'P262376016EFF4E34B67D5942CDCC80F5'

select User_code, user_name, classpos_name, responsibility_name, group_code, group_name from COMMON.[IM].[VIEW_USER] where user_name like '김광석'
97483

--조확주 : 26608
-- 김광석 : 26394

begin tran 
update EWF.[WF].[PROCESS_SIGNER]
--set user_id ='44371', user_name = '조정아', POS_NAME = 'A(여)', DUTY_NAME = '사원', DEPT_ID = '5616', DEPT_NAME = '전산기술파트'
-- 상무님 작업
set user_id = '26608'
where SIGN_OID = 'S21FF3258A2384678858DF678A57BFA70'


--commit 
--rollback
update EWF.[WF].[WORK_ITEM]
-- set NAME = '재기안: 25827', PARTICIPANT_NAME = '25827', PARTICIPANT_ID='25827'
-- 상무님 작업
set Participant_id = '26608'
where OID = 'W09B62E8E7A454B3C82564C6CC0C4E2A9'


commit
rollback
select @@trancount



-- 김광석 부문장님
select PROCESS_INSTANCE_OID from EWF.[WF].[PROCESS_SIGNER] where user_id = '97486'
select * from EWF.[WF].[PROCESS_SIGNER] where user_id = '97483'
select * from EWF.[WF].[WORK_ITEM] where Participant_id = '97483'
select * from EWF.[WF].[PROCESS_SIGNER] where USER_NAME = '김찬수'
PE747E2A036FC477CAC4CA8C7FBE557DF



EWF.[WF].[WORK_ITEM] where oid = 'W4B1807EFA5E042A28CC713E2A12651D5'





[WF].[PROCESS_INSTANCE] where OID in (select PROCESS_INSTANCE_OID from EWF.[WF].[PROCESS_SIGNER] where user_id = '97483')



/*************************************************
-- 전자결재 결재정보에서 결재자 정보 삭제
-- 1. [WF].[PROCESS_SIGNER] 수정    -- 결재선안의 결재정보이고
-- 2. [WF].[WORK_ITEM] 수정			-- 여기가 수정되어야 결재함이랑 이런곳으로 보내지고 함.

작업절자
-- 결재 꼬여있을 경우
1. [WF].[WORK_ITEM]에서 결재프로세스 수정


-- 
A. PROCESS_SIGNER 에서 (결재완료된) SIGN 삭제 (SIGN_OID 로
   ! 결재 안된건일 경우 ACTION_TYPE이랑 SIGN_STATE 변경
B. 나머지 SIGN_SEQ 조정
****************************************************/

USE EWF
select * from [WF].[PROCESS_SIGNER] WHERE PROCESS_INSTANCE_OID = 'PBF9182058ED0483D92BE15DA25A3270C' order by SIGN_SEQ

-- 1. [WF].[WORK_ITEM]에서 결재프로세스 수정

select * from [WF].[WORK_ITEM] WHERE PROCESS_INSTANCE_OID = 'PBF9182058ED0483D92BE15DA25A3270C'

-- A. PROCESS_SIGNER 에서 (결재완료된) SIGN 삭제 (SDD104F3A543040969BD5D2773740AF14)
select * from [WF].[PROCESS_SIGNER] WHERE PROCESS_INSTANCE_OID = 'PE278EE94955C44BC833EACFC2A1F9382' order by SIGN_SEQ


begin tran 
delete [WF].[PROCESS_SIGNER]
where SIGN_OID = 'S94895D89E1744375BC86C73A3FB8EC47'
-- commit

begin tran 
update [WF].[PROCESS_SIGNER]
set CREATE_DATE = '2018-04-30 10:13:14.260'
where sign_oid = 'S1E337EC1FC87436AA76B714B9C95B57F'


begin tran 
update [WF].[PROCESS_SIGNER]
set sign_seq = '2'
where sign_oid = 'S1E337EC1FC87436AA76B714B9C95B57F'

update [WF].[PROCESS_SIGNER]
set sign_seq = '3'
where sign_oid = 'SF2E6A0A004804F4FB8882685CA26665D'

update [WF].[PROCESS_SIGNER]
set sign_seq = '4'
where sign_oid = 'SBE075185108F41D0B55B26246C489AD4'
-- commit

begin tran 
update [WF].[PROCESS_SIGNER]
set ACTION_TYPE = '01'
where sign_oid = 'S1E337EC1FC87436AA76B714B9C95B57F'
-- commit


2017-08-30 06:41:26.677


begin tran 
update [WF].[PROCESS_SIGNER]
set CREATE_DATE = '2017-08-30 06:41:26.677'
where sign_oid = 'S492858C549EE4F3E9AEE8CA3E3792B64'
-- commit
