## 원격서버 powershell 연결 방법
[참고](https://svrstudy.tistory.com/75)



## CSV 파일 Control
```powershell
Export-Csv -Path "\\lcsekw3exch01\file\eugene1.csv" -Encoding UTF8
ConvertTo-CSV > "C:\file\aa.csv"  
out-file C:\file.test.txt(csv) 
```
Export-csv 는 인코딩해야함. (파워쉘 4.0에는 Export에 NoBom 이 지원안함. 6.0 부터 지원)  
out-file 은 규칙성있게 데이터 추출이 안됨. export-csv 권장.  
export-csv 시 파일이 이상하게 나올 땐 ft 을 Select-Object로 변경   
 
* 한글 못가져올 땐 -Encoding UTF8  
case : system.string 으로 표시될 때  
ex : recipients 가 system.string으로 표시될 경우 
```powershell
Select-object EventID, Source, Sender, @{l="Recipients";e={$_.Recipients -join " "}}, MEssageSubject, Time*
```

*위에 Typeinfo 제거하려면 : 
```powershell
Get-Process | Export-Csv -Path .\Processes.csv -NoTypeInformation
```
