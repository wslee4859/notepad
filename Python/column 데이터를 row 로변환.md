

## Column 값을 row로 변환하여 데이터 매핑 #Pandas



### DataFrame type 보기

```
df1.dtypes
```

### DataFrame rename 

```
result.rename(columns={'categoryNum':'categoryid'},inplace=True)
```

### DataFrame Type 변경

```
df1 = df1.astype({'value':'int64'})
```



##### Webkeeper 정책별 허용여부에 따른 byte 데이터에 허용여부 판단을 위한 byte 데이터

예 : 

\-   “categoryaction” 컬럼은 512개의 바이트로 이루어져 있으며, 각 바이트는 0, 1, 2 값으로 설정 됨

Ø 0: 허용, 1: 차단, 2: 통과

![img](file:///C:/Users/LOTTE/AppData/Local/Temp/msohtmlclip1/01/clip_image001.jpg)

 

\-   카테고리의 대한 정보는 다음과 같음

![img](file:///C:/Users/LOTTE/AppData/Local/Temp/msohtmlclip1/01/clip_image002.jpg)

categoryaction byte 데이터를 row 로 만들어  

| 정책명            | categoryaction |
| ----------------- | -------------- |
| 롯데칠성_기본정책 | 210            |
| 구인구직          | 101            |

아래 형태로 만들기

| 정책명            | category_value |
| ----------------- | -------------- |
| 롯데칠성_기본정책 | 2              |
| 롯데칠성_기본정책 | 1              |
| 롯데칠성_기본정책 | 0              |
| 구인구직          | 1              |
| 구인구직          | 0              |
| 구인구직          | 1              |

### Source code

local 경로 : C:\Users\LOTTE

파일 : WebKeeper Policy Category Transf.ipynb

```python
# 데이터 불러오기 
df=pd.read_csv("C:\\Users\\LOTTE/tb_tpolicy.csv", encoding='UTF-8')
mst_categroy = pd.read_csv("C:\\Users\\LOTTE/category.csv", encoding='UTF-8')


# 합치려는 DataFrame 만들기
df1 = pd.DataFrame(columns=['정책명','category','category_v'])

# 각 항목을 리스트로 만들기
# 리스트 선언
namelist = []
categoryNum=[]
category_vlist=[]

# 합
temp_df = []
for i in range(len(df)):   #26  행
    for j in range(len(df.iloc[i][1])): #512   2번열의 갯수        
        namelist.append(df.iloc[i][0])         # 첫번째 컬럼의 name 을 512번 중복으로 만듬
        category_vlist.append(df.iloc[i][1][j])  #category value byte 값을 하나의 array 로 쪼갠다
        categoryNum.append(j+1)     # categoryaction 의 위치를 나타내기 위해, 나중에 category info 랑 join에 필요한 key

```

```python
# 위에서 만든 리스트를 하나의 리스트에 담고 하나의 리스트를 DataFrame 으로 만듬
temp_df = {'name':namelist,'categoryNum':categoryNum,'value':category_vlist}   
df1 = pd.DataFrame(temp_df,columns=['name','categoryNum','value'])
```



```python
# 위 category action 의 value 의 뜻을 join 
date = {'value':[0,1,2], 'value_mean':['허용','차단','통과']}
categoryact = pd.DataFrame(date, columns = ['value','value_mean'])

# left join 
result = pd.merge(left = df1 , right = categoryact, how = "left", on = 'value')
```



