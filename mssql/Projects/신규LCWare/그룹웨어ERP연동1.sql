80�� ���Ի�� ���.
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
--SELECT 'A'    -- ���⼭ @pWorkingTag = 'A' ��. �׷캰 ����� �߰��̱� ������
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


--3������ ������� ������ �־�� ��. userID �� �������  SP(UP_UPDATE_ACCOUNT) �����ϸ� login_id ��  
-- ��� -> ���̵�  UserID
-- EmpID �� �״�� 
select * from TZAGrpUser where UserID = '20146869' 
select * from TZAGrpUser where UserID = 'sbkim' 


-- UserID ���
select * from TZAAuthorityBasis where UserID = 'euihan.song' 
select * from TZAAuthorityBasis where UserID = 'sbkim'
select * from TZAAuthorityBasis where UserID = '20146869'

select * from TZAUserGrp where UserID = 'sbkim'
select * from TZAUserGrp where EmpID = '20146869'



-- ���⿡ ������ ������ SP(UP_UPDATE_ACCOUNT) ����ȵ�. 
select * from dbo.TZASysUser where UserID = 'sbkim'
select * from dbo.TZASysUser where UserID = 'sungddok'

-- ���� 
begin tran
delete dbo.TZASysUser where UserID = 'ttl20100'
commit



-- �α��� ������ UserID �� �����ϴ� ��
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







-- ��ȭ������� ���ֹ� ���� �̰� ��   ttl20100 ������ sungddok ���� 
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




-- SP UP_UPDATE_ACCOUNT   �߸� ����Ǹ� �Ʒ��� TZAUserGrp �� ������ ������. 
-- �ùٸ� ���������� �־���. 
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


-- SP UP_UPDATE_ACCOUNT   �߸� ����Ǹ� �Ʒ��� TZAUserGrp �� ������ ������. 
-- TZAGrpUser �� ������Ƿ� ������ ������ �̸� ��� 

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


���ֹ� �� 
D_32400039
O_00000
O_00122


exec SZAUserSecuMgr @pWorkingTag=N'Q',@pAffair=N'',@pPgmID=N'',@pPgmName=N'',@pPgmType=N'',@pUserID=N'sungddok'

sp_helptext SZAUserSecuMgr

Text
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*
 ���ȭ��  : ����� -> ERP ������ -> ����� ������Ȳ
 ���� :  ���κ� ERP �Ҽ� �׷� ��  ����(�����, �׷�, �μ�)  ��ȸ
 �ۼ���  :  ������
 �ۼ���  :  2008�� 4�� 24��     
 �������� :  1. �׷� �� �μ����� ��ȸ�� ������ Ʋ���� ������ �� ����
               2.

[���� �Ű����� ���]
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
	-- �λ�����
	SELECT	ISNULL(b.EmpNm, '') AS �����,  
				ISNULL(b.EmpID, '') 	AS �����ȣ,  
				ISNULL(c.DeptNm, '') 	AS �μ���,  
				ISNULL(b.DeptCd, '') 	AS �μ��ڵ�,  
				ISNULL(d.MinorNm, '') 	AS ������,  
				ISNULL(b.JpCd, '') 		AS �����ڵ�
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

	-- EKW ����� ����
	SELECT  	ISNULL(b.UserAccount, '')	AS �����ID,
				ISNULL(b.EmpID, '')		AS �����ȣ,
				'' 	AS �н�����
	FROM  	LeCom..TZAUserGrp AS a 
		INNER JOIN [EKWSQL].EKWDB.admin.TB_BASE_USER AS b On a.EmpID = b.EmpID
	WHERE 	a.UserID = @pUserID

	-- ERP ����� ����
	SELECT 	ISNULL(a.UserID, '')	AS �����ID,
				ISNULL(a.EmpID, '')		AS �����ȣ,
				--ISNULL(a.Pwd, '')		AS �н�����
				''		AS �н�����
	FROM	LeCom..TZAUserGrp AS a
	WHERE	a.UserID = @pUserID

	-- �׷�����Ȳ
	SELECT	ISNULL(b.GrpSecuName, '')	AS �׷��,
				ISNULL(a.GrpSecuID, '')	AS �׷��ڵ�
	FROM  	LeCom..TZAGrpUser AS a
		INNER JOIN LeCom..TZAGrp AS b On a.GrpSecuID = b.GrpSecuID
	WHERE 	a.UserID = @pUserID


	-- ����ڱ���
	SELECT  	
				CASE b.Affair 
						WHEN 0	THEN '�����'
						WHEN 1	THEN 'EIS����'
						WHEN 2	THEN '�λ����'
						WHEN 3	THEN '�޿�����'
						WHEN 4	THEN 'ȸ�����'
						WHEN 5	THEN '����/�������'
						WHEN 6	THEN '����/���԰���'
						WHEN 7	THEN '�������'
						WHEN 8	THEN '�������'
						WHEN 9	THEN '��������'
						WHEN 10	THEN '����ȸ��'
						WHEN 11	THEN '��������Ͻý���'
						WHEN 12	THEN '�뿪����'
						WHEN 13	THEN '�������ڰ���'
						WHEN 14	THEN '�������'
						WHEN 15 THEN '�������' 
						WHEN 16	THEN '��������'
						ELSE	c.ModuleName
				END AS ��������, 
				ISNULL(b.Affair, '')		AS ����ID,
				ISNULL(a.PgmID, '')	AS ��ID,
				ISNULL(b.PgmName, '')	AS ����,
				ISNULL(a.Rauth, '0')	AS �б�, 
				ISNULL(a.Aauth, '0')	AS ����, 
				ISNULL(a.Uauth, '0')	AS ����, 
				ISNULL(a.Dauth, '0')	AS ����, 
				ISNULL(a.Pauth, '0')	AS ���, 
				ISNULL(a.Eauth, '0')	AS ����,
				CASE WHEN ISNULL(a.AuthType, '0') = 0 THEN '����' ELSE '�߰�' END AS ����,
				CASE WHEN ISNULL(Left(a.SecuAccUnit, 1), '0') = '0' THEN '�Ҽӻ����' ELSE '��ü�����' END AS ������б�,
				CASE WHEN ISNULL(Right(a.SecuAccUnit, 1), '0') = '0' THEN '�Ҽӻ����' ELSE '��ü�����' END AS ����徲��
	FROM  	LeCom..TZAPgmSecu AS a  
		INNER JOIN LeCom..TZAPgmCntlM AS b On a.PgmID = b.PgmID  
		INNER JOIN LeCom..TZAModule AS c On b.Affair = c.ModuleID
									
	WHERE 	a.UserID = @pUserID  
		And (@pAffair = '' Or b.Affair = @pAffair)  
		And (@pPgmType = '' Or b.PgmType = @pPgmType)
		And (@pPgmID = '' Or b.PgmID Like @pPgmID)
		And (@pPgmName = '' Or b.PgmName Like @pPgmName)
	Order By b.Affair, b.PgmName

    -- �׷����
	SELECT  	ISNULL(d.GrpSecuName, '')	AS �׷��,
				ISNULL(a.GrpSecuID, '')	AS �׷�ID,
				--ISNULL(c.ModuleName, '')	AS ��������,
				CASE b.Affair 
						WHEN 0	THEN '�����'
						WHEN 1	THEN 'EIS����'
						WHEN 2	THEN '�λ����'
						WHEN 3	THEN '�޿�����'
						WHEN 4	THEN 'ȸ�����'
						WHEN 5	THEN '����/�������'
						WHEN 6	THEN '����/���԰���'
						WHEN 7	THEN '�������'
						WHEN 8	THEN '�������'
						WHEN 9	THEN '��������'
						WHEN 10	THEN '����ȸ��'
						WHEN 11	THEN '��������Ͻý���'
						WHEN 12	THEN '�뿪����'
						WHEN 13	THEN '�������ڰ���'
						WHEN 14	THEN '�������'
						WHEN 15 THEN '�������' 
						WHEN 16	THEN '��������'
						ELSE	c.ModuleName
				END AS ��������, 
				ISNULL(b.Affair, '')		AS ����ID,
				ISNULL(a.PgmID, '')	AS ��ID,
				ISNULL(b.PgmName, '')	AS ����,
				ISNULL(a.Rauth, '0')	AS �б�, 
				ISNULL(a.Aauth, '0')	AS ����, 
				ISNULL(a.Uauth, '0')	AS ����, 
				ISNULL(a.Dauth, '0')	AS ����, 
				ISNULL(a.Pauth, '0')	AS ���, 
				ISNULL(a.Eauth, '0')	AS ����,
 				CASe When ISNULL(Left(a.SecuAccUnit, 1), '0') = '0' THEN '�Ҽӻ����' ELSE '��ü�����' END AS ������б�,
 				CASe When ISNULL(Right(a.SecuAccUnit, 1), '0') = '0' THEN '�Ҽӻ����' ELSE '��ü�����' END AS ����徲��
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

	-- �μ�����
	SELECT 	CASE 	When a.DeptSecuType  = 'U' THEN '�����'
						When a.DeptSecuType  = 'G' THEN '�׷�'
						END AS ��������,
				ISNULL(e.EmpNm, '')	AS ���Ѹ�,
				ISNULL(a.UserID, '') 	AS ����ID,
		--		ISNULL(c.ModuleName, '')	AS ��������,
				CASE b.Affair 
						WHEN 0	THEN '�����'
						WHEN 1	THEN 'EIS����'
						WHEN 2	THEN '�λ����'
						WHEN 3	THEN '�޿�����'
						WHEN 4	THEN 'ȸ�����'
						WHEN 5	THEN '����/�������'
						WHEN 6	THEN '����/���԰���'
						WHEN 7	THEN '�������'
						WHEN 8	THEN '�������'
						WHEN 9	THEN '��������'
						WHEN 10	THEN '����ȸ��'
						WHEN 11	THEN '��������Ͻý���'
						WHEN 12	THEN '�뿪����'
						WHEN 13	THEN '�������ڰ���'
						WHEN 14	THEN '�������'
						WHEN 15 THEN '�������' 
						WHEN 16	THEN '��������'
						ELSE	c.ModuleName
				END AS ��������, 
				ISNULL(b.Affair, '')		AS ����ID,
				ISNULL(b.PgmName, '') 	AS ����,
				ISNULL(a.PgmID, '') 	AS ��ID,
				CASE 	WHEN ISNULL(d.DeptNm, '') = '' THEN '�ҼӺμ�' 
						ELSE ISNULL(d.DeptNm, '')
				END 	AS �μ���,
				ISNULL(a.DeptCd, '') 	AS �μ��ڵ�,
				ISNULL(a.ReadAccess, '') 	AS �б�,
				ISNULL(a.WriteAccess, '') 	AS ����
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
	  



