

-- 데이터 타입
ALTER TABLE [IM].[ClosedUser] ALTER COLUMN system varchar(30)
ALTER TABLE [IM].[mst_login_log] ALTER COLUMN [wrong_cnt] smallint

-- 테이블 이름 변경
EXEC SP_RENAME '[IM].[[IM]].[user]]]','ClosedUser'


--테이블 생성
CREATE TABLE IM.mst_manage
( wrong_limit smallint not null)


-- 테이블 데이터타입 변경
ALTER TABLE [IM].[ClosedUser] ALTER COLUMN system varchar(30)



