use im80
select 
	   group_id
      ,[domain_id]
      ,[group_type_id]
      ,[parent_id]
      ,[seq]
      ,[status]
      ,[sec_level]
      ,[is_valid]
      ,[create_dt]
      ,[modify_dt]
      ,[name]
      ,[code]
      ,[group_digest]
      ,[start_date]
      ,[end_date]
      ,[description]
      ,[ex_dept_name_full]
      ,[ex_dept_name1]
      ,[ex_sort_key]
      ,[ex_useable_yn]
      ,[ex_level]
      ,[ex_hassubdept]
      ,[ex_use_yn]
      ,[ex_sort_key2]
      ,[ex_sort_key3]
 from [dbo].[org_group] 
where 1=1
AND group_type_id = '-1'    
AND code like 'IM_%'
--AND name = '권한테스트'
AND domain_id = '11'
order by code

--[dbo].[org_group] where group_id = '9046'

