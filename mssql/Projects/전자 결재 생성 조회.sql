--���ڰ��� ���� 
use ewfform    --table : dbo.VW_WORK_LIST


-- �ش� ��¥�� ������ ���� ����
select * from dbo.VW_WORK_LIST 
WHERE 1=1
	AND create_date > '2015-04-13 07:00:00.000'
	AND create_date < '2015-04-13 13:00:00.000'



-- �ش� ��¥�� ������ ���� ���� �� �� �Ϸ�� 
select PARTICIPANT_NAME, ITEMOID, participant_id from dbo.VW_WORK_LIST 
WHERE 1=1
	AND create_date > '2015-04-13 12:00:00.000'
	AND create_date < '2015-04-13 13:00:00.000'
	AND STATE in (0,1,2,3,4,5,6,13)
GROUP BY PARTICIPANT_NAME, ITEMOID, participant_id
ORDER BY PARTICIPANT_NAME


-- �ش� ��¥�� ������ ���� ���� �� �� �Ϸ�� ����
select PARTICIPANT_NAME, count(ITEMOID) from dbo.VW_WORK_LIST 
WHERE 1=1
	AND create_date > '2015-04-13 07:00:00.000'
	AND create_date < '2015-04-13 13:00:00.000'
	AND STATE in (0,1,2,3,4,5,6,13)
GROUP BY PARTICIPANT_NAME
ORDER BY PARTICIPANT_NAME



--�ش� ���� �ð��� ���� ������ ����� �׷�ȭ 
use ewfform
select participant_name from dbo.VW_WORK_LIST 
where create_date > '2015-04-13 09:00:00.000' 
	AND create_date < '2015-04-13 12:00:00.000'
	AND STATE in (0,1,2,3,4,5,6,13)
GROUP BY participant_name
--order by create_date





