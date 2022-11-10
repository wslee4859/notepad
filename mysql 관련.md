## 데이터베이스 테이블 사이즈, ROW 건 수 확인

### 데이터베이스 ROW Count 확인
```
SELECT
    table_name,
    table_rows
FROM
    information_schema.tables
WHERE table_schema = 'lcsposdb'
ORDER BY table_name;
```
### 데이터베이스 테이블 사이즈 확인
데이터베이스별 용량 (Database Size) 조회
```
SELECT table_schema AS 'DatabaseName',
                ROUND(SUM(data_length+index_length)/1024/1024, 1) AS 'Size(MB)'
FROM information_schema.tables
GROUP BY table_schema
ORDER BY 2 DESC;
```
전체 용량 (Total Size) 조회
```
SELECT ROUND(SUM(data_length+index_length)/1024/1024, 1) AS 'Used(MB)',
                 ROUND(SUM(data_free)/1024/1024, 1) AS 'Free(MB)'
FROM information_schema.tables;
```
테이블별 용량 (Table Size) 조회
```
SELECT table_name AS 'TableName',
                 ROUND(SUM(data_length+index_length)/(1024*1024), 2) AS 'All(MB)',
                 ROUND(data_length/(1024*1024), 2) AS 'Data(MB)',
                 ROUND(index_length/(1024*1024), 2) AS 'Index(MB)'
FROM information_schema.tables
GROUP BY table_name
ORDER BY data_length DESC; 
```

## My SQL Stored procedure 에서 변수명으로 객체 이름 받기

MySQL에서 Stored procedure를 이용해 테이블명, 필드명 등을 인자로 받아 활용하는 방법입니다.

우선 완성된 코드입니다. 대략 설명드리면, 어떤 테이블에 한 열을 집어 넣고, 방금 집어 넣은 열의 Primary key 값을 받아오는 역할을 합니다.

```
DROP PROCEDURE IF EXISTS `getLastInsert`;
DELIMITER $$
CREATE PROCEDURE `getLastInsert `(IN TB_NAME VARCHAR(50))
BEGIN
	DECLARE tt INT;
	SET @i := concat("INSERT INTO ", TB_NAME, " values();");
	PREPARE stmt FROM @i;
	execute stmt;
	SET @s := concat("SELECT @a := last_insert_id() FROM ", TB_NAME, ' LIMIT 1');
	PREPARE stmt FROM @s;
	execute stmt;
	SELECT @a into tt;
END
$$
```

인자로 테이블이름을 받더라도 이 MySQL에서 테이블이름을 바로 활용하기는 어렵습니다. 코드 상에서  TB_NAME이라는  글자를 변수로 인식하지 않고 TB_NAME이라는 개체(테이블명 혹은 필드명)으로 인식해버리기 때문입니다. 이 경우를 우회하기 위해 쿼리를 문자열 형식으로 받아 실행해주는 것 작업이 필요합니다.

그래서 concat()함수를 통해 문자열을 붙이고, prepare와 execute명령으로 이 쿼리를 실행시켜주는 방법을 쓰게 되었습니다.

사실은 제 일은 아니고 다른 분일을 도와드린 거라는거 .. 덕분에 좋은 것 배웠습니다.



출처: https://elco.tistory.com/entry/MySQL-Stored-procedure에서-변수명으로-객체이름-받기 [ElegantCoder::blog();]



### MY SQL 인덱스 조회

```
#인덱스 확인/삭제
SHOW INDEX FROM shell_user_01;
DROP INDEX `PRIMARY` ON tbl_name;
ALTER TABLE tbl_name DROP INDEX PRIMARY;
```



### 테이블 인코딩 확인법

```sql
SELECT CCSA.character_set_name FROM information_schema.`TABLES` T,
       information_schema.`COLLATION_CHARACTER_SET_APPLICABILITY` CCSA
WHERE CCSA.collation_name = T.table_collation
  AND T.table_schema = "mydb"
  AND T.table_name = "mytable";
```



### MY SQL 한글 인코딩 변경

```sql
	convert(cast(U.`ldap_tel` as BINARY) using euckr) as ldap_tel,
	convert(cast(C.`cmd` as BINARY) using euckr) as cmd,
	convert(cast(C.`rtn` as BINARY) using euckr) as rtn,
```

















