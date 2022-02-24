# 숫자로된 날짜값을 가져와서 가장 최근 날짜데이터를 가져오는 방안

### list 에서 정규식으로 숫자만 추출하는 방법

```
# filename_name_list = list
test = [re.sub(r'[^0-9]', '', x) for x in filename_name_list]
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



# Python 의 모듈과 패키지, sys, 절대경로, 상대경로
https://velog.io/@bungouk6829/Python-%EC%9D%98-%EB%AA%A8%EB%93%88%EA%B3%BC-%ED%8C%A8%ED%82%A4%EC%A7%80-sys

# list 와일드카드로 검색해서 list 만들기

[참고](https://stackoverflow.com/questions/34660530/find-strings-in-list-using-wildcard)

```
import fnmatch
l = ['RT07010534.txt', 'RT07010533.txt', 'RT02010534.txt']
pattern = 'RT0701*.txt'
matching = fnmatch.filter(l, pattern)
print(matching)
```


