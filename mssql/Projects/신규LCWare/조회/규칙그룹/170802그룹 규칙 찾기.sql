/*���� ��Ģ ����*/
 -- 1. �ش� ������ ���Ե� ��Ģ ã��
select * from [dbo].[org_group] where group_id in ('2386')




-- �׷� �� ���� Ȯ�� ǥ�� (seq nir2_4 : �μ�, nir2_7 : ����)
-- ex_type 0 : ���� ������, 1 : ���� ����
select og1.name, orgx.*, og.name from [dbo].[org_rule_group_ex] AS orgx
INNER JOIN [dbo].[org_group] AS og
ON orgx.group_id = og.group_id
INNER JOIN [dbo].[org_group] AS og1  -- ���ϱ׷� �̸�.
ON orgx.rule_group_id = og1.group_id
where rule_group_id = '2405'
order by seq desc