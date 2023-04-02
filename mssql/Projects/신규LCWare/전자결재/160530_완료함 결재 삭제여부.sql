
/*완료결재 여부 확인(삭제 여부, 또는 결재가 완료 후 누구함에 있는지 */
-- 내역 : CH청원품질환경담당에서 완료 후에도 완료함에 결재가 보이지 않는 경우. P018AD5638296401AAA9AF7917FFF3671
--			 보안문서로 기안하여 보안문서함에 있음.

select * from WF.WORK_ITEM_CMPL where PROCESS_INSTANCE_OID = 'P018AD5638296401AAA9AF7917FFF3671'