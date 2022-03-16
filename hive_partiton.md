[참고사이트](https://datalibrary.tistory.com/167)


# 파티션 조회

```
show partition [table명];
```

# 파티션 테이블 생성
```

CREATE EXTERNAL TABLE tb_sample (
    userid string
    , createDateTime bigint
)
PARTITIONED BY (month int, day int) -- 다중 레벨 파티션
-- PARTITIONED BY (ymd STRING) -- 단일 파티션
STORED AS PARQUET
LOCATION '/data/partition_test'
;


```


# 파티션 추가
```sql

ALTER TABLE partition_test ADD PARTITION (month=5, day=1)
LOCATION '/data/partiton_test/month=5/day=1';

```

# 파티션 삭제
```

--파티션 범위 제거
ALTER TABLE partition_test DROP PARTITION (day > '15', dates < '17');

```


# 지정된 파티션 변경
```sql

ALTER TABLE partiton_test partition (month='3') rename to partition (month='4')

```
