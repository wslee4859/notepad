

-- ������ Ÿ��
ALTER TABLE [IM].[ClosedUser] ALTER COLUMN system varchar(30)
ALTER TABLE [IM].[mst_login_log] ALTER COLUMN [wrong_cnt] smallint

-- ���̺� �̸� ����
EXEC SP_RENAME '[IM].[[IM]].[user]]]','ClosedUser'


--���̺� ����
CREATE TABLE IM.mst_manage
( wrong_limit smallint not null)


-- ���̺� ������Ÿ�� ����
ALTER TABLE [IM].[ClosedUser] ALTER COLUMN system varchar(30)



