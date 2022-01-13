# 참고  
[함수 참고] : (https://docs.paramiko.org/en/stable/api/sftp.html)



# 트러블슈팅

### Expected unicode or bytes, got

case : 
```
sftp = sftp_conn()    
files = ftp.listdir()   
matching = [s for s in files if "MASTER" in s]
if matching:  
    df = pd.read_csv(ftp.open(matching, mode="r", bufsize=-1))
```

원인 : remote path 의 파일명이 'matching' 이라는 list로 넘어와서 문제발생  
해결 : 파일명을 value 로 처리 ex : 'TEST.CSV' 


