# 특정 문자열이 포함된 VIEW, SP 찾기
```sql
-- ex : HRSQLSERVER 가 포함된 VIEW, SP 찾기
select distinct a.name
from sysobjects a with (nolock)
join syscomments b with (nolock) on a.id = b.id
where b.text like '%' + 'HRSQLSERVER' + '%'
order by a.name


```


# 저장프로시저 느림 현상

### CASE : 서버 이관 이후 저장프로시저가 느려지는 현상

저장 프로시저 호출 시 timeout 에러 발생  
해당 프로시저 SSMS 에서 호출 시 정상 동작   

해당 프로시저 alter 로 수정

해당 상황 RECOMPILE 로 해결


[참고 저장 프로시저 리컴파일](https://ggmouse.tistory.com/492)

[참고 프로시저실행속도에 문제가 있을 때](https://m.blog.naver.com/jjcnet/220597137967)


