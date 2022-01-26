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


