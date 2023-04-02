ALTER PROCEDURE SP_LUNCH_SELECT
AS
EXEC SP_LUNCH_SETTING

-- ���� ����
DECLARE @temp INT , @Default INT, @RAND INT, @CountMenu INT
SET @CountMenu = (SELECT COUNT(Menu) FROM LunchMenu)    -- ���ɸ޴� ���� 
SET @Default = 1
WHILE (@Default <= 5)
	BEGIN
		SET @RAND = CONVERT(INT, ROUND((RAND() * (@CountMenu-1))+1, 0))	  -- ���尪 ����� �� 
		SET @temp = (SELECT Count1 FROM CountLunchMenu WHERE num = @RAND )  -- CountLunchMenu �� ������ 
		WHILE(@temp = 48)    --48 �� �ȳ��ö� ����  ��� ����
			BEGIN
				SET @temp = (SELECT Count1 FROM CountLunchMenu WHERE num = ROUND((RAND() * (@CountMenu-1))+1, 0)) 
			END 
		--�ּ� 

		
		UPDATE RandNum			-- RandNum ���̺��� �ߺ����� �ʴ� ������ �� �Է�  5����
		SET RandNum = @temp
		WHERE num = @Default
--SELECT * FROM RandNum    
		UPDATE CountLunchMenu	-- CountLunchMenu ���� �̾ƿ� ������ ���� �����͸� 48�� �ٲ�
		SET Count1 = 48
		WHERE num = @temp

		SET @Default = @Default + 1
	END
-- ������ ���� 5�� �Է¹ޱ� �Ϸ�.

UPDATE LunchMenu_week
SET Menu = (SELECT Menu FROM LunchMenu WHERE num = (SELECT RandNum FROM RandNum WHERE num =1))
WHERE day = '��'

UPDATE LunchMenu_week
SET Menu = (SELECT Menu FROM LunchMenu WHERE num = (SELECT RandNum FROM RandNum WHERE num =2))
WHERE day = 'ȭ'

UPDATE LunchMenu_week
SET Menu = (SELECT Menu FROM LunchMenu WHERE num = (SELECT RandNum FROM RandNum WHERE num =3))
WHERE day = '��'

UPDATE LunchMenu_week
SET Menu = (SELECT Menu FROM LunchMenu WHERE num = (SELECT RandNum FROM RandNum WHERE num =4))
WHERE day = '��'

UPDATE LunchMenu_week
SET Menu = (SELECT Menu FROM LunchMenu WHERE num = (SELECT RandNum FROM RandNum WHERE num =5))
WHERE day = '��'

SELECT * FROM LunchMenu_week

