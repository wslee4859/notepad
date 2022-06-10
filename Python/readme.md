# String Format
* str.format


```python
test = 'Hello {name}. count: {count}'
test.format(name='Bob', count=5)
# 'Hello Bob. count: 5'

test = 'Hello {1}. count: {0}'
test.format(10, 'Jim')
# 'Hello Jim. count: 10'
```
* 이게 더 좋음 f-string    
```python
name = 'Bob'
test = f'Hello {name}'
print(test)
# Hello Bob


a = 2
b = 3
test = f'sum: {a+b}'
print(test)
# sum: 5


test = f'Hi {name}'
name = 'Bob'
print(test)
# Hi Bob
```


# DataFrame Value Count
df['_type'].value_counts()



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
```



# Dataframe rename

* dataframe.rename(columns = {0:'BARCODE'})


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
dup = df.duplicated([0], keep = False)
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



# list 중복제거

1. 중복 list 를 set -> list
```
index_date = test.index
index_set = set(index_date)
list_date = list(index_set)
list_date
```



# 정렬 Sort

https://rfriend.tistory.com/281

1. DataFrame 정렬 : DataFrame.sort_values()
3. Tuple 정렬 : sorted(tuple, key)
4. List 정렬 : list.sort(), sorted(list)





# 파일명에서 number 형식의 날짜형식을 추출, 가장 최근 날짜데이터를 가져오는 방안

### list 에서 정규식으로 숫자만 추출하는 방법

```
# filename_name_list = list
# re.sub 를 사용해서 숫자가 아닌 것들 '' 로 모두 치환
test = [re.sub(r'[^0-9]', '', x) for x in filename_name_list]

# 뽑아내는 숫자를 특정 자릿수로 고정 (예 : 8자리) 
test = [re.sub(r'[^0-9]', '', x)[:8] for x in filename_name_list]
```

### list 에서 특정 string value 만 list로 가져오기

```
filename_comp = 'LotteChilsung'
files = [s for s in files if filename_comp in s]    
```

### 최대값 가져오기
```
# filename_name_list = list
test = [re.sub(r'[^0-9]', '', x) for x in filename_name_list]
max(test)
```


# list 와일드카드로 검색해서 list 만들기

[참고](https://stackoverflow.com/questions/34660530/find-strings-in-list-using-wildcard)

```
import fnmatch
l = ['RT07010534.txt', 'RT07010533.txt', 'RT02010534.txt']
pattern = 'RT0701*.txt'
matching = fnmatch.filter(l, pattern)
print(matching)
```

# Python 의 모듈과 패키지, sys, 절대경로, 상대경로
https://velog.io/@bungouk6829/Python-%EC%9D%98-%EB%AA%A8%EB%93%88%EA%B3%BC-%ED%8C%A8%ED%82%A4%EC%A7%80-sys

### (모듈을 저장한 디렉터리) 사용하기   
https://wikidocs.net/29  
1. sys.path.append(모듈을 저장한 디렉터리) 사용하기  
```python
import sys
sys.path  #모듈이 저장되어 있는 경로가 있는지 확인
sys.path.append("모듈절대경로")    
```
2. PYTHONPATH 환경 변수 사용하기  
```bash
 # vi ~/.bash_profile
      PYTHONPATH=$PHTHONPATH:/usr/lib/python3.7/lib-dynload
```

# pip install 내용 전달  
```shell
pip freeze > requirements.txt
```
받는쪽에서 설치   
```shell
pip install -r requirements.txt
```




