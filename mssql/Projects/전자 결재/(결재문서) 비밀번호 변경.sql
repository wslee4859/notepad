-- ���繮�� �ʱ��� ��ȣ : 1   3r+RuK4yRTM=


SELECT * FROM eManage.dbo.TB_USER WHERE UserName = '������' AND UserCD = '20150671'   -- ���� ���� ���� ��ȸ

ydss




BEGIN TRAN
UPDATE eManage.dbo.TB_USER
SET ApprovalPass = '3r+RuK4yRTM='
WHERE UserName = '������' AND UserCD = '19210355'


-- COMMIT TRAN      -- commit
-- ROLLBACK TRAN    --�ѹ� 
--SELECT @@Trancount

