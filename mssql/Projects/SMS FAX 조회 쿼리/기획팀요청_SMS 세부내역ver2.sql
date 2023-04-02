/****************************************
��ȹ�� ��û�� ���� ����� ���� ����
SMS, SMS_SYSTEM �ΰ� ������ ��.
1. 2016-09-28 ����

****************************************/


/****************************
* SMS ���� �󼼳���
*****************************/
select 
distinct
-- grp.name,
tran_date,
gr.name ,
--tran_phone,
--tran_callback,
replace(replace(tran_msg,char(13),''),char(10),''),
U.name
--U.code,
--U.login_id
--count(*) 
--SUM(count(*)) OVER() AS [SUM]
from SMS.[dbo].[em_log_201802] AS A
	LEFT JOIN [10.103.1.108].im80.[dbo].[org_user] AS U
    ON A.tran_etc1 = U.code AND domain_id = '11'
	LEFT join [10.103.1.108].im80.dbo.org_Group as gr
	on U.group_id = gr.group_id 
	LEFT join [10.103.1.108].im80.dbo.org_Group as grp
	on gr.parent_id = grp.group_id
 WHERE 1=1 
		AND A.tran_status = '3'   -- �Ե�������� -> ������ ����
		AND tran_rslt = '0'			-- �޽��� ����
		--AND convert(char(8), A.tran_reportdate, 112) like '201510%'		
		--AND tran_callback != '0234799230'     -- 11�������� ����ȣ ����Թ�ȣ�� ������ȣ ���°� tran_etc �� ������ ����� �ƴ� �޴� ��� ����� ����. �׷��Ƿ� ���� ���
											  -- 11�� ���ʹ� ������ȣ��  SYSTEM������ �Ѿ. 
		--AND tran_type = '4'   -- 4 : SMS   6: LMS	
		--AND gr.name like '%���������������%'	
 --group by grp.name, gr.name
 order by tran_date, gr.name



/****************************
* SMS_SYSTEM�� ���� �󼼳���
*****************************/
select 
grp.name,
gr.name ,
tran_phone,
tran_callback,
tran_date,
replace(replace(tran_msg,char(13),''),char(10),''),
U.name,
U.code,
U.login_id
from SMS_SYSTEM.[dbo].[em_log_201607] AS A
	LEFT JOIN [10.103.1.108].im80.[dbo].[org_user] AS U
    ON A.tran_etc1 = U.code AND domain_id = '11'
	LEFT join [10.103.1.108].im80.dbo.org_Group as gr
	on U.group_id = gr.group_id 
	LEFT join [10.103.1.108].im80.dbo.org_Group as grp
	on gr.parent_id = grp.group_id
 WHERE 1=1 
		AND A.tran_status = '3'   -- �Ե�������� -> ������ ����
		AND tran_rslt = '0'			-- �޽��� ����
		--AND convert(char(8), A.tran_reportdate, 112) like '201510%'		
		AND tran_callback != '0234799230'     -- 11�������� ����ȣ ����Թ�ȣ�� ������ȣ ���°� tran_etc �� ������ ����� �ƴ� �޴� ��� ����� ����. �׷��Ƿ� ���� ���
		AND U.name is not null									  -- 11�� ���ʹ� ������ȣ��  SYSTEM������ �Ѿ. 
		AND tran_type = '4'   -- 4 : SMS   6: LMS		
		AND gr.name like '%����������%'	
 --group by grp.name, gr.name
  order by tran_date



 UNION ALL 
-- ����� ��ȣ�� [�н����� ������ȣ] 
select 
'����',
'BI/�λ���Ʈ' ,
tran_phone,
tran_callback,
tran_date,
replace(replace(tran_msg,char(13),''),char(10),''),
'�̿ϻ�',
'19026',
'wslee4859'
--SUM(count(*)) OVER() AS [SUM]
from SMS_SYSTEM.[dbo].[em_log_201607] AS A
	LEFT JOIN [10.103.1.108].im80.[dbo].[org_user] AS U
    ON A.tran_etc1 = U.code AND domain_id = '11'
	LEFT join [10.103.1.108].im80.dbo.org_Group as gr
	on U.group_id = gr.group_id 
	LEFT join [10.103.1.108].im80.dbo.org_Group as grp
	on gr.parent_id = grp.group_id
 WHERE 1=1 
		AND A.tran_status = '3'   -- �Ե�������� -> ������ ����
		AND tran_rslt = '0'			-- �޽��� ����
		--AND convert(char(8), A.tran_reportdate, 112) like '201510%'		
		AND tran_callback = '0234799230'     -- 11�������� ����ȣ ����Թ�ȣ�� ������ȣ ���°� tran_etc �� ������ ����� �ƴ� �޴� ��� ����� ����. �׷��Ƿ� ���� ���
		AND tran_type = '4'   -- 4 : SMS   6: LMS
		AND U.name is not null			
		--AND gr.name is not null
order by tran_date


--
-- User �������� �ǵ�
-- 
select 
tran_phone,
tran_callback,
tran_date,
replace(replace(tran_msg,char(13),''),char(10),'')
--SUM(count(*)) OVER() AS [SUM]
from SMS_SYSTEM.[dbo].[em_log_201607] AS A
	LEFT JOIN [10.103.1.108].im80.[dbo].[org_user] AS U
    ON A.tran_etc1 = U.code AND domain_id = '11'
	LEFT join [10.103.1.108].im80.dbo.org_Group as gr
	on U.group_id = gr.group_id 
	LEFT join [10.103.1.108].im80.dbo.org_Group as grp
	on gr.parent_id = grp.group_id
 WHERE 1=1 
		AND A.tran_status = '3'   -- �Ե�������� -> ������ ����
		AND tran_rslt = '0'			-- �޽��� ����		
		AND tran_type = '4'   -- 4 : SMS   6: LMS
		AND U.name is null			
		--AND gr.name is not null
order by tran_date



/****************************************
* �� ��⺰ ���� ����
*****************************************/
select tran_etc3, count(tran_etc3) 
from SMS_SYSTEM.[dbo].[em_log_201606]
 WHERE 1=1 
		AND tran_status = '3'   -- �Ե�������� -> ������ ����
		AND tran_rslt = '0'			-- �޽��� ����
		--AND convert(char(8), A.tran_reportdate, 112) like '201510%'		
		--AND tran_callback != '0234799230'     -- 11�������� ����ȣ ����Թ�ȣ�� ������ȣ ���°� tran_etc �� ������ ����� �ƴ� �޴� ��� ����� ����. �׷��Ƿ� ���� ���
											  -- 11�� ���ʹ� ������ȣ��  SYSTEM������ �Ѿ. 
		AND tran_type = '4'   -- 4 : SMS   6: LMS	
group by tran_etc3


