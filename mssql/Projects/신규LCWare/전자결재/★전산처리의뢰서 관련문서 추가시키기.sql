
/*******************************************
전산처리완료보고서  관련결재로 전산처리의뢰서 넣을 경우 
oid = 전산처리완료보고서의  oid

id, formid, subject 는 전산처리의뢰서의 정보 

이력 : 
2018-04-11 황찬우 사원
2018-04-13 김성환 책임	P3F29496E30A440E8AAA82079C1D3DCD9

********************************************/
--insert into [WF].[WF_FORM_REFDOC]
--values('전산처리완료보고서OID(넣을결재)','전산처리의뢰서(개발/변경)넣어야할결재','','넣어야햘결재 FORMID','넣어야할결재 제목','','','','')



-- 1.관련문서를 넣어야할 전자 결재
oid  =  PB836C0E7B9234830851CDFF70F2D4884    전산처리완료보고서의 Process_id


-- 2.넣을 관련 문서
id =  PA9433AF1953049CC964844FB64271D47       전산처리의뢰서(개발/변경)의 PID
formid = Y86483E4798C143E2B61A5CC627CF6177   전산처리의뢰서(개발/변경) FORMID 
subject = '예산실적 조회시 과세구분 추가'   전산처리의뢰서의 제목

--음료 전산처리의뢰서 : YE6A8907A455743E58C86D37EC4A658C1
--주류 전산처리의뢰서 : Y86483E4798C143E2B61A5CC627CF6177




-- 3. 음료
--insert into [WF].[WF_FORM_REFDOC]
--values('전산처리완료보고서OID(넣을결재)','전산처리의뢰서(개발/변경)넣어야할결재','','넣어야햘결재 FORMID','넣어야할결재 제목','','','','')
begin tran
insert into [WF].[WF_FORM_REFDOC]
values('PFEE860345F6F4236B639D541230BC9AA','PFA2B46B817F1463DA75483608B0A549A','','YE6A8907A455743E58C86D37EC4A658C1','경남지역내 천일택배(고성)센터 운영','','','','')



-- 3. 주류 
--insert into [WF].[WF_FORM_REFDOC]
--values('전산처리완료보고서OID(넣을결재)','전산처리의뢰서(개발/변경)넣어야할결재','','넣어야햘결재 FORMID','넣어야할결재 제목','','','','')
begin tran
insert into [WF].[WF_FORM_REFDOC]
values('P4C49DF73867442CC84A3F6F140E709D3','PB661B4CAECD940C9955ECA4938F951E5','','Y86483E4798C143E2B61A5CC627CF6177','허브 출산선물 신청 항목 활성화','','','','')


select * from [WF].[WF_FORM_REFDOC] WHERE SUBJECT = 'OT자료 변경승인 화면 오류 수정요청'

begin tran
update [WF].[WF_FORM_REFDOC]
SET PROCESS_INSTANCE_OID = 'PE6816703188A4D63A2FAF2E228EA6340', PROCESS_ID = 'P9B50ED9D76164EC3A8FEC2CE984939C8'
 WHERE SUBJECT = 'OT자료 변경승인 화면 오류 수정요청'


--commit
--rollback
select @@TRANCOUNT
--4 . 관련문서 교체
-- select * from [WF].[WF_FORM_REFDOC] WHERE PROCESS_INSTANCE_OID = 'PFF56DAE5C2E74828AFD28A1F221A08C8'
begin tran
update [WF].[WF_FORM_REFDOC]
set PROCESS_ID = 'P27EB518FFE8444B987434D926B669E73', FORM_ID = 'YE6A8907A455743E58C86D37EC4A658C1', SUBJECT = '외주 재고현황(zscr0052) 조회 조건 추가', DOC_NUMBER = '생수지원담당 제2017-2호'
WHERE PROCESS_INSTANCE_OID = 'PFF56DAE5C2E74828AFD28A1F221A08C8'







