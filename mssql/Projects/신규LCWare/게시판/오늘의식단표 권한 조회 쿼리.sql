


/*****************************************************
������ �Ĵ�ǥ ���� Ȯ�� ���� 
user_code 
select user_code from [IM].[VIEW_USER] where user_name ='�̿ϻ�'
�Ĵ��� �ڵ� : 10045
*****************************************************/
use Common

 SELECT M.MenuID, M.CompanyID, M.ParentID, M.MenuLevel, M.MenuType, M.SubSystem,     
     M.Title, M.WebPage, M.Sort, M.SiteCode,
     A.GroupID, A.GroupName, A.GroupType, A.AuthAll, A.AuthRead, A.AuthWrite, A.AuthUpdate, A.AuthDelete, A.AuthDeny    
   FROM CM.Menu M    
   INNER JOIN CM.MenuAuthority A    
   ON  M.MenuID = A.MenuID    
   INNER JOIN IM.VIEW_USER_GROUP IM    
   ON  A.GroupID = IM.group_code    
   AND  IM.user_code = '32088'
   WHERE M.ParentID = '10045'