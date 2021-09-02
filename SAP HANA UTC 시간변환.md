## SAP HANA UTC 변경

날짜형식이 아닌 string 형태를 UTC 형태로 변경 

https://stackoverflow.com/questions/66934874/time-zone-conversion-between-utc-and-local-time-possibly-daylight-saving

```sql
-- DATUM 20210827 
-- ZEIT  153000

-- 날짜 시간을 catcat 한 후 timestamp 형식으로 바꿈
to_seconddate(CONCAT(DATUM, ZEIT), 'YYYYMMDDHHMISS') as DATE_TIME_UTC

-- to_seconddate 
UTCTOLOCAL(TO_TIMESTAMP(to_seconddate(CONCAT(DATUM, ZEIT), 'YYYYMMDDHHMISS'), 'YYYY-MM-DD HH24:MI:SS'), 'KST') 


-- add_seconds 32400 s (9시간)
add_seconds(to_seconddate(CONCAT(DATUM, ZEIT), 'YYYYMMDDHHMISS'), 32400) as UTC_DATE_TIME


-ex)
SELECT datum, zeit
,add_seconds(to_seconddate(CONCAT(DATUM, ZEIT), 'YYYYMMDDHHMISS'), 32400) as UTC_DATE_TIME
FROM RSPCLOGCHAIN WHERE CHAIN_ID = 'Z1USD_TRAN_H_01'
	AND DATUM > '20210824'
ORDER BY datum, zeit;

```

**!UTCTOLOCAL  Function 을 사용하려고 했으나 'KST' timezone 이 오류가 나서 (dbeaver 에서) timezone 초를 더해줌**











### SAP HANA timezone 찾기

```sql
select * from M_HOST_INFORMATION where upper(KEY) like '%TIMEZONE%';

```



