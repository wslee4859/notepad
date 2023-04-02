USE TestDB 
BEGIN TRAN 
DECLARE @pChar CHAR(2) , @pMinute INT  -- ���� ����

/****************���� �Է� ******************/
/*
'D' : ��ȸ
'I' : �ʱ�ȭ
'Z' : 0 �ʱ�ȭ
'P' : ȭ�� ���� ���� �ø���

*/
SELECT @pChar = 'p'   --  ���� �Է�


IF @pChar = 'D'   -- ���� ���̵� ���� ��Ȳ ��ȸ
	BEGIN
		SELECT  ChildNm ,
				CNT100 AS [���], 
				CNT500 AS [�����], 
				CNT1000 AS [õ��], 
				CNT5000 AS [��õ��], 
				CNT10000 AS [�� ��] , 
			   (CNT100*100 + CNT500*500 + CNT1000*1000 + CNT5000*5000 + CNT10000*10000) AS [�� �ݾ�] 
		FROM dbo.Test3_Child_�̿ϻ�
	END -- �� �ݾ� ���
ELSE IF @pChar = 'I'   --�ʱ�ȭ
	BEGIN
		DELETE FROM dbo.Test3_Child_�̿ϻ�	   -- �� ����
		INSERT INTO dbo.Test3_Child_�̿ϻ� SELECT * FROM dbo.Test3_Child	 -- ���̺� ������
	END
ELSE IF @pChar = 'Z'   -- 0���� �ʱ�ȭ
	BEGIN
		UPDATE dbo.Test3_Child_�̿ϻ�	  -- 0 ���� ������Ʈ 
		SET CNT100 = 0, CNT500 = 0, CNT1000 = 0, CNT5000 =0, CNT10000 = 0
	END
ELSE IF @pChar = 'P'      --��� ���̵��� ȭ�� ���� ���� ������ ���� �÷��ֱ�
	BEGIN  
		SELECT @pMinute = CONVERT(INT, SUBSTRING(CONVERT(char(8), GETDATE(), 108),5,1))   -- ��¥�� '��'�� int������ ��ȯ�Ͽ� ����
		UPDATE dbo.Test3_Child_�̿ϻ�
		SET CNT100 = CNT100 + @pMinute, CNT500 = CNT500 + @pMinute, CNT1000 = CNT1000 + @pMinute, CNT5000 = CNT5000 + @pMinute, 
			CNT10000 = CNT10000 + @pMinute

	END 
ELSE     --�̿��� ��� 100
	BEGIN  
		SELECT * FROM dbo.Test3_Child_�̿ϻ�    
	END

/***************************-- ���� �˻� --*****************************/
IF @@ERROR > 0
	BEGIN
		SELECT '���� �߻�!' AS [���], @@Trancount AS [Ʈ������ ��], @@ERROR AS [ERROR]
		ROLLBACK TRAN
	END
ELSE
	BEGIN		
		COMMIT TRAN	
		SELECT '����!' AS [���], @@Trancount AS [Ʈ������ ��], @@ERROR AS [ERROR]	
			IF @pChar = 'D'
				BEGIN
					RETURN
				END
			ELSE   --'D'�� ������ 
				BEGIN
					SELECT ChildNm AS [�̸�], 
					CNT100 AS [���], 
					CNT500 AS [�����], 
					CNT1000 AS [õ��], 
					CNT5000 AS [��õ��], 
					CNT10000 AS [�� ��]
				    FROM dbo.Test3_Child_�̿ϻ�
				END
	END