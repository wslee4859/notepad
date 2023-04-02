
/****************************
* SMS 보낸 상세내역
*****************************/
select 
-- grp.name,
tran_date,
gr.name ,
replace(replace(tran_msg,char(13),''),char(10),''),
U.name
--U.code,
--U.login_id
--count(*) 
--SUM(count(*)) OVER() AS [SUM]
from SMS.[dbo].[em_log_201804] AS A
	LEFT JOIN [10.103.1.108].im80.[dbo].[org_user] AS U
    ON A.tran_etc1 = U.code AND domain_id = '11'
	LEFT join [10.103.1.108].im80.dbo.org_Group as gr
	on U.group_id = gr.group_id 
	LEFT join [10.103.1.108].im80.dbo.org_Group as grp
	on gr.parent_id = grp.group_id
 WHERE 1=1 
		AND A.tran_status = '3'   -- 롯데정보통신 -> 고객까지 성공
		AND tran_rslt = '0'		  -- 메시지 성공
		--AND convert(char(8), A.tran_reportdate, 112) like '201510%'		
		--AND tran_callback != '0234799230'     -- 11월전까지 이진호 팀장님번호로 인증번호 가는게 tran_etc 에 보내는 사람이 아닌 받는 사람 사번이 찍힘. 그러므로 따로 계산
											  -- 11월 부터는 인증번호는  SYSTEM쪽으로 넘어감. 
		--AND tran_type = '4'   -- 4 : SMS   6: LMS	
		--AND gr.name like '%오포생산지원담당%'	
 --group by grp.name, gr.name
 order by tran_date, gr.name


 select 
-- grp.name,
tran_date,
gr.name ,
replace(replace(tran_msg,char(13),''),char(10),''),
U.name
--U.code,
--U.login_id
--count(*) 
--SUM(count(*)) OVER() AS [SUM]
from SMS_SYSTEM.[dbo].[em_log_201804] AS A
	LEFT JOIN [10.103.1.108].im80.[dbo].[org_user] AS U
    ON A.tran_etc1 = U.code AND domain_id = '11'
	LEFT join [10.103.1.108].im80.dbo.org_Group as gr
	on U.group_id = gr.group_id 
	LEFT join [10.103.1.108].im80.dbo.org_Group as grp
	on gr.parent_id = grp.group_id
 WHERE 1=1 
		AND A.tran_status = '3'   -- 롯데정보통신 -> 고객까지 성공
		AND tran_rslt = '0'		  -- 메시지 성공
		--AND convert(char(8), A.tran_reportdate, 112) like '201510%'		
		--AND tran_callback != '0234799230'     -- 11월전까지 이진호 팀장님번호로 인증번호 가는게 tran_etc 에 보내는 사람이 아닌 받는 사람 사번이 찍힘. 그러므로 따로 계산
											  -- 11월 부터는 인증번호는  SYSTEM쪽으로 넘어감. 
		--AND tran_type = '4'   -- 4 : SMS   6: LMS	
		--AND gr.name like '%오포생산지원담당%'	
 --group by grp.name, gr.name
 order by tran_date, gr.name