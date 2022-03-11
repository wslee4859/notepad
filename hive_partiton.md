# 파티션 조회

```
show partition partition_test;
```

# 파티션 추가
```sql

ALTER TABLE partition_test ADD PARTITION (month=5, day=1)
LOCATION '/data/partiton_test/month=5/day=1';

```

# 지정된 파티션 변경
```sql

ALTER TABLE partiton_test partition (month='3') rename to partition (month='4')

```
