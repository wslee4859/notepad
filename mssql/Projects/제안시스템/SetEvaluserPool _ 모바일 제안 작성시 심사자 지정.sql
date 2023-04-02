insert  into INOC_EVALUATE_JUDGE_TBL  
 ( 
      a.company
 ,    document_key 
 ,    evaluate_proctype 
 ,    evaluate_sort
 ,    evaluate_deptcd 
 ,    evaluate_deptnm 
 ,    evaluate_userno 
 ,    evaluate_done 
 ,    evaluate_writedate 
 ,    evaluate_evaldate 
 ) 


 WITH CTE                                                                           
                 AS                                                                                 
                 (                                                                                  
                 select  dept_code, dept_name, dept_highcd, dept_highnm, dept_step, 1 as lvl        
                 ,		CONVERT(VARCHAR(250), '/' + dept_name) AS path                              
                 from    INOC_DEPT_TBL                                                              
                 where   1=1                                          

                --if (dept_code.Length > 0)
				 and     dept_code  = '01314'                                         
               -- else
				-- and     dept_code in (select document_deptcd from INOC_DOCUMENT_MASTER_TBL where company = '" + company + "'  and document_key ='" + evaluate_key + "')        \r\n");

                union   all                                                                        
                select  A.dept_code, A.dept_name, A.dept_highcd, A.dept_highnm, A.dept_step, lvl + 1 as lvl  
                ,		CONVERT(VARCHAR(250), path + '/' + A.dept_name)                                      
                from    INOC_DEPT_TBL A                                                                      
                inner	join  CTE B on A.company  = '00000001'                                  
				where   A.dept_code = B.dept_highcd     )

--  SetEvaluserPool 
 select 
         '00000001' 
 ,       'I20170400010'
 ,       '1'
  ,       row_number() over(order by evaluser_proctype asc) 

   ,       evaluser_deptcd 
   ,       b.dept_name 
   ,       evaluser_no 
   ,       'N'
   ,       getdate() 
   ,       null 
   from    INOC_ADMIN_EVALUSER_TBL a 
   inner join INOC_DEPT_TBL b on a.company = b.company
                             and a.evaluser_deptcd = b.dept_code 
   where   a.company = '00000001'  
   and     evaluser_typecd = 'I'  
   and     evaluser_proctype = '1' 
   and     evaluser_code in (select dept_code from CTE              
	       where  dept_step > 1  )                
	and     evaluser_no not in ( select	
   evaluate_userno 
  from INOC_EVALUATE_JUDGE_TBL
  where   company =  '00000001'
  and     document_key =  'I20170400010'
  and     evaluate_proctype =  '1' ) 






  INOC_ADMIN_EVALUSER_TBL where company = '00000001'   
  and     evaluser_typecd = 'I'  
   and     evaluser_proctype = '1' 
   and     evaluser_code = '01314'

   INOC_ADMIN_EVALUSER_TBL where  1=1  and     evaluser_proctype = '1'  and  evaluser_code = '01314'

    INOC_DEPT_TBL where dept_code = '01314   '