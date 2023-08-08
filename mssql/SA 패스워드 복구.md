# 단일 사용자 모드에서 SA를 사용할수 있게 설정 후 패스워드 입력
### 단일 사용자 모드 실행
1. MS-SQL  SQL-SERVER 중지(서비스에서 MSSQL 서비스 중지)
2. CMD 로 MSSQL 실행파일이 있는 경로로 이동
3. 시작->실행 -> cmd -> cd C:\Program Files\Microsoft SQL Server\MSSQL10_50.MSSQLSERVER\MSSQL\Binn
4. 단일 사용자모드 실행
```cmd
sqlservr.exe -m
```

### SA Enable 및 패스워드 설정
위 단일 사용자 모드 실행 후 새 CMD 창 실행
```cmd
cd C:\Program Files\Microsoft SQL Server\MSSQL10_50.MSSQLSERVER\MSSQL\Binn
sqlcmd -E
```

![img]("sql-quri_3.jpg")

<img src="./img/sql-quri_3.jpg">






   

