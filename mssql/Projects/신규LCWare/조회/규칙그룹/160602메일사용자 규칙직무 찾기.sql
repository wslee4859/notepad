
/* ���� �׷� ��� ���� ��ȸ 
* 
*/
select * from [dbo].[org_group] where group_id in ('2391','8215')
select * from [dbo].[org_rule_group] where rule_group_id = '8215'
-- <rule><and><in type="group" seq="nir2_2" /><prop type="user" value="*|loginid|&lt;&gt;|''|domainid|=|11" /></and></rule>
select * from [dbo].[org_rule_group_ex] where rule_group_id = '8215' AND seq = 'nir2_2'


select * from [dbo].[org_group] where group_id in (select group_id from [dbo].[org_rule_group_ex] where rule_group_id = '8215' AND seq = 'nir2_2')
-- 2017-02-06 MD(EC), AMD(����) �߰�. ��ȹ�� ����, �̿ϻ�
-- 2017-05-29 �������� ����. ��ȹ�� ����(���뼮 �Ŵ��� ��û) �̿ϻ�