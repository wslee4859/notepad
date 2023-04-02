/**********************************
* 제안시스템 총 누적점수 조회쿼리*
************************************/
select 	                                             
			 mileage_userno   	                                     
   ,		 replace(user_nm,' ','') as document_workernm  	             
   ,		 replace(user_workerlevelnm,' ','')
   ,		 d.dept_name  
   --,		 mileage_deptnm        	                                 
   --,		 0 as document_tot 	                                     
   --,		 0 as document_mileage 	                             
   ,		 isnull( sum( a.mileage_mileage), 0) as document_totmileage      
   from	 INOC_MILEAGE_TBL  a    	                                        

    left   outer   join INOC_USER_TBL b   on	 a.company = b.company     	     
                                  and	 a.mileage_userno = b.user_no    
    left   outer   join INOC_DEPT_TBL c   on	 a.company = c.company     	      
                                  and	 a.mileage_deptcd = c.dept_code     
	left join INOC_DEPT_TBL d on b.user_deptcd = d.dept_code 
	inner join [dbo].[INOC_USERINFO_TBL] U on a.mileage_userno = U.user_no
    where    a.company = '00000001'                                 
    AND    charindex('U', mileage_type) > 0
	AND    U.user_valid = 'Y'
	-- AND user_nm = '김동진'
	--AND mileage_userno = '20146775'
    GROUP BY a.company, mileage_userno, user_nm, user_workerlevelnm, d.dept_name, d.dept_sort
	order by d.dept_sort
	
	


-- 제안시스템 부서별 개인누적점수 조회 쿼리 
/*
select  a.company    	                                             
   ,		 mileage_userno   	                                     
   ,		 replace(user_nm,' ','') as document_workernm  	             
   ,		 replace(user_workerlevelnm,' ','')
   ,		 mileage_deptnm        	                                 
   ,		 0 as document_tot 	                                     
   ,		 0 as document_mileage 	                             
   ,		 isnull( sum( a.mileage_mileage), 0) as document_totmileage
   ,		 d.dept_name     
   from	 INOC_MILEAGE_TBL  a    	                                        

    left   outer   join INOC_USER_TBL b   on	 a.company = b.company     	     
                                  and	 a.mileage_userno = b.user_no    
    left   outer   join INOC_DEPT_TBL c   on	 a.company = c.company     	      
                                  and	 a.mileage_deptcd = c.dept_code     
	left join INOC_DEPT_TBL d on b.user_deptcd = d.dept_code 
	inner join [dbo].[INOC_USERINFO_TBL] U on a.mileage_userno = U.user_no

    where    a.company = '00000001'                                 
    AND    charindex('U', mileage_type) > 0
	AND    U.user_valid = 'Y'
	AND user_nm = '김동진'
	--AND mileage_userno = '20146775'
    GROUP BY a.company, mileage_userno, user_nm, user_workerlevelnm, mileage_deptnm, d.dept_name, d.dept_sort
	order by d.dept_sort
*/