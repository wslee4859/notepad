

# Exception 
### 발생오류 확인
```python 
try : 
...
except Exception as e:
  print(e)
```
### 

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




