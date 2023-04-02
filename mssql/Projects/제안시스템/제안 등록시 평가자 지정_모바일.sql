select 
'00000001',
'I20161100007', 
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
 AND evaluser_code = '01314'
 AND evaluser_no not in ( select evaluate_userno from INOC_EVALUATE_JUDGE_TBL
 where company = '00000001'
 and document_key = 'I20161100007'
 and evaluate_proctype = '1' )



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