/****************************
LCWare 상 SMS 보낸 건 
*****************************/
/****************************
내역서 내역 : 
 - 2016년 3월 진행완료
 - 2016년 4월 진행완료
 - 2016년 5월 진행완료
 - 2016년 6월 진행완료
 - 2016년 7월 진행완료
 - 2016년 8월 진행완료
 - 2016년 9월 진행완료 
 - 2016년 10월 진행완료
 - 2016년 11월 진행완료
 - 2016년 12월 진행완료
 - 2017년 1월 진행완료
 - 2017년 2월 진행완료
 - 2017년 3월 진행완료
 - 2017년 4월 진행완료
 - 2017년 5월 진행완료
 - 2017년 6월 진행완료
 - 2017년 7월 진행완료
 - 2017년 8월 진행완료
 - 2017년 9월 진행완료
  - 2017년 11월 진행완료
  - 2017년 12월 진행완료
  - 2018년 1월 진행완료
  - 2018년 2월 진행완료
  - 2018년 3월 진행완료
  
*****************************/

select 
grp.name,
gr.name ,
count(*) 
--SUM(count(*)) OVER() AS [SUM]
from SMS.[dbo].[em_log_201811] AS A
	LEFT JOIN [10.103.1.108].im80.[dbo].[org_user] AS U
    ON A.tran_etc1 = U.code AND domain_id = '11'
	LEFT join [10.103.1.108].im80.dbo.org_Group as gr
	on U.group_id = gr.group_id 
	LEFT join [10.103.1.108].im80.dbo.org_Group as grp
	on gr.parent_id = grp.group_id
 WHERE 1=1 
		AND A.tran_status = '3'   -- 롯데정보통신 -> 고객까지 성공
		AND tran_rslt = '0'			-- 메시지 성공
		--AND convert(char(8), A.tran_reportdate, 112) like '201510%'		
		-- AND tran_callback = '0234799230'     -- 11월전까지 이진호 팀장님번호로 인증번호 가는게 tran_etc 에 보내는 사람이 아닌 받는 사람 사번이 찍힘. 그러므로 따로 계산
											  -- 11월 부터는 인증번호는  SYSTEM쪽으로 넘어감. 
		AND tran_type = '4'   -- 4 : SMS   6: LMS		
 group by grp.name, gr.name
 order by grp.name



/****************************
시스템 SMS 보낸 건 
*****************************/
select 
grp.name,
gr.name,
count(*)
--SUM(count(*)) OVER() AS [SUM]
from SMS_SYSTEM.[dbo].[em_log_201811] AS A
	LEFT JOIN [10.103.1.108].im80.[dbo].[org_user] AS U
    ON A.tran_etc1 = U.code AND domain_id = '11'
	LEFT join [10.103.1.108].im80.dbo.org_Group as gr
	on U.group_id = gr.group_id 
	LEFT join [10.103.1.108].im80.dbo.org_Group as grp
	on gr.parent_id = grp.group_id
 WHERE 1=1 
		AND A.tran_status = '3'   -- 롯데정보통신 -> 고객까지 성공
		AND tran_rslt = '0'			-- 메시지 성공
		--AND convert(char(8), A.tran_reportdate, 112) like '201510%'		
		AND tran_callback != '0234799230'     -- 11월전까지 이진호 팀장님번호로 인증번호 가는게 tran_etc 에 보내는 사람이 아닌 받는 사람 사번이 찍힘. 그러므로 따로 계산
		AND tran_type = '4'   -- 4 : SMS   6: LMS
		AND gr.name is not null
 group by grp.name, gr.name
 --order by grp.name

UNION ALL 
-- 팀장님 번호로 [패스워드 인증번호] 
select 
'운영담당',
'BI/인사파트' ,
count(*)
--SUM(count(*)) OVER() AS [SUM]
from SMS_SYSTEM.[dbo].[em_log_201811] AS A
	LEFT JOIN [10.103.1.108].im80.[dbo].[org_user] AS U
    ON A.tran_etc1 = U.code AND domain_id = '11'
	LEFT join [10.103.1.108].im80.dbo.org_Group as gr
	on U.group_id = gr.group_id 
	LEFT join [10.103.1.108].im80.dbo.org_Group as grp
	on gr.parent_id = grp.group_id
 WHERE 1=1 
		AND A.tran_status = '3'   -- 롯데정보통신 -> 고객까지 성공
		AND tran_rslt = '0'			-- 메시지 성공
		--AND convert(char(8), A.tran_reportdate, 112) like '201510%'		
		AND tran_callback = '0234799230'     -- 11월전까지 이진호 팀장님번호로 인증번호 가는게 tran_etc 에 보내는 사람이 아닌 받는 사람 사번이 찍힘. 그러므로 따로 계산
		AND tran_type = '4'   -- 4 : SMS   6: LMS
		--AND gr.name is not null



UNION ALL

select 
'SCM팀' ,
'SCM운영담당' ,
count(*) 
from SMS_SYSTEM.[dbo].[em_log_201811] AS A
	LEFT JOIN [10.103.1.108].im80.[dbo].[org_user] AS U
    ON A.tran_etc1 = U.code AND domain_id = '11'
	LEFT join [10.103.1.108].im80.dbo.org_Group as gr
	on U.group_id = gr.group_id 
	LEFT join [10.103.1.108].im80.dbo.org_Group as grp
	on gr.parent_id = grp.group_id
 WHERE 1=1 
		AND A.tran_status = '3'   -- 롯데정보통신 -> 고객까지 성공
		AND tran_rslt = '0'			-- 메시지 성공		
		AND tran_type = '4'   -- 4 : SMS   6: LMS
		AND gr.name is null   -- 부서 못찾은 것중 SCM 운영담당
		AND tran_callback in ( '0317607972' , '0553848628', '0429308292' , '0316777743' , '0625718876', '01020490366','0234799462' ) 

	UNION ALL

select 
'영업지원팀' ,
'영업지원담당' ,
count(*)
from SMS_SYSTEM.[dbo].[em_log_201811] AS A
	LEFT JOIN [10.103.1.108].im80.[dbo].[org_user] AS U
    ON A.tran_etc1 = U.code AND domain_id = '11'
	LEFT join [10.103.1.108].im80.dbo.org_Group as gr
	on U.group_id = gr.group_id 
	LEFT join [10.103.1.108].im80.dbo.org_Group as grp
	on gr.parent_id = grp.group_id
 WHERE 1=1 
		AND A.tran_status = '3'   -- 롯데정보통신 -> 고객까지 성공
		AND tran_rslt = '0'			-- 메시지 성공		
		AND tran_type = '4'   -- 4 : SMS   6: LMS
		AND gr.name is null  -- 부서 못찾는 것!! 영업지원담당 박주용 번호 
		AND tran_callback in ( '0234799364' ) 


UNION ALL  -- 2016-09-26 추가 이완상 : 회계(최유진 대리) 부서 못찾는 번호 
select 
'외주지원팀' ,  -- 2017-11-28 변경 이완상 : 생산지원팀 외주관리담당에서 외주지원팀 외주지원담당으로 부서 명칭 변경
'외주지원담당' ,
count(*)
from SMS_SYSTEM.[dbo].[em_log_201811] AS A
	LEFT JOIN [10.103.1.108].im80.[dbo].[org_user] AS U
    ON A.tran_etc1 = U.code AND domain_id = '11'
	LEFT join [10.103.1.108].im80.dbo.org_Group as gr
	on U.group_id = gr.group_id 
	LEFT join [10.103.1.108].im80.dbo.org_Group as grp
	on gr.parent_id = grp.group_id
 WHERE 1=1 
		AND A.tran_status = '3'   -- 롯데정보통신 -> 고객까지 성공
		AND tran_rslt = '0'			-- 메시지 성공		
		AND tran_type = '4'   -- 4 : SMS   6: LMS
		AND gr.name is null  -- 부서 못찾는 것!! 외주관리담당 김형규 번호 
		AND tran_callback in ( '0220175724' ) 

UNION ALL  -- 2017-02-21 추가 이완상 : 콜센터(성지홍 사원) 부서 못찾는거 
select 
'커뮤니케이션팀' ,
'소비자상담담당' ,
count(*)
from SMS_SYSTEM.[dbo].[em_log_201811] AS A
	LEFT JOIN [10.103.1.108].im80.[dbo].[org_user] AS U
    ON A.tran_etc1 = U.code AND domain_id = '11'
	LEFT join [10.103.1.108].im80.dbo.org_Group as gr
	on U.group_id = gr.group_id 
	LEFT join [10.103.1.108].im80.dbo.org_Group as grp
	on gr.parent_id = grp.group_id
 WHERE 1=1 
		AND A.tran_status = '3'   -- 롯데정보통신 -> 고객까지 성공
		AND tran_rslt = '0'			-- 메시지 성공		
		AND tran_type = '4'   -- 4 : SMS   6: LMS
		AND gr.name is null  -- 부서 못찾는 것!! 외주관리담당 김형규 번호 
		AND tran_callback in ( '0234799215' ) 


UNION ALL  -- 2017-07-19 추가 이완상 : 롯데카드 법인 영업1팀 02-2050-1328 김아름대리님과 협의완료.(해당번호가 롯데카드 번호이므로 담당자 지정 불가)
select 
'영업지원팀' ,
'영업지원담당' ,
count(*)
from SMS_SYSTEM.[dbo].[em_log_201811] AS A
	LEFT JOIN [10.103.1.108].im80.[dbo].[org_user] AS U
    ON A.tran_etc1 = U.code AND domain_id = '11'
	LEFT join [10.103.1.108].im80.dbo.org_Group as gr
	on U.group_id = gr.group_id 
	LEFT join [10.103.1.108].im80.dbo.org_Group as grp
	on gr.parent_id = grp.group_id
 WHERE 1=1 
		AND A.tran_status = '3'   -- 롯데정보통신 -> 고객까지 성공
		AND tran_rslt = '0'			-- 메시지 성공		
		AND tran_type = '4'   -- 4 : SMS   6: LMS
		AND gr.name is null  -- 부서 못찾는 것!! 외주관리담당 김형규 번호 
		AND tran_callback in ( '0220501328' ) 

--발신하는 사람 사번을 etc1에 보내도록 개발하였으므로 아래 쿼리 사용 안함. 2017-01-25 이완상	
--UNION ALL  -- 2016-09-26 추가 이완상 : 회계(최유진 대리) 부서 못찾는 번호 

--select 
--'음료재경팀' ,
--'자금담당' ,
--count(*)
--from SMS_SYSTEM.[dbo].[em_log_201612] AS A
--	LEFT JOIN [10.103.1.108].im80.[dbo].[org_user] AS U
--    ON A.tran_etc1 = U.code AND domain_id = '11'
--	LEFT join [10.103.1.108].im80.dbo.org_Group as gr
--	on U.group_id = gr.group_id 
--	LEFT join [10.103.1.108].im80.dbo.org_Group as grp
--	on gr.parent_id = grp.group_id
-- WHERE 1=1 
--		AND A.tran_status = '3'   -- 롯데정보통신 -> 고객까지 성공
--		AND tran_rslt = '0'			-- 메시지 성공		
--		AND tran_type = '4'   -- 4 : SMS   6: LMS
--		AND gr.name is null  -- 부서 못찾는 것!! 자금담당 장한, 송하동 번호
--		AND tran_callback in ( '0234799193', '0234799196' ) 


-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

select distinct(tran_callback)
from SMS_SYSTEM.[dbo].[em_log_201811] AS A
	LEFT JOIN [10.103.1.108].im80.[dbo].[org_user] AS U
    ON A.tran_etc1 = U.code AND domain_id = '11'
	LEFT join [10.103.1.108].im80.dbo.org_Group as gr
	on U.group_id = gr.group_id 
	LEFT join [10.103.1.108].im80.dbo.org_Group as grp
	on gr.parent_id = grp.group_id
 WHERE 1=1 
		AND A.tran_status = '3'   -- 롯데정보통신 -> 고객까지 성공
		AND tran_rslt = '0'			-- 메시지 성공		
		AND tran_type = '4'   -- 4 : SMS   6: LMS
		AND gr.name is null  -- 부서 못찾는 것!!
		--AND tran_callback in ( '01099588759' ) 

select count(*)
from SMS_SYSTEM.[dbo].[em_log_201706] AS A
	LEFT JOIN [10.103.1.108].im80.[dbo].[org_user] AS U
    ON A.tran_etc1 = U.code AND domain_id = '11'
	LEFT join [10.103.1.108].im80.dbo.org_Group as gr
	on U.group_id = gr.group_id 
	LEFT join [10.103.1.108].im80.dbo.org_Group as grp
	on gr.parent_id = grp.group_id
 WHERE 1=1 
		AND A.tran_status = '3'   -- 롯데정보통신 -> 고객까지 성공
		AND tran_rslt = '0'			-- 메시지 성공		
		AND tran_type = '4'   -- 4 : SMS   6: LMS
		AND gr.name is null  -- 부서 못찾는 것!! 
		--AND tran_callback in ( '01020490366' ) 


/* 부서 없는 건 검색(하드코딩 제외) */
select tran_callback, tran_msg, tran_etc1, U.name, gr.name
from SMS_SYSTEM.[dbo].[em_log_201803] AS A
	LEFT JOIN [10.103.1.108].im80.[dbo].[org_user] AS U
    ON A.tran_etc1 = U.code AND domain_id = '11'
	LEFT join [10.103.1.108].im80.dbo.org_Group as gr
	on U.group_id = gr.group_id 
	LEFT join [10.103.1.108].im80.dbo.org_Group as grp
	on gr.parent_id = grp.group_id
 WHERE 1=1 
		AND A.tran_status = '3'   -- 롯데정보통신 -> 고객까지 성공
		AND tran_rslt = '0'			-- 메시지 성공		
		AND tran_type = '4'   -- 4 : SMS   6: LMS
		AND gr.name is null  -- 부서 못찾는 것!! 
		AND tran_callback not in ( '0220175724','0234799364','0317607972','0553848628' , '0429308292', '0316777743' , '0625718876' , '01020490366', '0234799462','0220501328')
	
 


 select tran_etc1, count(*), SUM(count(tran_etc1)) OVER() from SMS_SYSTEM.[dbo].[em_log_201601] where  tran_type = '4' AND  tran_status = '3' AND tran_rslt = '0'	 AND tran_callback != '0234799230' group by tran_etc1





/* ***************************
부서없는 것 건바이 검색 
*****************************/

select 
--gr.name,
--count(*) ,
--sum(count(*)) OVER() AS sum
*
from SMS_SYSTEM.[dbo].[em_log_201611] AS A
	LEFT JOIN [10.103.1.108].im80.[dbo].[org_user] AS U
    ON A.tran_etc1 = U.code AND domain_id = '11'
	LEFT join [10.103.1.108].im80.dbo.org_Group as gr
	on U.group_id = gr.group_id 
 WHERE 1=1 
		AND A.tran_status = '3'   -- 롯데정보통신 -> 고객까지 성공
		AND tran_rslt = '0'			-- 메시지 성공
		--AND convert(char(8), A.tran_reportdate, 112) like '201510%'		
		AND tran_callback != '0234799230'     -- 11월전까지 이진호 팀장님번호로 인증번호 가는게 tran_etc 에 보내는 사람이 아닌 받는 사람 사번이 찍힘. 그러므로 따로 계산
		AND tran_type = '4'   -- 4 : SMS   6: LMS	
		AND gr.name is null	
		AND tran_callback not in ( '0317607972' , '0553848628', '0429308292' , '0316777743' , '0625718876', '01020490366','0234799364' ) 





select 
*
--SUM(count(*)) OVER() AS [SUM]
from SMS_SYSTEM.[dbo].[em_log_201601] AS A
	LEFT JOIN [10.103.1.108].im80.[dbo].[org_user] AS U
    ON A.tran_etc1 = U.code AND domain_id = '11'
	LEFT join [10.103.1.108].im80.dbo.org_Group as gr
	on U.group_id = gr.group_id 
	LEFT join [10.103.1.108].im80.dbo.org_Group as grp
	on gr.parent_id = grp.group_id
 WHERE 1=1 
		AND A.tran_status = '3'   -- 롯데정보통신 -> 고객까지 성공
		AND tran_rslt = '0'			-- 메시지 성공
		--AND convert(char(8), A.tran_reportdate, 112) like '201510%'		
		AND tran_callback != '0234799230'     -- 11월전까지 이진호 팀장님번호로 인증번호 가는게 tran_etc 에 보내는 사람이 아닌 받는 사람 사번이 찍힘. 그러므로 따로 계산
		AND tran_type = '4'   -- 4 : SMS   6: LMS
		AND gr.name is not null
		AND gr.name = '음료인사담당'
 group by grp.name, gr.name
 --order by grp.name

 select count(*) from SMS_SYSTEM.[dbo].[em_log_201601]  where tran_rslt = '0' AND tran_type = '4'
 select count(*) from SMS.[dbo].[em_log_201601] where tran_rslt = '0' AND tran_type = '4'

 
  select count(*) from SMS_SYSTEM.[dbo].[em_log_201611] where tran_rslt = '0' AND tran_type = '4' AND 
  select count(*) from SMS.[dbo].[em_log_201611] where tran_rslt = '0' AND tran_type = '4' AND tran_net = 'ETC'