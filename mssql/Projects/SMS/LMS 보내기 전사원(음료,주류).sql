		
			
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
				EXEC SMS_SYSTEM.SLMSTEST '[����]�������� ����', '1. ���� : PC �� ���� ��ȣȭ(���ϸ� ���� .WCRY)
					2. ��ġ : ������ġ ������ PC ���ͳ� ���� ��å
					PC���� �ǽɽ� ���� �и� �� ������ ����

					�ع���ó : ������ (02-6424-7414,7416)'
					 , @tran_phone ,'0234799230'
				SET @CountNum = @CountNum + 1
			END