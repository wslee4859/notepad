

-- 최상위 조직도 검색 
--( DeleteDate 로 지워진 조직도 있음) 

use emanage
select f.DeptName, s.deptName, t.deptname, ff.deptname, fff.deptname, ffff.deptname FROM dbo.TB_DEPT as f
	left join dbo.TB_DEPT as s
	ON f.parentdeptid = s.deptid
	left join dbo.TB_DePT as t
	on s.parentdeptid = t.deptid
	left join dbo.TB_DePT as ff
	on t.parentdeptid = ff.deptid	
	left join dbo.TB_DePT as fff
	on ff.parentdeptid = fff.deptid	
	left join dbo.TB_DePT as ffff
	on fff.parentdeptid = ffff.deptid	
where f.deletedate > getdate()
	AND f.DeptName like '%화재%'