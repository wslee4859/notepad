ALTER PROCEDURE SP_LUNCH_SELECT_V3
AS


-- 변수 선언
DECLARE @temp INT , @Default INT, @RAND INT, @CountMenu INT 
SET @CountMenu = (SELECT COUNT(Menu) FROM LunchMenu)    -- 점심메뉴 갯수 
SET @Default = 1


WHILE (@Default <= 5)
	BEGIN
		SET @RAND = CONVERT(INT, ROUND((RAND() * (@CountMenu-1))+1, 0))	  -- 랜드값 만드는 곳 
		SET @temp = (SELECT Count1 FROM CountLunchMenu WHERE num = @RAND )  -- CountLunchMenu 의 데이터 
		WHILE(@temp = 48)    --48 이 안나올때 까지  계속 실행
			BEGIN
				SET @temp = (SELECT Count1 FROM CountLunchMenu WHERE num = ROUND((RAND() * (@CountMenu-1))+1, 0)) 
				--IF((SELECT num FROM LunchMenu_week WHERE num=@Default)>=1 AND (SELECT Sort FROM LunchMenu WHERE num = @temp)>=1)
				IF(@Default>=2 AND (SELECT Sort FROM LunchMenu WHERE num = @temp)>=2)
					BEGIN
						--RAISERROR ('test1', 11, 2)
						IF((SELECT Sort FROM LunchMenu WHERE num = @temp)-(SELECT Sort FROM LunchMenu_week WHERE num = (@Default-1))=0)
							BEGIN 
								--RAISERROR ('앞에중복', 11, 2)
								SET @temp = 48
								CONTINUE
							END
					END
			END 
		--최소 

--SELECT * FROM RandNum  
		UPDATE CountLunchMenu	-- CountLunchMenu 에서 뽑아온 데이터 행의 데이터를 48로 바꿈
		SET Count1 = 48
		WHERE num = @temp

--SELECT * FROM LunchMenu_week
--SELECT * FROM CountLunchMenu
--SELECT * FROM LunchMenu
	IF(@Default = 1)
	BEGIN
		UPDATE LunchMenu_week
		SET Menu = (SELECT Menu FROM LunchMenu WHERE num = @temp) , Sort = (SELECT Sort FROM LunchMenu WHERE num = @temp)
		WHERE day = '월'
	END
	ELSE IF(@Default = 2)
	BEGIN
		UPDATE LunchMenu_week
		SET Menu = (SELECT Menu FROM LunchMenu WHERE num = @temp) , Sort = (SELECT Sort FROM LunchMenu WHERE num = @temp)
		WHERE day = '화'
	END
	ELSE IF(@Default = 3)
	BEGIN
		UPDATE LunchMenu_week
		SET Menu = (SELECT Menu FROM LunchMenu WHERE num = @temp) , Sort = (SELECT Sort FROM LunchMenu WHERE num = @temp)
		WHERE day = '수'
	END

	ELSE IF(@Default = 4)
	BEGIN
		UPDATE LunchMenu_week
		SET Menu = (SELECT Menu FROM LunchMenu WHERE num = @temp) , Sort = (SELECT Sort FROM LunchMenu WHERE num = @temp)
		WHERE day = '목'
	END

	ELSE IF(@Default = 5)
	BEGIN
		UPDATE LunchMenu_week
		SET Menu = (SELECT Menu FROM LunchMenu WHERE num = @temp) , Sort = (SELECT Sort FROM LunchMenu WHERE num = @temp)
		WHERE day = '금'
	END


		SET @Default = @Default + 1   -- 요일 카운터 
		
	END
-- 랜덤한 숫자 5개 입력받기 완료.

SELECT * FROM LunchMenu_week
