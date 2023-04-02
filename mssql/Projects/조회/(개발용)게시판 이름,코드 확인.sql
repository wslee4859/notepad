--[BD].[BoardInfo]


--[BD].[BoardInfo]


/*************************
게시판 명 코드 확인  SP
**************************/
select * from 
[BD].[BoardText] 
where TextId in (select BoardID from [BD].[BoardInfo] WHERE BoardRootID = 'SITE05')

