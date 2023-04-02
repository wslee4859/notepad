
--주류 공지게시판 
--select * from BD.BoardBase where boardID = '80'

-- CEO 메시지 이관 작업
select * from Bd.boardBase where boardID = '318'
select * from BD.BoardBase 
where boardID = '80' AND MigBoardIdx in 
(
'58',
'102',
'109',
'198',
'200',
'241',
'254',
'293')
order by MigBoardIdx

begin tran 
update BD.BoardBase
set BoardID = '318', IsApproval = '1', IsPortalNotice = 'N'
where boardID = '80' AND MigBoardIdx in 
(
'58',
'102',
'109',
'198',
'200',
'241',
'254',
'293')
commit


-- CEO메세지   318
--58
--102
--109
--198
--200
--241
--254
--293





-- 기획정보 이관 작업
select * from Bd.boardBase where boardID = '315'
select * from BD.BoardBase 
where boardID = '80' AND MigBoardIdx in 
(
'134',
'170',
'171',
'202',
'222',
'231',
'264')
order by MigBoardIdx

begin tran 
update BD.BoardBase
set BoardID = '315', IsApproval = '1', IsPortalNotice = 'N'
where boardID = '80' AND MigBoardIdx in 
(
'134',
'170',
'171',
'202',
'222',
'231',
'264')
commit

--기획정보   315
--134
--170
--171
--202
--222
--231
--264


-- 노무 이관 작업
select * from Bd.boardBase where boardID = '320'
select * from BD.BoardBase 
where boardID = '80' AND MigBoardIdx in 
(
'224',
'315',
'317')

order by MigBoardIdx

begin tran 
update BD.BoardBase
set BoardID = '320', IsApproval = '1', IsPortalNotice = 'N'
where boardID = '80' AND MigBoardIdx in 
(
'224',
'315',
'317')
commit


-- 법무 이관 작업
select * from Bd.boardBase where boardID = '322'
select * from BD.BoardBase 
where boardID = '80' AND MigBoardIdx in 
(
'187')
order by MigBoardIdx

begin tran 
update BD.BoardBase
set BoardID = '322', IsApproval = '1', IsPortalNotice = 'N'
where boardID = '80' AND MigBoardIdx in 
(
'187')
commit




-- 영업전략 이관 작업
select * from Bd.boardBase where boardID = '324'
select * from BD.BoardBase 
where boardID = '80' AND MigBoardIdx in 
(
'300')
order by MigBoardIdx

begin tran 
update BD.BoardBase
set BoardID = '324', IsApproval = '1', IsPortalNotice = 'N'
where boardID = '80' AND MigBoardIdx in 
(
'300')
--commit




-- 예산 이관 작업
select * from Bd.boardBase where boardID = '317'
select * from BD.BoardBase 
where boardID = '80' AND MigBoardIdx in 
(
'242','299')
order by MigBoardIdx

begin tran 
update BD.BoardBase
set BoardID = '317', IsApproval = '1', IsPortalNotice = 'N'
where boardID = '80' AND MigBoardIdx in 
(
'242','299')
--commit



-- 전산정보 이관 작업
select * from Bd.boardBase where boardID = '329'
select * from BD.BoardBase 
where boardID = '80' AND MigBoardIdx in 
(
'249')
order by MigBoardIdx

begin tran 
update BD.BoardBase
set BoardID = '329', IsApproval = '1', IsPortalNotice = 'N'
where boardID = '80' AND MigBoardIdx in 
(
'249')
--commit


-- 조직 이관 작업
select * from Bd.boardBase where boardID = '333'
select * from BD.BoardBase 
where boardID = '80' AND MigBoardIdx in 
(
'52',
'89',
'90',
'126',
'174',
'184',
'188',
'196',
'204',
'208',
'228',
'237',
'247',
'260',
'279'
)
order by MigBoardIdx

begin tran 
update BD.BoardBase
set BoardID = '333', IsApproval = '1', IsPortalNotice = 'N'
where boardID = '80' AND MigBoardIdx in 
(
'52',
'89',
'90',
'126',
'174',
'184',
'188',
'196',
'204',
'208',
'228',
'237',
'247',
'260',
'279'
)
commit

--52
--89
--90
--126
--174
--184
--188
--196
--204
--208
--228
--237
--247
--260
--279


-- 총무 이관 작업
select * from Bd.boardBase where boardID = '321'
select * from BD.BoardBase 
where boardID = '80' AND MigBoardIdx in 
(
'111',
'140',
'167',
'172',
'206',
'256',
'255',
'269',
'276',
'285',
'288',
'294',
'314',
'316'
)
order by MigBoardIdx

begin tran 
update BD.BoardBase
set BoardID = '321', IsApproval = '1', IsPortalNotice = 'N'
where boardID = '80' AND MigBoardIdx in 
(
'111',
'140',
'167',
'172',
'206',
'256',
'255',
'269',
'276',
'285',
'288',
'294',
'314',
'316'
)
commit


--111
--140
--167
--172
--206
--256
--255
--269
--276
--285
--288
--294
--314
--316





-- IsPortalNotice 업데이트 
begin tran
update  BD.BoardBase
set IsPortalNotice ='Y'
where MigBoardIdx in (
'140',
'172',
'187',
'198',
'200',
'202',
'222',
'241',
'242',
'249',
'254',
'256',
'255',
'260',
'264',
'279',
'293',
'299',
'300',
'314',
'315',
'316',
'317') AND boardID = '333'
commit

select @@trancount

select * from BD.BoardBase Where BoardID = '333'

select * from BD.BoardBase
where MigBoardIdx in (
'140',
'172',
'187',
'198',
'200',
'202',
'222',
'241',
'242',
'249',
'254',
'256',
'255',
'260',
'264',
'279',
'293',
'299',
'300',
'314',
'315',
'316',
'317') AND boardID = '333'


select * from BD.BoardInfo where BoardID='333'

update  BD.BoardInfo set BoardType='N'
where BoardID='333'


--140
--172
--187
--198
--200
--202
--222
--241
--242
--249
--254
--256
--255
--260
--264
--279
--293
--299
--300
--314
--315
--316
--317


--board ID
--315
--315
--315
--317
--317
--318
--318
--318
--318
--318
--320
--320
--321
--321
--321
--321
--321
--321
--322
--324
--329
--333
--333
