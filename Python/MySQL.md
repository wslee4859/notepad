# DataFrame -> MySQL 
대용량으로 넣을 때 to_sql 활용  
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
