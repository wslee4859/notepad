use Portal
select B.BoardID, A.Korean from BD.BoardText A
inner Join BD.BoardINfo B
on A.TextID=B.BoardID
where Boardrootid='SITE04'  -- 사이트코드






-- 신제품 정보 관리자
begin tran
insert into [PT].[ProductMng] values ('5','SITE05',null)
commit



-- 사이트별 신제품정보 게시판 리스트 가져오기 
insert into [PT].[ProductPermission] (SITEIDX, PERMISSION_SITEIDX) values ('6','6')
commit