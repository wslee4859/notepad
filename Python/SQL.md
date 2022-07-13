# DataFrame -> MySQL 
### 대용량으로 넣을 때 to_sql 활용  
**!!이슈 : MySQL Table 에 Unique 키, Primary 키가 있을 경우 INSERT 할 때 속도가 안나옴 ** 
RDB 테이블 생성시 키값 모두 제거하면 속도 향상!

```PYTHON 
# 현재시간 체크
now = datetime.datetime.now()
print(now)
total_start_time = time.time()

# My sql Connection 
db_connection_str = 'mysql+pymysql://msfa:msfa123!@10.120.6.192/msfa'
db_connection = create_engine(db_connection_str)
conn = db_connection.connect()

# 여러 테이블에 넣기 위한 for 문
for name in tableName :
    d_row_count = len(globals()['df_d_{}'.format(name[0])]) 
    start_time = time.time()    
    globals()['df_{}'.format(name.replace('_temp',''))].to_sql (name = name, con = conn , if_exists = 'append', index=False)
    end_time = time.time()
    print(name)
    print(str(datetime.timedelta(seconds=end_time - start_time)).split("."))
# start_time = time.time()
# df_d_product.to_sql (name = 'd_product_temp', con = conn , if_exists = 'append', index=False)
# end_time = time.time()
# print('d_product_temp : ')
# print(str(datetime.timedelta(seconds=end_time - start_time)).split("."))

# start_time = time.time()
# df_d_store.to_sql (name = 'd_store_temp', con = conn , if_exists = 'append', index=False)
# end_time = time.time()
# print('d_store_temp : ')
# print(str(datetime.timedelta(seconds=end_time - start_time)).split("."))

conn.close()

total_end_time = time.time()
print("전체소요시간 : ")
print(str(datetime.timedelta(seconds=total_end_time - total_start_time)).split("."))
```

### executemany "not enough arguments for format string" 에러 
> 원인1.   
> '%s' 파라미터 갯수가 모자를 경우 


> 원인2.   
> tuple 일 경우 에러 발생
> 아래 예시로 
> (username) 은 튜플이고, 데이터를 하나만 가지고 있기 때문에 (username, ) 로 표기하거나, [username] 또는 username 으로 표기
```
# 예시
cursor.execute('SELECT * FROM users WHERE username = %s', (username))

# 아래처럼 [  ] 감싸준다
cur.executemany(sql[1], [tuple(row)])

```

### row 한 건씩 QUERY ( INSERT ) 

executemany 를 사용할 경우 좀더 대용량 가능 (execute 대신)


[참고](https://pynative.com/python-mysql-update-data/)
```python 
chunksize = 100000
for sql in list_upd_t_query:
    start_time = time.time()
    try:
        conn = mysqlserver_pos_adaptor.mysqlserver_pos_conn()
        cur = conn.cursor()        
        df_size = len(globals()['df_t_{}'.format(sql[0])])        
        print('df_t_{} , split : {}'.format(sql[0],df_size))
        if df_size > chunksize:
            split = int(df_size/chunksize)            
            globals()['df_t_{}_split'.format(sql[0])]  = np.array_split(globals()['df_t_{}'.format(sql[0])], split)
            for i in range(split):            
                for j, row in globals()['df_t_{}_split'.format(sql[0])][i].iterrows():                    
                    cur.executemany(sql[1], [tuple(row)])
                    conn.commit()
        else:
            for i, row in globals()['df_t_{}'.format(sql[0])].iterrows():                    
                cur.executemany(sql[1], [tuple(row)])
                conn.commit()  
        cur.close()
        conn.close()        
    except Exception as e:  
        print(e)
    end_time = time.time()
    print('총소요시간 : {} '.format(str(datetime.timedelta(seconds=end_time - start_time)).split(".")))
'''

```python 
sql = '''INSERT INTO msfa.d_product_temp2
(product_id, product_no, vendor_cd, barc, category1_cd, category2_cd, category3_cd, category4_cd, category5_cd, category6_cd, category7_cd, pkg_nm, volume, sec_cd)
VALUES(%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
'''

conn = pymysql.connect(host='10.120.6.192', user = 'msfa', password = 'msfa123!', db = 'msfa')
cur = conn.cursor()

chunksize = 100000
d_row_count = len(df_d_product) 
split_count = int(d_row_count / chunksize)
print('split_count : {}'.format(split_count))
df_product_split = np.array_split(df_d_product, split_count) 
for i in range(1):
    start_time = time.time()    
    for j, row in df_product_split[i].iterrows():            
        cur.execute(sql, tuple(row))
        conn.commit()     # commit 해야 insert 가 됨.
    end_time = time.time()
    print("행 소요시간 : ")
    print(str(datetime.timedelta(seconds=end_time - start_time)).split("."))

cur.close()
conn.close()
```