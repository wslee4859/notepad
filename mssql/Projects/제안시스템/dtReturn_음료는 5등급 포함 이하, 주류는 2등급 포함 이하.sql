 select  code_type1 as code_type
 ,       code_type2 
 ,       code_name 
 ,       code_code 
 ,       code_sort 
 ,       code_highcd
 ,       code_note 
 ,       code_edit 
 ,       code_step 
 ,       code_valid 
 from INOC_ADMIN_CODE_TBL 
 where   company = '00000001' 
 and     code_highcd = '39094F8B' 
 and     code_valid = 'Y' 
 order by code_sort  