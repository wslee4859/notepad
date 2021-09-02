### HIVE Connection

```python
from pyhive import hive

conn = hive.Connection(host = '10.120.4.100', port = 10000, username = 'hive', database = 'ods')

```

### Data select

```python
df = pd.read_sql("SELECT ugroupname as name, categoryaction  from ods.secu_webkp_v10_policy", conn) 
mst_category = pd.read_sql("SELECT categoryid, category  from ods.secu_webkp_v10_category", conn) 
```



### Hive 로 DataFrame Insert

```python
# sqlalchemy 사용
from sqlalchemy import create_engine

hosts = '10.120.4.100'
ports = 10000
username = 'hive'
database = 'ods'

#result2 dataframe 을 hive table에 insert 
# !! method 에 multi 를 선언해야 여러 row 가 들어감 !!
engine = create_engine(f'hive://hive@10.120.4.100:{ports}/{database}')
result2.to_sql(name='ods.secu_webkp_v10_category_info', con=engine, if_exists='append', index=False,method='multi')
#name 테이이블 명


```

* **sqlalchemy 사용시  이슈**

  1. **테이블 생성이 안되어서 dbeaver 로 테이블 먼저 만들어 줌**

     ```sql
     CREATE EXTERNAL TABLE IF NOT EXISTS ods.secu_webkp_v10_category_info (
     			  name varchar(256) COMMENT 'name',
     			  categoryid int COMMENT 'categoryid',  
     			  value int COMMENT 'value',
     			  value_mean varchar(10) COMMENT 'value 뜻',
     			  category varchar(255) COMMENT 'category 명' 
     );
     ```

  2. **to_sql 사용 시 method 를 'multi' 로 선언해줘야 됨.**





