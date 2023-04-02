  select  count(*)   from ( 
  select                                                                     
     company                                                                 
  ,  mileage_userno  as document_workerno                     
  ,  document_workernm                                                 
  ,  user_workerlevelnm  as document_workerlevelname     
  ,  mileage_deptnm  as document_deptnm                        
  ,  sum(document_tot)  as document_tot                          
  ,  sum (document_mileage)  as document_mileage          
  ,  sum (document_totmileage)  as document_totmileage    
  from (                                                                   

--// 기간마일리지
  select  a.company    	                                                    
    ,		 mileage_userno   	                                            
    ,		 user_nm as document_workernm  	                   
    ,		 user_workerlevelnm           	                                
    ,		 mileage_deptnm        	                                        
    ,		 0 as document_tot 	                                            
    ,		 isnull( sum( a.mileage_mileage), 0) as document_mileage     
    ,		 0 as document_totmileage 	                                    
    from	 INOC_MILEAGE_TBL  a    	                                    
   left   outer   join INOC_USER_TBL b   on	 a.company = b.company     	     
                                 and	 a.mileage_userno = b.user_no    	
   left   outer   join INOC_DEPT_TBL c   on	 a.company = c.company     	      
                                 and	 a.mileage_deptcd = c.dept_code     

   where    a.company = '00000001'      
   and    charindex('U', mileage_type) > 0                                  

 and	 a.mileage_writedate >= '2016-01-01 00:00:00.000'   
  and	 a.mileage_writedate <= '2016-04-27 23:59:59.000' 	   

    group   by a.company, mileage_userno, mileage_deptnm, user_nm, user_workerlevelnm                
  union all                                                                    

-- 기간개수 
    select 		 a.company                                                     
      ,		 document_workerno                                                
      ,		 user_nm as document_workernm                               
    ,		 user_workerlevelnm           	                                    
      ,		 document_deptnm                                                   
      ,		 count(a.document_key) as document_tot                    
      ,		 0 as document_mileage                                            
    ,		 0 as document_totmileage 	                                     
      from	 INOC_DOCUMENT_MASTER_TBL  a                          
     left    outer  join INOC_USER_TBL b   on	 a.company = b.company             
                                   and	 a.document_workerno = b.user_no        
     left    outer  join INOC_DEPT_TBL c   on	 a.company = c.company             
                                   and	 a.document_deptcd = c.dept_code       

  where   a.company = 00000001 
  and	 a.document_proctype > '1'                                      
  and	 a.document_evaluatestep = 'E'                                
  and	 a.document_show = 'Y'                                          

 and	 a.document_writedate >= '2016-01-01 00:00:00.000' 	
 and	 a.document_writedate <= '2016-04-27 23:59:59.000' 	

 group   by a.company, document_workerno, document_deptnm, user_nm, user_workerlevelnm          
                 
-- 누적
   union all                                                              
 select  a.company    	                                             
   ,		 mileage_userno   	                                     
   ,		 user_nm as document_workernm  	             
   ,		 user_workerlevelnm           	                         
   ,		 mileage_deptnm        	                                 
   ,		 0 as document_tot 	                                     
   ,		 0 as document_mileage 	                             
   ,		 isnull( sum( a.mileage_mileage), 0) as document_totmileage     
   from	 INOC_MILEAGE_TBL  a    	                                        

    left   outer   join INOC_USER_TBL b   on	 a.company = b.company     	     
                                  and	 a.mileage_userno = b.user_no    
    left   outer   join INOC_DEPT_TBL c   on	 a.company = c.company     	      
                                  and	 a.mileage_deptcd = c.dept_code     

    where    a.company = '00000001'                                 
    and    charindex('U', mileage_type) > 0                                 
    group   by a.company, mileage_userno, mileage_deptnm, user_nm, user_workerlevelnm               
                    
    ) d       
  group   by company, mileage_userno, document_workernm, mileage_deptnm, user_workerlevelnm          
  having  isnull(sum(document_mileage), 0) > 0                                
  ) e                                                                           