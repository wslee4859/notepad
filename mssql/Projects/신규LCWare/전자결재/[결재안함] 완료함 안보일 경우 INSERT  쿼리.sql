USE [EWF]

-- 결재안함 시 완료함에 안보이는 거 INSERT 시키는 쿼리
begin tran
INSERT INTO WF.WORK_ITEM_CMPL (
OID
, PROCESS_INSTANCE_OID
, PARTICIPANT_NAME
, PARTICIPANT_ID
, DEPT_ID
, DEPT_NAME
, CREATE_DATE
, COMPLETED_DATE
, OPEN_YN
, SIGNED_USERID
, DEPUTY_USERNAME
, LOCATION)
select 
'W' + replace(newid(), '-', '') OID
, 'P1E65D99EB3F94966814393B7A631B4C2' PROCESS_INSTANCE_OID
, A.USER_NAME PARTICIPANT_NAME
, A.USER_ID + '_' + A.DOC_TYPE PARTICIPANT_ID
, A.DEPT_ID DEPT_ID
, DEPT_NAME DEPT_NAME
, getutcdate() CREATE_DATE
, getutcdate() COMPLETED_DATE
, 'N' OPEN_YN
, '' SIGNED_USERID
, '' DEPUTY_USERNAME
, A.LOCATION
From (
select distinct   
USER_ID  
, USER_NAME 
, DEPT_ID
, DEPT_NAME
, 'CO' AS DOC_TYPE
, CASE WHEN SIGN_STATE = '98' THEN 'RECALL' ELSE
		 CASE SIGN_CATEGORY
			 WHEN '10' THEN 'AGREE'
			 WHEN '11' THEN 'AGREE'
			 WHEN '02' THEN 'RCV'
			 WHEN '03' THEN 'RCV'
			 WHEN '04' THEN 'RCV'
			 WHEN '05' THEN 'RCV'
			 ELSE 'DRAFT'
			 END 
   END LOCATION
From WF.PROCESS_SIGNER(NOLOCK)  
where PROCESS_INSTANCE_OID = 'P1E65D99EB3F94966814393B7A631B4C2' and ACTION_TYPE in ('00','03','01') and USER_ID = '25032'
) as A

commit
;
select * from Wf.WORK_ITEM_CMPL where process_instance_oid='P16781F2061834107BE68056B773CE61E'



SELECT @@ROWCOUNT;



