select 
 	document_typecd 
 ,	document_proctype 
 ,	document_evaluatestep 
 ,	document_choicetype 
 ,	b.mileage_mileage 
 ,	b.mileage_money 
 ,   document_msg 
 ,   document_point 
 ,   document_grade 
 ,   document_gradenm	
 ,   document_workerno	
 ,   document_writerno	
 ,   sync_deptcd		
 ,   (select code_name from INOC_ADMIN_CODE_TBL where  company = '" + company + "' and	code_highcd = '0D3900D7' and code_type1 = a.document_proctype and code_type2 = a.document_typecd) as document_evaluatestate  
 from INOC_DOCUMENT_MASTER_TBL a 
 left join INOC_MILEAGE_TBL b on a.company = b.company 
                              and a.document_key = b.document_key 
                              and b.mileage_type like 'U%' 
 left outer join INOC_DOCUMENT_SYNC_DEPT_TBL c on a.company = c.company  
                                               and	a.document_key = c.document_key               
 where a.company = '00000001' 
 and a.document_key = 'I20170200015' 

 I
 00577   