
select * from [dbo].[org_user] where name in ( '박경린', '윤희용','이완상', '이상우')
AND sec_level = '2'

/******************************************************
* 수기계정에 대해 통합웹에 sap 정보 넘겨주기 위한 쿼리 
********************************************************/
declare @code varchar(20)
set @code = (select code from [dbo].[org_user] where name = '이상우' AND sec_level = '2')

begin tran 
update [dbo].[org_user]
set ex_dept_cd = (select dept_cd from tsd_emp where emp_id = @code) ,
	ex_dept_nm = (select dept_nm from tsd_emp where emp_id = @code) ,
	ex_comp_nm = (select comp_nm from tsd_emp where emp_id = @code) ,
	ex_sap_id = (select sap_id from tsd_emp where emp_id = @code) ,
	ex_sap_nm = (select sap_nm from tsd_emp where emp_id = @code)
where code = @code

rollback
commit


select dept_cd, dept_nm, comp_nm, sap_id, sap_nm from tsd_emp
WHERE EMP_ID in ('20034', '19026')

--update [dbo].[org_user]
--set ex_dept_cd = (select dept_cd from tsd_emp where emp_id = '20239') ,
--	ex_dept_nm = (select dept_nm from tsd_emp where emp_id = '20239') ,
--	ex_comp_nm = (select comp_nm from tsd_emp where emp_id = '20239') ,
--	ex_sap_id = (select sap_id from tsd_emp where emp_id = '20239') ,
--	ex_sap_nm = (select sap_nm from tsd_emp where emp_id = '20239')
--where code = '20239'