-- 결재문서 초기비밀 번호 : 1   3r+RuK4yRTM=


SELECT * FROM eManage.dbo.TB_USER WHERE UserName = '허은정' AND UserCD = '20150671'   -- 변경 유저 정보 조회

ydss




BEGIN TRAN
UPDATE eManage.dbo.TB_USER
SET ApprovalPass = '3r+RuK4yRTM='
WHERE UserName = '유병수' AND UserCD = '19210355'


-- COMMIT TRAN      -- commit
-- ROLLBACK TRAN    --롤백 
--SELECT @@Trancount

