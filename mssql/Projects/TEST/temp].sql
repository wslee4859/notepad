ALTER PROCEDURE SP_LUNCH_SELECT_V3
AS


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
				--IF((SELECT num FROM LunchMenu_week WHERE num=@Default)>=1 AND (SELECT Sort FROM LunchMenu WHERE num = @temp)>=1)
				IF(@Default>=2 AND (SELECT Sort FROM LunchMenu WHERE num = @temp)>=2)
					BEGIN
						--RAISERROR ('test1', 11, 2)
						IF((SELECT Sort FROM LunchMenu WHERE num = @temp)-(SELECT Sort FROM LunchMenu_week WHERE num = (@Default-1))=0)
							BEGIN 
								--RAISERROR ('�տ��ߺ�', 11, 2)
								SET @temp = 48
								CONTINUE
							END
					END
			END 
		--�ּ� 

--SELECT * FROM RandNum  
		UPDATE CountLunchMenu	-- CountLunchMenu ���� �̾ƿ� ������ ���� �����͸� 48�� �ٲ�
		SET Count1 = 48
		WHERE num = @temp

--SELECT * FROM LunchMenu_week
--SELECT * FROM CountLunchMenu
--SELECT * FROM LunchMenu
	IF(@Default = 1)
	BEGIN
		UPDATE LunchMenu_week
		SET Menu = (SELECT Menu FROM LunchMenu WHERE num = @temp) , Sort = (SELECT Sort FROM LunchMenu WHERE num = @temp)
		WHERE day = '��'
	END
	ELSE IF(@Default = 2)
	BEGIN
		UPDATE LunchMenu_week
		SET Menu = (SELECT Menu FROM LunchMenu WHERE num = @temp) , Sort = (SELECT Sort FROM LunchMenu WHERE num = @temp)
		WHERE day = 'ȭ'
	END
	ELSE IF(@Default = 3)
	BEGIN
		UPDATE LunchMenu_week
		SET Menu = (SELECT Menu FROM LunchMenu WHERE num = @temp) , Sort = (SELECT Sort FROM LunchMenu WHERE num = @temp)
		WHERE day = '��'
	END

	ELSE IF(@Default = 4)
	BEGIN
		UPDATE LunchMenu_week
		SET Menu = (SELECT Menu FROM LunchMenu WHERE num = @temp) , Sort = (SELECT Sort FROM LunchMenu WHERE num = @temp)
		WHERE day = '��'
	END

	ELSE IF(@Default = 5)
	BEGIN
		UPDATE LunchMenu_week
		SET Menu = (SELECT Menu FROM LunchMenu WHERE num = @temp) , Sort = (SELECT Sort FROM LunchMenu WHERE num = @temp)
		WHERE day = '��'
	END


		SET @Default = @Default + 1   -- ���� ī���� 
		
	END
-- ������ ���� 5�� �Է¹ޱ� �Ϸ�.

SELECT * FROM LunchMenu_week
