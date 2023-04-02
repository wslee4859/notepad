USE TestDB 
BEGIN TRAN 
DECLARE @pChar CHAR(2) , @pMinute INT  -- 변수 선언

/****************문자 입력 ******************/
/*
'D' : 조회
'I' : 초기화
'Z' : 0 초기화
'P' : 화폐 소지 개수 늘리기

*/
SELECT @pChar = 'p'   --  문자 입력


IF @pChar = 'D'   -- 현재 아이들 소지 현황 조회
	BEGIN
		SELECT  ChildNm ,
				CNT100 AS [백원], 
				CNT500 AS [오백원], 
				CNT1000 AS [천원], 
				CNT5000 AS [오천원], 
				CNT10000 AS [만 원] , 
			   (CNT100*100 + CNT500*500 + CNT1000*1000 + CNT5000*5000 + CNT10000*10000) AS [총 금액] 
		FROM dbo.Test3_Child_이완상
	END -- 총 금액 계산
ELSE IF @pChar = 'I'   --초기화
	BEGIN
		DELETE FROM dbo.Test3_Child_이완상	   -- 행 삭제
		INSERT INTO dbo.Test3_Child_이완상 SELECT * FROM dbo.Test3_Child	 -- 테이블 재정의
	END
ELSE IF @pChar = 'Z'   -- 0으로 초기화
	BEGIN
		UPDATE dbo.Test3_Child_이완상	  -- 0 으로 업데이트 
		SET CNT100 = 0, CNT500 = 0, CNT1000 = 0, CNT5000 =0, CNT10000 = 0
	END
ELSE IF @pChar = 'P'      --모든 아이들의 화폐 소지 개수 다음과 같이 늘려주기
	BEGIN  
		SELECT @pMinute = CONVERT(INT, SUBSTRING(CONVERT(char(8), GETDATE(), 108),5,1))   -- 날짜의 '분'을 int형으로 변환하여 선언
		UPDATE dbo.Test3_Child_이완상
		SET CNT100 = CNT100 + @pMinute, CNT500 = CNT500 + @pMinute, CNT1000 = CNT1000 + @pMinute, CNT5000 = CNT5000 + @pMinute, 
			CNT10000 = CNT10000 + @pMinute

	END 
ELSE     --이외의 경우 100
	BEGIN  
		SELECT * FROM dbo.Test3_Child_이완상    
	END

/***************************-- 오류 검사 --*****************************/
IF @@ERROR > 0
	BEGIN
		SELECT '에러 발생!' AS [결과], @@Trancount AS [트랜젝션 수], @@ERROR AS [ERROR]
		ROLLBACK TRAN
	END
ELSE
	BEGIN		
		COMMIT TRAN	
		SELECT '성공!' AS [결과], @@Trancount AS [트랜젝션 수], @@ERROR AS [ERROR]	
			IF @pChar = 'D'
				BEGIN
					RETURN
				END
			ELSE   --'D'를 제외한 
				BEGIN
					SELECT ChildNm AS [이름], 
					CNT100 AS [백원], 
					CNT500 AS [오백원], 
					CNT1000 AS [천원], 
					CNT5000 AS [오천원], 
					CNT10000 AS [만 원]
				    FROM dbo.Test3_Child_이완상
				END
	END