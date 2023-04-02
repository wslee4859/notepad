/****************************
LCWare �� SMS ���� �� 
*****************************/
/****************************
������ ���� : 
 - 2016�� 3�� ����Ϸ�
 - 2016�� 4�� ����Ϸ�
 - 2016�� 5�� ����Ϸ�
 - 2016�� 6�� ����Ϸ�
 - 2016�� 7�� ����Ϸ�
 - 2016�� 8�� ����Ϸ�
 - 2016�� 9�� ����Ϸ� 
 - 2016�� 10�� ����Ϸ�
 - 2016�� 11�� ����Ϸ�
 - 2016�� 12�� ����Ϸ�
 - 2017�� 1�� ����Ϸ�
 - 2017�� 2�� ����Ϸ�
 - 2017�� 3�� ����Ϸ�
 - 2017�� 4�� ����Ϸ�
 - 2017�� 5�� ����Ϸ�
 - 2017�� 6�� ����Ϸ�
 - 2017�� 7�� ����Ϸ�
 - 2017�� 8�� ����Ϸ�
 - 2017�� 9�� ����Ϸ�
  - 2017�� 11�� ����Ϸ�
  - 2017�� 12�� ����Ϸ�
  - 2018�� 1�� ����Ϸ�
  - 2018�� 2�� ����Ϸ�
  - 2018�� 3�� ����Ϸ�
  
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
		AND A.tran_status = '3'   -- �Ե�������� -> ������ ����
		AND tran_rslt = '0'			-- �޽��� ����
		--AND convert(char(8), A.tran_reportdate, 112) like '201510%'		
		-- AND tran_callback = '0234799230'     -- 11�������� ����ȣ ����Թ�ȣ�� ������ȣ ���°� tran_etc �� ������ ����� �ƴ� �޴� ��� ����� ����. �׷��Ƿ� ���� ���
											  -- 11�� ���ʹ� ������ȣ��  SYSTEM������ �Ѿ. 
		AND tran_type = '4'   -- 4 : SMS   6: LMS		
 group by grp.name, gr.name
 order by grp.name



/****************************
�ý��� SMS ���� �� 
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
		AND A.tran_status = '3'   -- �Ե�������� -> ������ ����
		AND tran_rslt = '0'			-- �޽��� ����
		--AND convert(char(8), A.tran_reportdate, 112) like '201510%'		
		AND tran_callback != '0234799230'     -- 11�������� ����ȣ ����Թ�ȣ�� ������ȣ ���°� tran_etc �� ������ ����� �ƴ� �޴� ��� ����� ����. �׷��Ƿ� ���� ���
		AND tran_type = '4'   -- 4 : SMS   6: LMS
		AND gr.name is not null
 group by grp.name, gr.name
 --order by grp.name

UNION ALL 
-- ����� ��ȣ�� [�н����� ������ȣ] 
select 
'����',
'BI/�λ���Ʈ' ,
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
		AND A.tran_status = '3'   -- �Ե�������� -> ������ ����
		AND tran_rslt = '0'			-- �޽��� ����
		--AND convert(char(8), A.tran_reportdate, 112) like '201510%'		
		AND tran_callback = '0234799230'     -- 11�������� ����ȣ ����Թ�ȣ�� ������ȣ ���°� tran_etc �� ������ ����� �ƴ� �޴� ��� ����� ����. �׷��Ƿ� ���� ���
		AND tran_type = '4'   -- 4 : SMS   6: LMS
		--AND gr.name is not null



UNION ALL

select 
'SCM��' ,
'SCM����' ,
count(*) 
from SMS_SYSTEM.[dbo].[em_log_201811] AS A
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
		AND gr.name is null   -- �μ� ��ã�� ���� SCM ����
		AND tran_callback in ( '0317607972' , '0553848628', '0429308292' , '0316777743' , '0625718876', '01020490366','0234799462' ) 

	UNION ALL

select 
'����������' ,
'�����������' ,
count(*)
from SMS_SYSTEM.[dbo].[em_log_201811] AS A
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
		AND gr.name is null  -- �μ� ��ã�� ��!! ����������� ���ֿ� ��ȣ 
		AND tran_callback in ( '0234799364' ) 


UNION ALL  -- 2016-09-26 �߰� �̿ϻ� : ȸ��(������ �븮) �μ� ��ã�� ��ȣ 
select 
'����������' ,  -- 2017-11-28 ���� �̿ϻ� : ���������� ���ְ�����翡�� ���������� ��������������� �μ� ��Ī ����
'�����������' ,
count(*)
from SMS_SYSTEM.[dbo].[em_log_201811] AS A
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
		AND gr.name is null  -- �μ� ��ã�� ��!! ���ְ������ ������ ��ȣ 
		AND tran_callback in ( '0220175724' ) 

UNION ALL  -- 2017-02-21 �߰� �̿ϻ� : �ݼ���(����ȫ ���) �μ� ��ã�°� 
select 
'Ŀ�´����̼���' ,
'�Һ��ڻ����' ,
count(*)
from SMS_SYSTEM.[dbo].[em_log_201811] AS A
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
		AND gr.name is null  -- �μ� ��ã�� ��!! ���ְ������ ������ ��ȣ 
		AND tran_callback in ( '0234799215' ) 


UNION ALL  -- 2017-07-19 �߰� �̿ϻ� : �Ե�ī�� ���� ����1�� 02-2050-1328 ��Ƹ��븮�԰� ���ǿϷ�.(�ش��ȣ�� �Ե�ī�� ��ȣ�̹Ƿ� ����� ���� �Ұ�)
select 
'����������' ,
'�����������' ,
count(*)
from SMS_SYSTEM.[dbo].[em_log_201811] AS A
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
		AND gr.name is null  -- �μ� ��ã�� ��!! ���ְ������ ������ ��ȣ 
		AND tran_callback in ( '0220501328' ) 

--�߽��ϴ� ��� ����� etc1�� �������� �����Ͽ����Ƿ� �Ʒ� ���� ��� ����. 2017-01-25 �̿ϻ�	
--UNION ALL  -- 2016-09-26 �߰� �̿ϻ� : ȸ��(������ �븮) �μ� ��ã�� ��ȣ 

--select 
--'���������' ,
--'�ڱݴ��' ,
--count(*)
--from SMS_SYSTEM.[dbo].[em_log_201612] AS A
--	LEFT JOIN [10.103.1.108].im80.[dbo].[org_user] AS U
--    ON A.tran_etc1 = U.code AND domain_id = '11'
--	LEFT join [10.103.1.108].im80.dbo.org_Group as gr
--	on U.group_id = gr.group_id 
--	LEFT join [10.103.1.108].im80.dbo.org_Group as grp
--	on gr.parent_id = grp.group_id
-- WHERE 1=1 
--		AND A.tran_status = '3'   -- �Ե�������� -> ������ ����
--		AND tran_rslt = '0'			-- �޽��� ����		
--		AND tran_type = '4'   -- 4 : SMS   6: LMS
--		AND gr.name is null  -- �μ� ��ã�� ��!! �ڱݴ�� ����, ���ϵ� ��ȣ
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
		AND A.tran_status = '3'   -- �Ե�������� -> ������ ����
		AND tran_rslt = '0'			-- �޽��� ����		
		AND tran_type = '4'   -- 4 : SMS   6: LMS
		AND gr.name is null  -- �μ� ��ã�� ��!!
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
		AND A.tran_status = '3'   -- �Ե�������� -> ������ ����
		AND tran_rslt = '0'			-- �޽��� ����		
		AND tran_type = '4'   -- 4 : SMS   6: LMS
		AND gr.name is null  -- �μ� ��ã�� ��!! 
		--AND tran_callback in ( '01020490366' ) 


/* �μ� ���� �� �˻�(�ϵ��ڵ� ����) */
select tran_callback, tran_msg, tran_etc1, U.name, gr.name
from SMS_SYSTEM.[dbo].[em_log_201803] AS A
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
		AND gr.name is null  -- �μ� ��ã�� ��!! 
		AND tran_callback not in ( '0220175724','0234799364','0317607972','0553848628' , '0429308292', '0316777743' , '0625718876' , '01020490366', '0234799462','0220501328')
	
 


 select tran_etc1, count(*), SUM(count(tran_etc1)) OVER() from SMS_SYSTEM.[dbo].[em_log_201601] where  tran_type = '4' AND  tran_status = '3' AND tran_rslt = '0'	 AND tran_callback != '0234799230' group by tran_etc1





/* ***************************
�μ����� �� �ǹ��� �˻� 
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
		AND A.tran_status = '3'   -- �Ե�������� -> ������ ����
		AND tran_rslt = '0'			-- �޽��� ����
		--AND convert(char(8), A.tran_reportdate, 112) like '201510%'		
		AND tran_callback != '0234799230'     -- 11�������� ����ȣ ����Թ�ȣ�� ������ȣ ���°� tran_etc �� ������ ����� �ƴ� �޴� ��� ����� ����. �׷��Ƿ� ���� ���
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
		AND A.tran_status = '3'   -- �Ե�������� -> ������ ����
		AND tran_rslt = '0'			-- �޽��� ����
		--AND convert(char(8), A.tran_reportdate, 112) like '201510%'		
		AND tran_callback != '0234799230'     -- 11�������� ����ȣ ����Թ�ȣ�� ������ȣ ���°� tran_etc �� ������ ����� �ƴ� �޴� ��� ����� ����. �׷��Ƿ� ���� ���
		AND tran_type = '4'   -- 4 : SMS   6: LMS
		AND gr.name is not null
		AND gr.name = '�����λ���'
 group by grp.name, gr.name
 --order by grp.name

 select count(*) from SMS_SYSTEM.[dbo].[em_log_201601]  where tran_rslt = '0' AND tran_type = '4'
 select count(*) from SMS.[dbo].[em_log_201601] where tran_rslt = '0' AND tran_type = '4'

 
  select count(*) from SMS_SYSTEM.[dbo].[em_log_201611] where tran_rslt = '0' AND tran_type = '4' AND 
  select count(*) from SMS.[dbo].[em_log_201611] where tran_rslt = '0' AND tran_type = '4' AND tran_net = 'ETC'