
-- 力救付老府瘤 
insert into INOC_MILEAGE_TBL 
 ( 
      company 
 ,    mileage_key 
 ,    document_key 
 ,    document_sort 
 ,    mileage_proctype 
 ,    mileage_deptcd 
 ,    mileage_deptnm 
 ,    mileage_userno 
 ,    mileage_grade 
 ,    mileage_gradenm 
 ,    mileage_mileage 
 ,    mileage_money 
 ,    mileage_type 
 ,    mileage_writedate 
 ) 
 select 
     a.company 
 ,   ( select isnull( max(mileage_key), 0) + 1 from INOC_MILEAGE_DETAIL_TBL where company = '00000001' ) + ROW_NUMBER() Over (Order By a.document_key desc)
 ,   a.document_key 
 ,   ( select isnull( max(document_sort), 0) + 1 from INOC_MILEAGE_TBL where company = '00000001' ) + ROW_NUMBER() Over (Order By a.document_key desc)
 ,   document_proctype 
 ,   c.document_deptcd  
 ,   c.document_deptnm  
 ,   c.document_userno
 ,   document_grade 
 ,   document_gradenm 
 ,	 grade_money 
 ,	 grade_value  
 ,	'U'  + document_proctype 
 ,	getdate() 
 from	INOC_DOCUMENT_MASTER_TBL  a
 inner  join INOC_ADMIN_GRADE_TBL b
 on		a.company = b.company 
 inner  join [dbo].[INOC_DOCUMENT_JOIN_TBL] as c
 on     a.document_key = c.document_key
 and	a.document_typecd = b.grade_typecd 
 and	a.document_grade = b.grade_code 
 where	a.company =  '00000001'
 and	a.document_key  in ( 'I20180400181','I20180400089','I20180400080','I20180400078' ) 

 [dbo].[INOC_DOCUMENT_JOIN_TBL]


I20180400181
I20180400089
I20180400080
I20180400078
 
 insert into INOC_MILEAGE_DETAIL_TBL 
 ( 
     company 
     , mileage_key 
     , mileage_content 
 ) 
 select 
 	 a.company 
 ,   ( select isnull( max(mileage_key), 0) + 1 from INOC_MILEAGE_DETAIL_TBL where company = @company ) + ROW_NUMBER() Over (Order By document_key desc) 
 ,	'力救[' + document_key + ']' + document_gradenm + ' | ' +  convert(nvarchar(1000), ( select grade_money from INOC_ADMIN_GRADE_TBL where grade_code =  document_grade))
     from INOC_DOCUMENT_MASTER_TBL a 
     inner join INOC_ADMIN_CODE_TBL b on a.company = b.company 
                                     and b.code_highcd = 'BA4D5711' 
                                     and a.document_typecd = b.code_type1 
 where a.company = @company
 and	a.document_key in ( select document_key from @end)
