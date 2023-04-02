select top 100 * from [WF].[FORM_YE6A8907A455743E58C86D37EC4A658C1] where CREATOR = '정순욱'

YE6A8907A455743E58C86D37EC4A658C1

begin tran
update [WF].[FORM_YE6A8907A455743E58C86D37EC4A658C1]
set ADD_OPINION = '- 개발내역
1. 신규계정생성 : 21190100
                      (유동성금융리스부채-금융리스미지급금)

2. 조정계정 추가 IMG 설정
  - 비유동성금융리스부채-금용리스미지급금과 동일한 계정에 대해, 대체 조정계정으로 사용할 수 있도록 설정
  - 조정계정 : 구매처 및 거래처에 연결된 G/L계정

-진행일정
1. 계정생성 및 IMG설정(10/10)
2. 테스트 (~10/12)
3. 운영배포(10/15)'
where process_id = 'P59CD4960727D4E56ABB5C1FF208D88F7'
commit