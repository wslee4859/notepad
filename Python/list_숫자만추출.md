# list 에서 정규식으로 숫자만 추출하는 방법
```
# filename_name_list = list
test = [re.sub(r'[^0-9]', '', x) for x in filename_name_list]
```

### 최대값 가져오기
```
# filename_name_list = list
test = [re.sub(r'[^0-9]', '', x) for x in filename_name_list]
max(test)
```

