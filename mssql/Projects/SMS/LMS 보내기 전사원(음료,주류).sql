		
			
		USE SMS_SYSTEM

		DROP TABLE #UserList
	
		CREATE TABLE #UserList
		(
			seq	int identity(1,1),
			tran_phone VARCHAR(15)
		)

		INSERT INTO #UserList (tran_phone) 
		SELECT Replace(LTRIM(mobile),'-','')
		FROM [10.103.1.108].[im80].[dbo].[org_user]
		WHERE code IN ('19026', '13097')
		--WHERE mobile is not null AND len(mobile) > 9 AND status = '1'


		
		DECLARE @Count		 int,
				@CountNum	 int,
				@tran_phone  varchar(15),
				@tran_msg	 varchar(2000)
		SET @Count = ( select top 1 seq from #UserList order by seq desc )
		SET @CountNum = 1
		WHILE(@Count >= @CountNum)
			BEGIN
				set @tran_phone = (select tran_phone from #UserList where seq = @CountNum)
				EXEC SMS_SYSTEM.SLMSTEST '[보안]랜섬웨어 대응', '1. 증상 : PC 내 파일 암호화(파일명 끝에 .WCRY)
					2. 조치 : 보안패치 미적용 PC 인터넷 차단 정책
					PC감염 의심시 랜선 분리 후 전산팀 문의

					※문의처 : 전산담당 (02-6424-7414,7416)'
					 , @tran_phone ,'0234799230'
				SET @CountNum = @CountNum + 1
			END