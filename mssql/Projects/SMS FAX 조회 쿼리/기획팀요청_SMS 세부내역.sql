select 
r.CALLBACKNO, 
r.SMSDATA, 
count(r.callbackNO),
T.UserName,
d.deptname,
h.startdate,
R.User_NO,
h.UserID
FROM [dbo].[SMS_RESULT] AS R
left join eManage.dbo.Tb_user AS T
	on R.USER_NO = T.UserID
left outer join eManage.dbo.tb_dept_user_history h
			on	h.userid = R.user_no
			and	'20150731' between h.startdate and h.enddate    -- 해당 유저가 해당월에 발령나기전 부서 조회
			and	h.positionOrder = 1
left outer join	eManage.dbo.tb_dept d
			on	d.deptid = h.deptid
where	convert(char(8), START_TIME, 112) like '201507%' AND result = '06'  
group by r.CALLBACKNO, r.SMSDATA, T.UserName, d.deptname, h.startdate, h.UserID, R.User_NO
order by count(r.callbackNO) desc


select 
r.SMSDATA
FROM [dbo].[SMS_RESULT] AS R
left join eManage.dbo.Tb_user AS T
on R.USER_NO = T.UserID
where	convert(char(8), START_TIME, 112) like '201508%' AND result = '06'  AND callbackNO = '01049025551'

