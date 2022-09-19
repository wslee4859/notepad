

# DataFrame 특정 열에 해당되는 값 가져오기 
```python 
#1
df.loc[df['channel_cd'] == '10']

#2
df[df['row_no']==9999]
```

# DataFrame Null 처리 
```python
# NaN -> None 처리 (MySql Insert 용)
df_t_store = df_t_store.where(pd.notnull(df_t_store), None)
```

### DataFrame  컬럼 별 null 갯수 확인
> 각 Columns 별로 null 갯수가 display
```
np.sum(pd.isnull(df))
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



# Query Table 필드명으로 Dataframe column 명 설정

cur.description 사용

```python
conn = hive.Connection(host='10.120.4.100', port=10000, username='hive', database='ods')
cur = conn.cursor()
cur.execute(query)
result = cur.fetchall()
columns = cur.description

cur.close()
conn.close()

# 1. for문 사용 방법
column_list = []
for i in range(0, len(columns)):
    column_list.append(columns[int(i)][0])
df = pd.DataFrame(result, columns=column_list)

# 2. numpy 사용 방법
import numpy as np
columns_name = np.array(columns).T[0]
df = pd.DataFrame(result, columns=columns_name)

#. 3
columnNames = [column[0] for column in cursor.description]
## DataFrame
return pd.DataFrame(cursor.fetchall(), columns=columnNames)
```




# Dataframe rename

* dataframe.rename(columns = {0:'BARCODE'})  

### 동일한 컬럼의 DataFrame Columns 명으로 넣기
```python 
df2.columns = df1.columns
```



# Dataframe Series 의 True 값만 가져오기

* loc[series, :]

``` python 
# 중복값 찾아서 
dup = df.duplicated([0], keep = False)
# 중복값만 추출
df_dup = df.loc[dup, :]
```


# DataFrame 중복

[문서](https://pandas.pydata.org/docs/reference/api/pandas.DataFrame.duplicated.html)

keep='first' 이면 중복 행 중 첫번째 행만 False, 나머지 행은 True.  
keep='last' 이면 중복 행 중 마지막 행만 False, 나머지 행은 False.  
keep=False 이면 중복 행 모두 True를 반환.  

* dataframe.duplicated([column명], keep = False) 

> * Index.duplicated  
>Equivalent method on index.
> * Series.duplicated  
>Equivalent method on Series.
> * Series.drop_duplicates  
>Remove duplicate values from Series.
> * DataFrame.drop_duplicates  
>Remove duplicate values from DataFrame.

### 중복 아닌값 가져오기 
```python 
date_list = df['SALES_DATE'].unique()
date_list_sort = sorted(date_list)
```


### 중복제거 
* drop_duplicates([column명], keep = False)
* False 는 모든 중복 제거 

```python 
master_2021 = master_2021.drop_duplicates([0], keep = False)
```

### 중복값만 뽑아내기
```python 
# 중복값 찾아서 
dup = df.duplicated([column], keep = False)
# 중복값만 추출
df_dup = df.loc[dup, :]
```


```python
df_0103 = pd.read_csv(sftp.open('LotteChilsung_20220103_DATA.CSV', mode="r", bufsize=-1), sep='\t', header=None)  
dup = df_0103_m.duplicated([0], keep=False)
df_dup = pd.concat([df_0103_m, dup], axis = 1)
df_dup.rename(columns = {0 : 'dup'}, inplace = True)

```


# DataFrame index

https://gooopy.tistory.com/92

> index 설정 
```
test = dataframe.set_index(column, drop = True, append=False, inplace=False) 

# index 지우기 
test = dataframe.reset_index(column)
```
* drop 파라미터는 기존컬럼을 index로 넣을 때, 기존 컬럼을 말 그대로 버리는지 
* append 파라미터는 기존 인덱스에 내가 원하는 컬럼까지 추가해서 인덱스를 만들지
* inplace 파라미터는 원본 데이터에 덮어씌울지 

> index 내용을 list 로 가져오기
```
 list = dataframe.index
```



### Pandas Dataframe 분할
https://www.delftstack.com/ko/howto/python-pandas/split-pandas-dataframe/
