USE [Common]
GO
/****** Object:  StoredProcedure [CM].[usp_department_user_select]    Script Date: 2017-03-03 오후 12:14:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



/*  ----------------------------------------------------------------------------          
 *  Author  :  김용주(Devpia)          
 *  Create Date : 2012-06-19          
 *  ----------------------------------------------------------------------------          
 *  Description : 조직도 부서관리 [ 부서 사용자 ]           
 *  YYYY-MM-DD(ALTER USER) : DESC          
 *            select top 10 * from IM.VIEW_PLURAL
   EXEC [CM].[usp_department_user_select] '5613'
 *  ----------------------------------------------------------------------------          
 */            
ALTER procedure [CM].[usp_department_user_select]          
(          
  @dept_id nvarchar(64)          
) as            
          
  set nocount on;          
  set transaction isolation level read uncommitted;           
          
       
      
  SELECT        
    user_code AS id          
   ,user_name AS name          
   ,group_code AS dept_id          
   ,classpos_code AS level_cd          
   ,responsibility_code AS todo_cd          
   ,office_phone AS tel          
   ,email           
   ,user_role AS roles          
   ,group_name AS dept_name          
   ,login_id        
   ,mobile  
   ,fax_number as fax
   , email  as company_mail        
   , responsibility_name
   , position_name
   , classpos_name
   , isnull(parent_group_name,'') as parent_group_name
   , b.domain_abbr as domain_abbr
   , isnull(user_role,'') as user_role
   , employee_num
 FROM IM.VIEW_PLURAL A inner join  IM.VIEW_DOMAIN  B
 on A.domain_code=B.domain_code
 WHERE group_code=@dept_id       
 --AND work_status in ('0010', '0020', '9999')      
 AND isnull(display_yn, '') != 'N'
 
 ORDER BY responsibility_seq , classpos_seq, user_name 