--[BD].[BoardInfo]


--[BD].[BoardInfo]


/*************************
�Խ��� �� �ڵ� Ȯ��  SP
**************************/
select * from 
[BD].[BoardText] 
where TextId in (select BoardID from [BD].[BoardInfo] WHERE BoardRootID = 'SITE05')

