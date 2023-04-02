SELECT * FROM 
(SELECT ROW_NUMBER() OVER(ORDER BY Idx desc) AS ROWCNT 
,TITLE 
,UserID 
,DeptID 
,ArticleSeq
,(Select [user_name] From [COMMON].[IM].[VIEW_USER] (nolock) Where user_code = Lst.UserID) AS USERNAME 
,CreateDate 
,ArticleID 
From [BD].[BoardBase] (nolock) AS Lst where Lst.BoardID = '408' )
tb1 


WHERE ROWCNT BETWEEN @Start_Row AND @End_Row';

