use emanage
select distinct a.userid, c.deptname, b.username
from tb_dept_user_history a
	join tb_user b
	on a.userid = b.userid
	join tb_dept c
	on a.deptid = c.deptid
where
'20150815' between convert(varchar,a.startdate,112) and convert(varchar,a.enddate,112)
and a.userid in (
'22722',
'23057',
'23322',
'23607',
'24538',
'24601',
'24888',
'25514',
'25517',
'25846',
'26426',
'27526',
'28371',
'30761',
'32088',
'42233')
order by userid



-- 부서검색--
use emanage
select distinct a.*,
				b.*, 
				c.*,
				cc.DeptName,
				cc.DeptName,
				ccc.DeptName
from tb_dept_user_history a
	left join tb_user b
	on a.userid = b.userid
	left join tb_dept c
	on a.deptid = c.deptid
	left join tb_dept cc
	on c.ParentDeptID = cc.deptid
	left join tb_dept ccc
	on cc.ParentDeptID = ccc.deptid
	left join tb_dept cccc
	on ccc.ParentDeptID = cccc.deptid
where a.userid in ('25846' )

select * from TB_USER where userid = '111315' -- 남궁유진

select * from TB_USER where userCD = '32088' -- 남궁유진
select * from TB_USER where username = '이진호'






  22722
  23057
  23322
  23607
  24538
  24601
  24888
  25514
  25517
  25846
  26426
  27526
  28371
  30761
  32088
  42233

