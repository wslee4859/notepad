WITH CTE
AS 
( select dept_code, dept_name, dept_highcd, dept_highnm, dept_step, 1 as lvl
, CONVERT(VARCHAR(250), '/' + dept_name) AS path
from INOC_DEPT_TBL
where company = '00000001'
and dept_code = '01314   '
union all 
select  A.dept_code, A.dept_name, A.dept_highcd, A.dept_highnm, A.dept_step, lvl + 1 as lvl
, CONVERT(VARCHAR(250), path + '/' + A.dept_name)
from    INOC_DEPT_TBL A
inner	join  CTE B on A.company  = '00000001'
where   A.dept_code = B.dept_highcd )

select top 1
'00000001',
'I20161100009', 
'1',
row_number() over(order by evaluser_proctype asc) '0',
evaluser_deptcd,
b.dept_name,
evaluser_no,
'N' , 
'',
null
 from  INOC_ADMIN_EVALUSER_TBL a
 inner join INOC_DEPT_TBL b on a.company = b.company
 and a.evaluser_deptcd = b.dept_code
 where a.company = '00000001'
 AND evaluser_typecd = 'I'
 AND evaluser_proctype = '1'
 AND evaluser_code in (select dept_code from CTE where dept_step > 1)
 AND evaluser_no not in ( select evaluate_userno from INOC_EVALUATE_JUDGE_TBL
 where company = '00000001'
 and document_key = 'I20161100009'
 and evaluate_proctype = '1')
 order by dept_step desc 





 select *
  from  INOC_ADMIN_EVALUSER_TBL a
 inner join INOC_DEPT_TBL b on a.company = b.company
 and a.evaluser_deptcd = b.dept_code
 where a.company = '00000001'
 AND evaluser_typecd = 'I'
 AND evaluser_proctype = '1'
 AND evaluser_code = '01314'
 AND evaluser_no not in ( select evaluate_userno from INOC_EVALUATE_JUDGE_TBL
 where company = '00000001'
 and document_key = 'I20161100007'
 and evaluate_proctype = '1' )

 INOC_ADMIN_EVALUSER_TBL where evaluser_code = '01314'