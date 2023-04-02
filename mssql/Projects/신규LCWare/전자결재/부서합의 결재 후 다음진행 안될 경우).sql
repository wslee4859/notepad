USE EWF


/********************************************************************
전자결재 결재선 설정
(부서합의 완료후 다음 결재자로 진행 안될 경우) 
Action_TYPE 00 : 기결재 01 : 현결재 
SIGN_STATE 00 : 기안 01 : 대기 02 : 결재 03 반려 
참고 산출물 결재선설계서
**********************************************************************/

--완료 날짜 검색(해당시간은 DB랑 실제랑 안맞음 알아서 들어감) COMPLETED_DATE
-- 관리자페이지에서 해당 결재 OID 확인 후 
select * from EWF.WF.WORK_ITEM WHERE process_instance_oid = 'P071FE6E8BD0F4F38B7CEBE646DFB9006' 
order by CREATE_DATE 
부서합의 완료결재일  : 2016-02-22 08:14:00.643

다음결재자 결재생성일 : 2016-08-21 23:45:08.107
중요!!!! 부서합의 완료일!!!!! 부서합의 이후의 결재건자가 있어야 정상처리된 건임. 
--결재되었는데 안되었는지 확인하기 위해  : 관리자 페이지에서 해당 결재 OID 입력하면 결재라인나옴. 
-- 관리자 페이지의 subProcess에서 OID 확인하여 아래 조회 
--1. 해당 결재(관리자 페이지)의 OID. 위의 OID와 동일
select * from EWF.WF.PROCESS_SIGNER where PROCESS_INSTANCE_OID = 'P92CDFD691E9F42C79C63D30C9C037052'
order by SIGN_SEQ 
-- 2016-08-21 23:45:04.887
select * from EWF.WF.PROCESS_SIGNER where PROCESS_INSTANCE_OID = 'PC86290E7D9F34B3F99C0A7365F4FB584'
order by SIGN_SEQ 
-- 2016-06-19 23:49:26.170
-- 2016-06-19 23:49:28.993

S67CD8F32B7924DA6BC521CB346767D29	3	PFCAD03C73DBC4FE78B7996DDC2E0377B					5532	화재안전관리담당	10	11	01	01	2016-01-22 09:12:30.613	NULL						 				07	NULL
S7594D1009A904981869ED4FE3A7A28C8	4	PFCAD03C73DBC4FE78B7996DDC2E0377B	67391	김대일	S2	팀장	5458	비상계획팀	01	01	01	02	NULL	NULL						 		jose1012@lottechilsung.co.kr		01	NULL


--2.
select * from EWF.WF.PROCESS_SIGNER where PROCESS_INSTANCE_OID = 'P071FE6E8BD0F4F38B7CEBE646DFB9006'



-- subprocess 결재 라인 시각 확인
select * from EWF.WF.PROCESS_INSTANCE WHERE parent_oid = 'P0948D762F2B147A49DC09B8AF787E1C9'
기술1담당 2016-07-07 08:02:50.717
제조안전담당 2016-07-08 08:00:57.663


select @@trancount

rollback
--1. 번의 OID로 조회하여 SIGN_OID 검색 
-- 결재 완료completed_date
begin tran
update EWF.WF.PROCESS_SIGNER 
set completed_date = '2016-07-07 08:02:50.717'
,     sign_state = '12'
,     action_type = '00'
where sign_oid = 'S7C7F6AFD9C4B4136B6D28A666AAD5425'

-- 2건의 부서합의 시 
update EWF.WF.PROCESS_SIGNER 
set completed_date = '2016-06-19 23:49:28.993'
,     sign_state = '12'
,     action_type = '00'
where sign_oid = 'S2BDAF20CA306433EA2DC56D62ECAC47F'

-- 결재 시작create_date
update EWF.WF.PROCESS_SIGNER 
set create_date = '2016-02-22 08:14:00.643'
,     sign_state = '01'
,     action_type = '01'
where sign_oid = 'S4F181E1801B547E4AB2E245264EE8764'

rollback
commit


/********************************
부서합의 건 롤백
*********************************/
begin tran
update EWF.WF.PROCESS_SIGNER 
set completed_date = NULL
,     sign_state = '01'
,     action_type = '01'
where sign_oid = 'S695CDFD5987947B9BFDC566D6F75159F'

-- 결재 시작create_date
update EWF.WF.PROCESS_SIGNER 
set create_date = NULL
,     sign_state = '01'
,     action_type = '02'
where sign_oid = 'S36724FA6F4244CFDBADE62B93223C671'

commit