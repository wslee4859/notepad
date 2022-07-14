# DataFrame 특정 열에 해당되는 값 가져오기 
```python 
df.loc[df['channel_cd'] == '10']
```

# DataFrame Null 처리 
```python
# NaN -> None 처리 (MySql Insert 용)
df_t_store = df_t_store.where(pd.notnull(df_t_store), None)
```


# Dataframe 정보 
* DataFrame.info()  
  데이터프레임 컬럼 타입 정보 들
* DataFrame.shape  
  데이터프레임 row, columns 수

# Merge
1. df3 = df1.merge(df2, on = ken, how = 'left')
2. df3 = pd.merge(df1, df2, on = key, how = 'left')

### Merge 할 때 You are trying to merge on object and int64 columns 오류나는 경우  
두 DataFrame 간의 Dtype 이 일치하지 않기 때문에 발생  
Tip.   데이터 가져올 때 dtype 선언
```python
# hdfs T Master read 
hdfs = hdfs_adaptor.hdfs_conn()
with hdfs.read(hdfs_path + hdfs_filename , encoding = 'utf-8') as data:
    df_T_PRODUCT_hdfs = pd.read_csv(data, header = 0, delimiter = '', engine = 'python', dtype = object)
    
data.close()
```



# DataFrame 변수명을 loop로 받아서 처리

[참고]

https://velog.io/@paori/python-%EB%8F%99%EC%A0%81-%EB%B3%80%EC%88%98-%EC%9E%90%EB%8F%99-%EB%B3%80%EC%88%98-%EC%83%9D%EC%84%B1

https://blog.naver.com/nomadgee/220857820094

Example
```python

# MASTER Qry
sql_tstore = '''SELECT store_id, channel_cd, dist_cd, store_cd, store_nm, store_cd_origin, store_nm_origin, sido, sigungu, latitude, longitude, zipcode, addr_road, addr_jibun, direct, setdate
FROM msfa.t_store;
'''

sql_tvendor = '''SELECT vendor_cd, sec_cd, vendor, row_no
FROM msfa.t_vendor;
'''

sql_tcategory = '''SELECT category_cd, category, lv, up_category_cd, sec_cd
FROM msfa.t_category;
'''

sql_tproduct ='''SELECT product_no, vendor_cd, barc, product, category1_cd, category2_cd, category3_cd, category4_cd, category5_cd, category6_cd, category7_cd, pkg_nm, volume, count, promotion, sec_cd, setdate
FROM msfa.t_product;
'''

list_sql = [['T_STORE',sql_tstore], ['T_VENDOR',sql_tvendor], ['T_CATEGORY',sql_tcategory], ['T_PRODUCT',sql_tproduct]]

conn = pymysql.connect(host='10.120.6.192', user = 'msfa', password = 'msfa123!', db = 'msfa')
cur = conn.cursor()
for sql in list_sql:
    cur.execute(sql[1])
    result = cur.fetchall()
    columns = cur.description
    
    columns_name = np.array(columns).T[0]
    globals()['df_{}'.format(sql[0])] = pd.DataFrame(result, columns=columns_name)
```
