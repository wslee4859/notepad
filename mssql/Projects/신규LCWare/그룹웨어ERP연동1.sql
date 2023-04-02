80기 신입사원 사번.
--select usercd, useraccount, *  from tb_user where usercd in
--('20150676',
--'20150675',
--'20150674',
--'20150669',
--'20150671',
--'20150679',
--'20150681',
--'20150680',
--'20150682',
--'20150683',
--'20150684',
--'20150685',
--'20150673',
--'20150686',
--'20150670',
--'20150672',
--'20150677',
--'20150678')
--
--SELECT 'A'    -- 여기서 @pWorkingTag = 'A' 임. 그룹별 사용자 추가이기 때문에
--               ,'E'
--               ,'sungddok'
--               ,GrpSecuID
--               ,''
--               ,''
--               ,GETDATE()
--               ,0
--        FROM dbo.fnGetGrpList('20150670', 'U')


update TZAAuthorityBasis	set UserID = '20150672' where  UserID = 'bzy3411'
update TZAAuthorityBasis	set UserID = '20150669' where  UserID = 'sungddok'
update TZAAuthorityBasis	set UserID = '20150670' where  UserID = 'asg1228'
update TZAAuthorityBasis	set UserID = '20150673' where  UserID = 'anphoto'
update TZAAuthorityBasis	set UserID = '20150676' where  UserID = 'doyoung'
update TZAAuthorityBasis	set UserID = '20150679' where  UserID = 'gaeun'
update TZAAuthorityBasis	set UserID = '20150680' where  UserID = 'hellomyhs'
update TZAAuthorityBasis	set UserID = '20150681' where  UserID = 'lsm6015'
update TZAAuthorityBasis	set UserID = '20150682' where  UserID = 'eightsix'
update TZAAuthorityBasis	set UserID = '20150683' where  UserID = 'hyun40816'
update TZAAuthorityBasis	set UserID = '20150684' where  UserID = 'pigtank'
update TZAAuthorityBasis	set UserID = '20150685' where  UserID = 'gale15'

--DECLARE @a int, @b varchar(100), @c int EXEC UP_UPDATE_ACCOUNT '20150670','asg1228','', @a OUTPUT, @b OUTPUT, @c OUTPUT SELECT @a, @b, @c
--DECLARE @a int, @b varchar(100), @c int EXEC UP_UPDATE_ACCOUNT '20150676','doyoung','', @a OUTPUT, @b OUTPUT, @c OUTPUT SELECT @a, @b, @c
--DECLARE @a int, @b varchar(100), @c int EXEC UP_UPDATE_ACCOUNT '20150679','gaeun','', @a OUTPUT, @b OUTPUT, @c OUTPUT SELECT @a, @b, @c

update TZAGrpUser	set UserID = '20150672' where  UserID = 'bzy3411'
update TZAGrpUser	set UserID = '20150669' where  UserID = 'sungddok'
update TZAGrpUser	set UserID = '20150670' where  UserID = 'asg1228'
update TZAGrpUser	set UserID = '20150673' where  UserID = 'anphoto'
update TZAGrpUser	set UserID = '20150676' where  UserID = 'doyoung'
update TZAGrpUser	set UserID = '20150679' where  UserID = 'gaeun'
update TZAGrpUser	set UserID = '20150680' where  UserID = 'hellomyhs'
update TZAGrpUser	set UserID = '20150681' where  UserID = 'lsm6015'
update TZAGrpUser	set UserID = '20150682' where  UserID = 'eightsix'
update TZAGrpUser	set UserID = '20150683' where  UserID = 'hyun40816'
update TZAGrpUser	set UserID = '20150684' where  UserID = 'pigtank'
update TZAGrpUser	set UserID = '20150685' where  UserID = 'gale15'


--3가지에 사번으로 정보가 있어야 됨. userID 가 사번으로  SP(UP_UPDATE_ACCOUNT) 실행하면 login_id 로  
-- 사번 -> 아이디  UserID
-- EmpID 는 그대로 
select * from TZAGrpUser where UserID = '20146869' 
select * from TZAGrpUser where UserID = 'sbkim' 


-- UserID 사번
select * from TZAAuthorityBasis where UserID = 'euihan.song' 
select * from TZAAuthorityBasis where UserID = 'sbkim'
select * from TZAAuthorityBasis where UserID = '20146869'

select * from TZAUserGrp where UserID = 'sbkim'
select * from TZAUserGrp where EmpID = '20146869'



-- 여기에 정보가 있으면 SP(UP_UPDATE_ACCOUNT) 실행안됨. 
select * from dbo.TZASysUser where UserID = 'sbkim'
select * from dbo.TZASysUser where UserID = 'sungddok'

-- 삭제 
begin tran
delete dbo.TZASysUser where UserID = 'ttl20100'
commit



-- 로그인 계정을 UserID 로 원복하는 문
begin tran 
update TZAGrpUser set UserID = '20146869' where  UserID = 'sbkim'
commit

begin tran 
update TZAAuthorityBasis set UserID = '20146869' where  UserID = 'sbkim'
commit

begin tran
update TZAUserGrp set UserID = '20146869' where UserId = 'sbkim'
commit

update TZASysUser set UserID = '20146869' where UserID = 'sbkim'




select * from TZAGrpUser where  UserID = 'sbkim'
select * from TZAAuthorityBasis where  UserID = 'sbkim'
select * from TZAUserGrp where  UserID = 'sbkim'
select * from TZASysUser where  UserID = 'sbkim'







-- 문화복지담당 성주미 권한 이관 문   ttl20100 권한을 sungddok 으로 
select * from TZADeptAccess where  UserID = '20146869'
select * from TZAPgmSecu where  UserID = '20146869'

update TZADeptAccess
set userid = 'sungddok'
where userid = 'ttl20100'

update TZAPgmSecu
set userid = 'sungddok'
where userid = 'ttl20100'





update TZAUserGrp	set UserID = '20150672' where  UserID = 'bzy3411'
update TZAUserGrp	set UserID = '20150669' where  UserID = 'sungddok'
update TZAUserGrp	set UserID = '20150670' where  UserID = 'asg1228'
update TZAUserGrp	set UserID = '20150673' where  UserID = 'anphoto'
update TZAUserGrp	set UserID = '20150676' where  UserID = 'doyoung'
update TZAUserGrp	set UserID = '20150679' where  UserID = 'gaeun'
update TZAUserGrp	set UserID = '20150680' where  UserID = 'hellomyhs'
update TZAUserGrp	set UserID = '20150681' where  UserID = 'lsm6015'
update TZAUserGrp	set UserID = '20150682' where  UserID = 'eightsix'
update TZAUserGrp	set UserID = '20150683' where  UserID = 'hyun40816'
update TZAUserGrp	set UserID = '20150684' where  UserID = 'pigtank'
update TZAUserGrp	set UserID = '20150685' where  UserID = 'gale15'

select * from TZAUserGrp where UserID = '20120775' 
select * from TZAUserGrp where UserID = 'doyoung' 




-- SP UP_UPDATE_ACCOUNT   잘못 실행되면 아래의 TZAUserGrp 에 정보가 지워짐. 
-- 올바른 계정정보를 넣어줌. 
begin tran 
insert into TZAUserGrp
select 
'20120775',
Pwd,
'20120775',
CustCd,
Flag,
PwdChgDate,
UseFlag,
PwdOld,
RegEmpID,
RegDate
 from TZAUserGrp where UserID = 'doyoung' 
 -- commit


-- SP UP_UPDATE_ACCOUNT   잘못 실행되면 아래의 TZAUserGrp 에 정보가 지워짐. 
-- TZAGrpUser 도 사라지므로 원복할 데이터 미리 백업 

begin tran 
insert into TZAGrpUser values ('20120775','D_32400065','batch','2014-02-28 22:30:00')
insert into TZAGrpUser values ('20120775','O_00000','batch','2014-02-28 22:30:00')
insert into TZAGrpUser values ('20120775','O_00229','batch','2014-02-28 22:30:00')
commit


insert into TZAGrpUser values ('20150676','D_32400259','','2015-08-18 20:45:00')
insert into TZAGrpUser values ('20150676','O_00000','','2015-08-18 20:45:00')
insert into TZAGrpUser values ('20150676','O_01203','','2015-08-18 20:45:00')


insert into TZAGrpUser values ('20150679','D_32400297','','2015-08-18 20:45:00')
insert into TZAGrpUser values ('20150679','O_00000','','2015-08-18 20:45:00')
insert into TZAGrpUser values ('20150679','O_00339','','2015-08-18 20:45:00')


--delete from TZAGrpUser where userid = 'gaeun'


성주미 씨 
D_32400039
O_00000
O_00122


exec SZAUserSecuMgr @pWorkingTag=N'Q',@pAffair=N'',@pPgmID=N'',@pPgmName=N'',@pPgmType=N'',@pUserID=N'sungddok'

sp_helptext SZAUserSecuMgr

Text
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*
 사용화면  : 운영관리 -> ERP 사용권한 -> 사용자 권한현황
 내용 :  개인별 ERP 소속 그룹 및  권한(사용자, 그룹, 부서)  조회
 작성자  :  이종한
 작성일  :  2008년 4월 24일     
 수정내용 :  1. 그룹 및 부서권한 조회시 업무명 틀리게 나오는 것 조정
               2.

[예제 매개변수 기록]
exec SZAUserSecuMgr 'Q', '', '', '', '', 'topleejh'
*/ 


CREATE		PROCEDURE		[dbo].[SZAUserSecuMgr]
	@pWorkingTag 		CHAR(1) = 'Q',  
	@pAffair 				CHAR(2) = '',
	@pPgmID			VARCHAR(50) = '',
	@pPgmName		NVARCHAR(100) = '',
	@pPgmType			INT = 0,
	@pUserID 			VARCHAR(20) = ''
AS  

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SELECT 	@pUserID		= ISNULL(LTRIM(RTRIM(@pUserID)), ''),  
			@pAffair 			= ISNULL(LTRIM(RTRIM(@pAffair)), ''),  
			@pPgmID	 	= ISNULL(LTRIM(RTRIM(@pPgmID)), ''),  
			@pPgmName 	= ISNULL(LTRIM(RTRIM(@pPgmName)), ''),  
			@pPgmType 	= ISNULL(@pPgmType, 0)

IF	@pWorkingTag = 'Q'
	GOTO InQueryPart
ELSE IF	@pWorkingTag = 'A'	
	GOTO SavePart

RETURN

InQueryPart:  
BEGIN
	-- 인사정보
	SELECT	ISNULL(b.EmpNm, '') AS 사원명,  
				ISNULL(b.EmpID, '') 	AS 사원번호,  
				ISNULL(c.DeptNm, '') 	AS 부서명,  
				ISNULL(b.DeptCd, '') 	AS 부서코드,  
				ISNULL(d.MinorNm, '') 	AS 조직명,  
				ISNULL(b.JpCd, '') 		AS 조직코드
	FROM  	LeCom..TZAUserGrp AS a
		INNER JOIN	(
			SELECT EmpID, EmpNm, DeptCd, '' AS JpCd
				FROM LeCom..TZAUserEmp
			UNION ALL
			SELECT EmpID, EmpNm, DeptCd, JpCd FROM LeAcc..TDAEmpMASter
		) AS b On a.EmpID = b.EmpID
		LEFT OUTER JOIN LeAcc..TDADept AS c On b.DeptCd = c.DeptCd  
		LEFT OUTER JOIN LeAcc..TDAMinor AS d On b.JpCd = d.MinorCd  
	WHERE 	a.UserID = @pUserID

	-- EKW 사용자 정보
	SELECT  	ISNULL(b.UserAccount, '')	AS 사용자ID,
				ISNULL(b.EmpID, '')		AS 사원번호,
				'' 	AS 패스워드
	FROM  	LeCom..TZAUserGrp AS a 
		INNER JOIN [EKWSQL].EKWDB.admin.TB_BASE_USER AS b On a.EmpID = b.EmpID
	WHERE 	a.UserID = @pUserID

	-- ERP 사용자 정보
	SELECT 	ISNULL(a.UserID, '')	AS 사용자ID,
				ISNULL(a.EmpID, '')		AS 사원번호,
				--ISNULL(a.Pwd, '')		AS 패스워드
				''		AS 패스워드
	FROM	LeCom..TZAUserGrp AS a
	WHERE	a.UserID = @pUserID

	-- 그룹등록현황
	SELECT	ISNULL(b.GrpSecuName, '')	AS 그룹명,
				ISNULL(a.GrpSecuID, '')	AS 그룹코드
	FROM  	LeCom..TZAGrpUser AS a
		INNER JOIN LeCom..TZAGrp AS b On a.GrpSecuID = b.GrpSecuID
	WHERE 	a.UserID = @pUserID


	-- 사용자권한
	SELECT  	
				CASE b.Affair 
						WHEN 0	THEN '운영관리'
						WHEN 1	THEN 'EIS관리'
						WHEN 2	THEN '인사관리'
						WHEN 3	THEN '급여관리'
						WHEN 4	THEN '회계관리'
						WHEN 5	THEN '영업/수출관리'
						WHEN 6	THEN '구매/수입관리'
						WHEN 7	THEN '생산관리'
						WHEN 8	THEN '자재관리'
						WHEN 9	THEN '물류관리'
						WHEN 10	THEN '관리회계'
						WHEN 11	THEN '영업모바일시스템'
						WHEN 12	THEN '용역관리'
						WHEN 13	THEN '전산투자관리'
						WHEN 14	THEN '전산관리'
						WHEN 15 THEN '지출관리' 
						WHEN 16	THEN '원가관리'
						ELSE	c.ModuleName
				END AS 업무구분, 
				ISNULL(b.Affair, '')		AS 업무ID,
				ISNULL(a.PgmID, '')	AS 폼ID,
				ISNULL(b.PgmName, '')	AS 폼명,
				ISNULL(a.Rauth, '0')	AS 읽기, 
				ISNULL(a.Aauth, '0')	AS 저장, 
				ISNULL(a.Uauth, '0')	AS 수정, 
				ISNULL(a.Dauth, '0')	AS 삭제, 
				ISNULL(a.Pauth, '0')	AS 출력, 
				ISNULL(a.Eauth, '0')	AS 엑셀,
				CASE WHEN ISNULL(a.AuthType, '0') = 0 THEN '삭제' ELSE '추가' END AS 구분,
				CASE WHEN ISNULL(Left(a.SecuAccUnit, 1), '0') = '0' THEN '소속사업장' ELSE '전체사업장' END AS 사업장읽기,
				CASE WHEN ISNULL(Right(a.SecuAccUnit, 1), '0') = '0' THEN '소속사업장' ELSE '전체사업장' END AS 사업장쓰기
	FROM  	LeCom..TZAPgmSecu AS a  
		INNER JOIN LeCom..TZAPgmCntlM AS b On a.PgmID = b.PgmID  
		INNER JOIN LeCom..TZAModule AS c On b.Affair = c.ModuleID
									
	WHERE 	a.UserID = @pUserID  
		And (@pAffair = '' Or b.Affair = @pAffair)  
		And (@pPgmType = '' Or b.PgmType = @pPgmType)
		And (@pPgmID = '' Or b.PgmID Like @pPgmID)
		And (@pPgmName = '' Or b.PgmName Like @pPgmName)
	Order By b.Affair, b.PgmName

    -- 그룹권한
	SELECT  	ISNULL(d.GrpSecuName, '')	AS 그룹명,
				ISNULL(a.GrpSecuID, '')	AS 그룹ID,
				--ISNULL(c.ModuleName, '')	AS 업무구분,
				CASE b.Affair 
						WHEN 0	THEN '운영관리'
						WHEN 1	THEN 'EIS관리'
						WHEN 2	THEN '인사관리'
						WHEN 3	THEN '급여관리'
						WHEN 4	THEN '회계관리'
						WHEN 5	THEN '영업/수출관리'
						WHEN 6	THEN '구매/수입관리'
						WHEN 7	THEN '생산관리'
						WHEN 8	THEN '자재관리'
						WHEN 9	THEN '물류관리'
						WHEN 10	THEN '관리회계'
						WHEN 11	THEN '영업모바일시스템'
						WHEN 12	THEN '용역관리'
						WHEN 13	THEN '전산투자관리'
						WHEN 14	THEN '전산관리'
						WHEN 15 THEN '지출관리' 
						WHEN 16	THEN '원가관리'
						ELSE	c.ModuleName
				END AS 업무구분, 
				ISNULL(b.Affair, '')		AS 업무ID,
				ISNULL(a.PgmID, '')	AS 폼ID,
				ISNULL(b.PgmName, '')	AS 폼명,
				ISNULL(a.Rauth, '0')	AS 읽기, 
				ISNULL(a.Aauth, '0')	AS 저장, 
				ISNULL(a.Uauth, '0')	AS 수정, 
				ISNULL(a.Dauth, '0')	AS 삭제, 
				ISNULL(a.Pauth, '0')	AS 출력, 
				ISNULL(a.Eauth, '0')	AS 엑셀,
 				CASe When ISNULL(Left(a.SecuAccUnit, 1), '0') = '0' THEN '소속사업장' ELSE '전체사업장' END AS 사업장읽기,
 				CASe When ISNULL(Right(a.SecuAccUnit, 1), '0') = '0' THEN '소속사업장' ELSE '전체사업장' END AS 사업장쓰기
    FROM  	LeCom..TZAGrpSecu AS a
		INNER JOIN LeCom..TZAPgmCntlM AS b On a.PgmID = b.PgmID  
		INNER JOIN LeCom..TZAModule AS c On b.Affair = c.ModuleID  
		INNER JOIN LeCom..TZAGrp AS d On a.GrpSecuID = d.GrpSecuID 
	WHERE  	a.GrpSecuID in (SELECT GrpSecuID FROM LeCom..TZAGrpUser WHERE UserID = @pUserID)  
		AND (@pAffair = '' Or b.Affair = @pAffair)  
		AND (@pPgmType = 0 Or b.PgmType = @pPgmType)
		AND (@pPgmID = '' Or b.PgmID Like @pPgmID)
		AND (@pPgmName = '' Or b.PgmName Like @pPgmName)
	ORDER BY a.GrpSecuID, b.Affair, b.PgmName

	-- 부서권한
	SELECT 	CASE 	When a.DeptSecuType  = 'U' THEN '사용자'
						When a.DeptSecuType  = 'G' THEN '그룹'
						END AS 권한유형,
				ISNULL(e.EmpNm, '')	AS 권한명,
				ISNULL(a.UserID, '') 	AS 권한ID,
		--		ISNULL(c.ModuleName, '')	AS 업무구분,
				CASE b.Affair 
						WHEN 0	THEN '운영관리'
						WHEN 1	THEN 'EIS관리'
						WHEN 2	THEN '인사관리'
						WHEN 3	THEN '급여관리'
						WHEN 4	THEN '회계관리'
						WHEN 5	THEN '영업/수출관리'
						WHEN 6	THEN '구매/수입관리'
						WHEN 7	THEN '생산관리'
						WHEN 8	THEN '자재관리'
						WHEN 9	THEN '물류관리'
						WHEN 10	THEN '관리회계'
						WHEN 11	THEN '영업모바일시스템'
						WHEN 12	THEN '용역관리'
						WHEN 13	THEN '전산투자관리'
						WHEN 14	THEN '전산관리'
						WHEN 15 THEN '지출관리' 
						WHEN 16	THEN '원가관리'
						ELSE	c.ModuleName
				END AS 업무구분, 
				ISNULL(b.Affair, '')		AS 업무ID,
				ISNULL(b.PgmName, '') 	AS 폼명,
				ISNULL(a.PgmID, '') 	AS 폼ID,
				CASE 	WHEN ISNULL(d.DeptNm, '') = '' THEN '소속부서' 
						ELSE ISNULL(d.DeptNm, '')
				END 	AS 부서명,
				ISNULL(a.DeptCd, '') 	AS 부서코드,
				ISNULL(a.ReadAccess, '') 	AS 읽기,
				ISNULL(a.WriteAccess, '') 	AS 쓰기
	FROM 	LeCom..
	 AS a  
		INNER JOIN 	LeCom..TZAPgmCntlM AS b On b.PgmID = a.PgmID
		INNER JOIN LeCom..TZAModule AS c On b.Affair = c.ModuleID  
		LEFT OUTER JOIN LeAcc.dbo.TDADept AS d On d.DeptCD = a.DeptCD
		INNER JOIN	(
			SELECT 	a.UserID, b.EmpNm 
			FROM 	LeCom..TZAUserGrp AS a
				INNER JOIN 	(
					SELECT EmpID, EmpNm FROM LeCom..TZAUserEmp
					UNION ALL
					SELECT EmpID, EmpNm FROM LeAcc..TDAEmpMASter
				) AS b On a.EmpID = b.EmpID
			union all
			SELECT 	GrpSecuID, GrpSecuName
			FROM	LeCom..TZAGrp
		 ) AS e On e.UserID = a.UserID
	WHERE 	(a.UserID = @pUserID Or
		a.UserID In (SELECT GrpSecuID FROM LeCom..TZAGrpUser WHERE UserID = @pUserID))
		AND (@pAffair = '' Or b.Affair = @pAffair)  
		AND (@pPgmType = '' Or b.PgmType = @pPgmType)
		AND (@pPgmID = '' Or b.PgmID Like @pPgmID)
		AND (@pPgmName = '' Or b.PgmName Like @pPgmName)
	ORDER BY a.DeptSecuType, a.UserID, b.Affair, b.PgmName

	RETURN
END
	  

SavePart:
BEGIN
	SELECT ''

	Return
END
	  



