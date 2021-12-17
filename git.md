
# git release 만들기  
### 과거 commit 에서 branch 생성  
```  
git checkout [commit번호]
git branch release/v1.0
git checkout release/v1.0

```


# 해당 revision으로 강제 rever 하기
```
git rever --hard [commit번호]
```

# git revert 된걸 origin 에 push 하기
```
git push origin [branch명] -f
```
