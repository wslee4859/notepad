
-- ���繮�� ���  ekwsql (sa/ admin)
-- form_id
use ewfform
select * from dbo.WF_FORMS where form_name ='��������߻���Ȳ' 


-- �ش��ϴ� ���繮�� ������� ������ ���繮�� �ֱ�100�� 
-- ���� ���μ��� ���̵� PROCESS_ID
-- ���� ��Ȳ(���3, ����7) PROCESS_INSTANCE_STATE

use ewfform
select top 100 * from dbo.FORM_Y747BB57D3D334E53A0CA83F8BE4E379C
where 1=1 
	--AND U_SUBJECT_DETAIL_INPUT like '%Ŀ��%'
	AND CREATOR = '���߱�'
order by suggestdate desc


select * from dbo.FORM_Y2B172D247B4B4E03A74ABC4B674FEA11
where suggestdate > '20140331' AND suggestdate < '20150501'


select top 100 * from dbo.FORM_Y747BB57D3D334E53A0CA83F8BE4E379C order by suggestdate DESC

select top 100 * from dbo.FORM_Y9818DD0694314EE3B0FD3157E6B21B81 order by suggestdate DESC


