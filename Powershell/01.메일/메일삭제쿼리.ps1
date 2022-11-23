.$env:exchangeinstallpath\bin\remoteexchange.ps1
connect-exchangeserver -Auto


#제목
get-mailbox -OrganizationalUnit  "ou=롯데칠성음료(주),ou=JJ,ou=groups,ou=ekw,dc=lottechilsung,dc=co,dc=kr" -ResultSize unlimited | Search-Mailbox -SearchQuery subject:"K7 을지로냉차 500펫 개발계획 공유의 件" -TargetMailbox mail13 -TargetFolder
get-mailbox -OrganizationalUnit  "ou=롯데칠성음료(주),ou=JJ,ou=groups,ou=ekw,dc=lottechilsung,dc=co,dc=kr" -ResultSize unlimited | Search-Mailbox -SearchQuery subject:"K7 을지로냉차 500펫 개발계획 공유의 件" -deleteContent
AND Sent:"08/03/2017"
get-mailbox -OrganizationalUnit  "ou=롯데칠성음료(주),ou=JJ,ou=groups,ou=ekw,dc=lottechilsung,dc=co,dc=kr" -ResultSize unlimited | Search-Mailbox -SearchQuery {subject:"재택근무 계획서 취합 안내" AND Sent:"06/16/2020"} -TargetMailbox mail13 -TargetFolder
get-mailbox -OrganizationalUnit  "ou=롯데칠성음료(주),ou=JJ,ou=groups,ou=ekw,dc=lottechilsung,dc=co,dc=kr" -ResultSize unlimited | Search-Mailbox -SearchQuery {subject:"재택근무 계획서 취합 안내" AND Sent:"06/16/2020"} -deleteContent


#삭제 
get-mailbox -OrganizationalUnit "ou=영업,ou=롯데칠성음료(주),ou=JJ,ou=groups,ou=ekw,dc=lottechilsung,dc=co,dc=kr"  -ResultSize unlimited | Search-Mailbox -SearchQuery subject:"디지털 트랜스포메이션 동영상 교육자료 배포 및 시청의 건" -deleteContent
get-mailbox -OrganizationalUnit "ou=생산,ou=롯데칠성음료(주),ou=JJ,ou=groups,ou=ekw,dc=lottechilsung,dc=co,dc=kr"  -ResultSize unlimited | Search-Mailbox -SearchQuery subject:"디지털 트랜스포메이션 동영상 교육자료 배포 및 시청의 건" -deleteContent
get-mailbox -OrganizationalUnit "ou=지원,ou=롯데칠성음료(주),ou=JJ,ou=groups,ou=ekw,dc=lottechilsung,dc=co,dc=kr"  -ResultSize unlimited | Search-Mailbox -SearchQuery subject:"디지털 트랜스포메이션 동영상 교육자료 배포 및 시청의 건" -deleteContent

#OU 단위로 삭제
Get-Mailbox -OrganizationalUnit "ou=BI/인사파트,ou=운영담당,ou=전산팀,ou=기획부문,ou=지원,ou=롯데칠성음료(주),ou=JJ,ou=groups,ou=ekw,dc=lottechilsung,dc=co,dc=kr" -ResultSize unlimited | Search-Mailbox -SearchQuery 'Body:"성희롱 예방 및 다양성 인식개선 재교육 실시"' -TargetMailbox mail11 -TargetFolder "20161229_성희롱" 
Get-Mailbox -OrganizationalUnit "ou=BI/인사파트,ou=운영담당,ou=전산팀,ou=기획부문,ou=지원,ou=롯데칠성음료(주),ou=JJ,ou=groups,ou=ekw,dc=lottechilsung,dc=co,dc=kr" -ResultSize unlimited | Search-Mailbox -SearchQuery 'Subject:"성희롱예방및다양성인식개선"' -TargetMailbox mail11 -TargetFolder "20161229_성희롱" 



#제목
get-mailbox -OrganizationalUnit  "ou=롯데칠성음료(주),ou=Members,ou=LotteBeverage,dc=lottechilsung,dc=co,dc=kr" -ResultSize unlimited | Search-Mailbox -SearchQuery subject:"디지털 트랜스포메이션 동영상 교육자료 배포 및 시청의 건" -TargetMailbox mail13 -TargetFolder 20190104

#삭제 
get-mailbox -OrganizationalUnit "ou=롯데주류,ou=Members,ou=LotteBeverage,dc=lottechilsung,dc=co,dc=kr"  -ResultSize unlimited | Search-Mailbox -SearchQuery subject:"디지털 트랜스포메이션 동영상 교육자료 배포 및 시청의 건" -TargetMailbox mail13 -TargetFolder 20170119


get-mailbox -OrganizationalUnit "ou=롯데칠성음료(주),ou=JJ,ou=groups,ou=ekw,dc=lottechilsung,dc=co,dc=kr"  -ResultSize unlimited | Search-Mailbox -SearchQuery subject:"2016 연말정산 공지" -deleteContent
get-mailbox -OrganizationalUnit "ou=영업,ou=롯데칠성음료(주),ou=JJ,ou=groups,ou=ekw,dc=lottechilsung,dc=co,dc=kr"  -ResultSize unlimited | Search-Mailbox -SearchQuery subject:"[인사담당] 근로 및 연봉계약서 작성요청 ('18.06月)" -deleteContent
get-mailbox -OrganizationalUnit "ou=신유통전략담, ou=신유통부문, ou=영업본부, ou=영업,ou=롯데칠성음료(주),ou=JJ,ou=groups,ou=ekw,dc=lottechilsung,dc=co,dc=kr"  -ResultSize unlimited | Search-Mailbox -SearchQuery subject:"[인사담당] 근로 및 연봉계약서 작성요청 ('18.06月)" -TargetMailbox mail13 -TargetFolder 201806252

#기획팀_음료
Get-Mailbox -OrganizationalUnit "ou=기획부문,ou=지원,ou=롯데칠성음료(주),ou=JJ,ou=groups,ou=ekw,dc=lottechilsung,dc=co,dc=kr" -ResultSize unlimited | Search-Mailbox -SearchQuery subject:"경영 전략" -TargetMailbox mail13 -TargetFolder "경영전략"
Get-Mailbox -OrganizationalUnit "ou=음료기획팀,ou=기획부문,ou=지원,ou=롯데칠성음료(주),ou=JJ,ou=groups,ou=ekw,dc=lottechilsung,dc=co,dc=kr" -ResultSize unlimited | Search-Mailbox -SearchQuery subject:"경영계획" -TargetMailbox mail13 -TargetFolder "경영계획_음료2"
#기획팀_주류
Get-Mailbox -OrganizationalUnit "ou=주류기획팀,ou=기획부문,ou=롯데주류,ou=Members,ou=LotteBeverage,dc=lottechilsung,dc=co,dc=kr" -ResultSize unlimited | Search-Mailbox -SearchQuery subject:"경영 전략" -TargetMailbox mail13 -TargetFolder "경영전략_주류"
Get-Mailbox -OrganizationalUnit "ou=주류기획팀,ou=기획부문,ou=롯데주류,ou=Members,ou=LotteBeverage,dc=lottechilsung,dc=co,dc=kr" -ResultSize unlimited | Search-Mailbox -SearchQuery subject:"경영계획" -TargetMailbox mail13 -TargetFolder "경영계획_주류"

Get-Mailbox -OrganizationalUnit "ou=지원,ou=롯데칠성음료(주),ou=JJ,ou=groups,ou=ekw,dc=lottechilsung,dc=co,dc=kr" -ResultSize unlimited | Search-Mailbox -SearchQuery subject:"경영전략 회의" -TargetMailbox mail13 -TargetFolder "20200708_경영전략회의"



Get-Mailbox -OrganizationalUnit "ou=주류기획팀,ou=기획부문,ou=롯데주류,ou=Members,ou=LotteBeverage,dc=lottechilsung,dc=co,dc=kr" -ResultSize unlimited | Search-Mailbox -SearchQuery subject:"경영계획" -TargetMailbox mail13 -TargetFolder "경영계획_주류"





#첨부파일
get-mailbox wslee4859 | Search-Mailbox -SearchQuery attachment:주류미등록 -TargetMailbox mail11 -TargetFolder 20161230 

# body 
Get-Mailbox -OrganizationalUnit "ou=영업본부,ou=영업,ou=롯데칠성음료(주),ou=JJ,ou=groups,ou=ekw,dc=lottechilsung,dc=co,dc=kr" -ResultSize unlimited | Search-Mailbox -SearchQuery body:"010 2347 8842" -TargetMailbox mail13 -TargetFolder "20170223_홍성지점" 


Get-Mailbox -OrganizationalUnit "ou=영업본부,ou=영업,ou=롯데칠성음료(주),ou=JJ,ou=groups,ou=ekw,dc=lottechilsung,dc=co,dc=kr" -ResultSize unlimited | Search-Mailbox -SearchQuery body:"010 2347 8842" -TargetMailbox mail13 -TargetFolder "20170223_홍성지점" 


Get-Mailbox -OrganizationalUnit "ou=BI/인사파트,ou=운영담당,ou=전산팀,ou=기획부문,ou=지원,ou=롯데칠성음료(주),ou=JJ,ou=groups,ou=ekw,dc=lottechilsung,dc=co,dc=kr" -ResultSize unlimited | Search-Mailbox -SearchQuery 'Body:"8842"' -TargetMailbox mail13 -TargetFolder "TEST_2" 
Get-Mailbox -OrganizationalUnit "ou=BI/인사파트,ou=운영담당,ou=전산팀,ou=기획부문,ou=지원,ou=롯데칠성음료(주),ou=JJ,ou=groups,ou=ekw,dc=lottechilsung,dc=co,dc=kr" -ResultSize unlimited | Search-Mailbox -SearchQuery {Body:"8842" AND Sent:"02/23/2017" } -TargetMailbox mail13 -TargetFolder "TEST_4" 

# 시간으로 삭제(send : 발신한 메일, Received : 수신한 메일)
Get-Mailbox -OrganizationalUnit "ou=롯데칠성음료(주),ou=JJ,ou=groups,ou=ekw,dc=lottechilsung,dc=co,dc=kr" -ResultSize unlimited | Search-Mailbox -SearchQuery {subject:"칸타타 아이스 190ml캔" AND Sent:"08/03/2017"} -TargetMailbox mail14 -TargetFolder "20170803_브랜드팀"
Get-Mailbox -OrganizationalUnit "ou=롯데칠성음료(주),ou=JJ,ou=groups,ou=ekw,dc=lottechilsung,dc=co,dc=kr" -ResultSize unlimited | Search-Mailbox -SearchQuery {subject:"칸타타 아이스 190ml캔" AND Sent:"08/03/2017"} -DeleteContent

# 발신자 검색 (ex : from : administartor@lottechilsung.co.kr)
Get-Mailbox -OrganizationalUnit "ou=롯데칠성음료(주),ou=JJ,ou=groups,ou=ekw,dc=lottechilsung,dc=co,dc=kr" -ResultSize unlimited | Search-Mailbox -SearchQuery From:"yeonji_so@lottechilsung.co.kr" -DeleteContent


# 2017-09-29 김영민 머천다이징담당 메일 삭제 요청 

Get-Mailbox -OrganizationalUnit "ou=롯데칠성음료(주),ou=JJ,ou=groups,ou=ekw,dc=lottechilsung,dc=co,dc=kr" -ResultSize unlimited | Search-Mailbox -SearchQuery {subject:"롯데리아 패밀리 카드 신청" AND Sent:"09/29/2017"} -TargetMailbox mail12 -TargetFolder "20170929_머천다이징"
Get-Mailbox -OrganizationalUnit "ou=롯데칠성음료(주),ou=JJ,ou=groups,ou=ekw,dc=lottechilsung,dc=co,dc=kr" -ResultSize unlimited | Search-Mailbox -SearchQuery {subject:"롯데리아 패밀리 카드 신청" AND Sent:"09/29/2017"} -DeleteContent


# 2017-11-14 김기열 마케팅전략담당 메일 삭제 요청 
Get-Mailbox -OrganizationalUnit "ou=롯데칠성음료(주),ou=JJ,ou=groups,ou=ekw,dc=lottechilsung,dc=co,dc=kr" -ResultSize unlimited | Search-Mailbox -SearchQuery {subject:"해외여행 일정표(Itinerary)" AND Sent:"11/14/2017"} -TargetMailbox mail13 -TargetFolder "20171114_김기열"
Get-Mailbox -OrganizationalUnit "ou=롯데칠성음료(주),ou=JJ,ou=groups,ou=ekw,dc=lottechilsung,dc=co,dc=kr" -ResultSize unlimited | Search-Mailbox -SearchQuery {subject:"해외여행 일정표(Itinerary)" AND Sent:"11/14/2017"} -DeleteContent

# 2018-05-04 임상대 메일 삭제 요청
Get-Mailbox -OrganizationalUnit "ou=롯데주류,ou=Members,ou=LotteBeverage,dc=lottechilsung,dc=co,dc=kr" -ResultSize unlimited | Search-Mailbox -SearchQuery {subject:"회사를 떠나며" AND Sent:"05/04/2018"} -TargetMailbox mail13 -TargetFolder "20171114_김기열"
Get-Mailbox -OrganizationalUnit "ou=롯데주류,ou=Members,ou=LotteBeverage,dc=lottechilsung,dc=co,dc=kr" -ResultSize unlimited | Search-Mailbox -SearchQuery {subject:"회사를 떠나며" AND Sent:"05/04/2018"} -DeleteContent

get-mailbox wslee4859 | Search-Mailbox -SearchQuery attachment:주류미등록 -TargetMailbox mail11 -TargetFolder 20161230 


Get-Mailbox -OrganizationalUnit "ou=롯데칠성음료(주),ou=JJ,ou=groups,ou=ekw,dc=lottechilsung,dc=co,dc=kr" -ResultSize unlimited | Search-Mailbox -SearchQuery {attachment:재무팀장 AND Sent:"05/04/2018"} -TargetMailbox mail13 -TargetFolder "20180504_임상대2"

Get-Mailbox -OrganizationalUnit "ou=롯데칠성음료(주),ou=JJ,ou=groups,ou=ekw,dc=lottechilsung,dc=co,dc=kr" -ResultSize unlimited | Search-Mailbox -SearchQuery {attachment:재무팀장 AND Sent:"05/04/2018"} -DeleteContent
Get-Mailbox -OrganizationalUnit "ou=롯데주류,ou=Members,ou=LotteBeverage,dc=lottechilsung,dc=co,dc=kr" -ResultSize unlimited | Search-Mailbox -SearchQuery {attachment:재무팀장 AND Sent:"05/04/2018"} -DeleteContent



Get-Mailbox -OrganizationalUnit "ou=롯데칠성음료(주),ou=JJ,ou=groups,ou=ekw,dc=lottechilsung,dc=co,dc=kr" -ResultSize unlimited | Search-Mailbox -SearchQuery {subject:"중복맞이 삼계탕지급 주소지 미입력" AND Sent:"07/23/2018"} -DeleteContent
Get-Mailbox -OrganizationalUnit "ou=롯데칠성음료(주),ou=JJ,ou=groups,ou=ekw,dc=lottechilsung,dc=co,dc=kr" -ResultSize unlimited | Search-Mailbox -SearchQuery {attachment:삼계탕지 AND Sent:"07/23/2018"} -TargetMailbox mail13 -TargetFolder "20180723_노무담당급2"


Get-Mailbox -OrganizationalUnit "ou=SCM부문,ou=지원본부,ou=지원,ou=롯데칠성음료(주),ou=JJ,ou=groups,ou=ekw,dc=lottechilsung,dc=co,dc=kr" -ResultSize unlimited | Search-Mailbox -SearchQuery {subject:"물류비 보고자료 (18.07월)" AND Sent:"08/20/2018"} -DeleteContent

# 2018-09-14 윤다혜 메일 삭제
Get-Mailbox -OrganizationalUnit "ou=지원,ou=롯데칠성음료(주),ou=JJ,ou=groups,ou=ekw,dc=lottechilsung,dc=co,dc=kr" -ResultSize unlimited | Search-Mailbox -SearchQuery {subject:"(주)백학음료 임일환 공장장님 서류 요청건" AND Sent:"09/14/2018"} -TargetMailbox mail13 -TargetFolder "180914_윤다혜"
Get-Mailbox -OrganizationalUnit "ou=지원,ou=롯데칠성음료(주),ou=JJ,ou=groups,ou=ekw,dc=lottechilsung,dc=co,dc=kr" -ResultSize unlimited | Search-Mailbox -SearchQuery {subject:"(주)백학음료 임일환 공장장님 서류 요청건" AND Sent:"09/14/2018"} -DeleteContent


# 2019-07-09 주류 수입 마케팅 이경훈 책임 메일 삭제
Get-Mailbox -OrganizationalUnit "ou=롯데주류,ou=Members,ou=LotteBeverage,dc=lottechilsung,dc=co,dc=kr" -ResultSize unlimited | Search-Mailbox -SearchQuery {subject:"(업무연락) 20년 9월 조직 변경 통보" AND Sent:"09/14/2020" AND from:"yeonji_so@lottechilsung.co.kr"} -TargetMailbox lcsmanager -TargetFolder "190709_이정훈책임3"


#2019-11-04 김선국
Get-Mailbox -OrganizationalUnit "ou=경영기획팀,ou=경영전략부문,ou=롯데주류,ou=Members,ou=LotteBeverage,dc=lottechilsung,dc=co,dc=kr" -ResultSize unlimited | Search-Mailbox -SearchQuery subject:"CGU 손상평가 관련" -TargetMailbox mail13 -TargetFolder "경영전략_주류"
Get-Mailbox -OrganizationalUnit "ou=경영기획팀,ou=경영전략부문,ou=롯데주류,ou=Members,ou=LotteBeverage,dc=lottechilsung,dc=co,dc=kr" -ResultSize unlimited | Search-Mailbox -SearchQuery subject:"CGU 손상평가 관련" -DeleteContent
Get-Mailbox -OrganizationalUnit "ou=주류재무팀,ou=재경부문,ou=롯데주류,ou=Members,ou=LotteBeverage,dc=lottechilsung,dc=co,dc=kr" -ResultSize unlimited | Search-Mailbox -SearchQuery subject:"CGU 손상평가 관련 외부 이메일 계정 취합의 件" -DeleteContent


#2019-11-26 sjlee3 이선장 상무 
Get-Mailbox -OrganizationalUnit "ou=롯데칠성음료(주),ou=JJ,ou=groups,ou=ekw,dc=lottechilsung,dc=co,dc=kr" -ResultSize unlimited | Search-Mailbox -SearchQuery {subject:"(업무연락) 20년 9월 조직 변경 통보" AND Sent:"09/14/2020"} -DeleteContent


#
get-mailbox -OrganizationalUnit  "ou=롯데칠성음료(주),ou=JJ,ou=groups,ou=ekw,dc=lottechilsung,dc=co,dc=kr" -ResultSize unlimited | Search-Mailbox -SearchQuery subject:"경영전략" -TargetMailbox mail13 -TargetFolder "경영전략"
get-mailbox -OrganizationalUnit  "ou=롯데칠성음료(주),ou=JJ,ou=groups,ou=ekw,dc=lottechilsung,dc=co,dc=kr" -ResultSize unlimited | Search-Mailbox -SearchQuery subject:"브리핑" -TargetMailbox mail13 -TargetFolder "브리핑"

get-mailboxdatabase -status | ft name, databasesize, *availableNew*
Get-MailboxDatabase -Identity MBXDB01 -status | fl

# 2020-09-14 소연지 책임
Get-Mailbox -OrganizationalUnit "ou=롯데칠성음료(주),ou=JJ,ou=groups,ou=ekw,dc=lottechilsung,dc=co,dc=kr" -ResultSize unlimited | Search-Mailbox -SearchQuery {subject:"20년 9월 조직 변경" AND Sent:"09/14/2020"} -DeleteContent

Get-Mailbox -OrganizationalUnit "ou=개발2담당,ou=전산팀,ou=전략기획부문,ou=지원,ou=롯데칠성음료(주),ou=JJ,ou=groups,ou=ekw,dc=lottechilsung,dc=co,dc=kr" -ResultSize unlimited | Search-Mailbox -SearchQuery from:"gun.lee@lottechilsung.co.kr" -TargetMailbox mail13 -TargetFolder "testgun"

# 2020-12-03 박동진 책임
Get-Mailbox -OrganizationalUnit "ou=롯데칠성음료(주),ou=JJ,ou=groups,ou=ekw,dc=lottechilsung,dc=co,dc=kr" -ResultSize unlimited | Search-Mailbox -SearchQuery {subject:"20년 9월 조직 변경" AND Sent:"09/14/2020"}  -TargetMailbox mail13 -TargetFolder "생산_박동진"

Get-Mailbox -OrganizationalUnit "ou=롯데칠성음료(주),ou=JJ,ou=groups,ou=ekw,dc=lottechilsung,dc=co,dc=kr" -ResultSize unlimited | Search-Mailbox -SearchQuery {subject:"20년 9월 조직 변경" AND Sent:"09/14/2020"} -DeleteContent

# 2020-12-22 성미솔 대리
Get-Mailbox -OrganizationalUnit "ou=롯데칠성음료(주),ou=JJ,ou=groups,ou=ekw,dc=lottechilsung,dc=co,dc=kr" -ResultSize unlimited | Search-Mailbox -SearchQuery {subject:"2020년 동계 휴가비 지급 안내(음료)" AND Sent:"12/22/2020"}  -TargetMailbox mail13 -TargetFolder "대리_성미솔"

Get-Mailbox -OrganizationalUnit "ou=롯데칠성음료(주),ou=JJ,ou=groups,ou=ekw,dc=lottechilsung,dc=co,dc=kr" -ResultSize unlimited | Search-Mailbox -SearchQuery {subject:"2020년 동계 휴가비 지급 안내(음료)" AND Sent:"12/22/2020"} -DeleteContent

# 2021-01-06 양소현 팀장
Get-Mailbox -OrganizationalUnit "ou=롯데칠성음료(주),ou=JJ,ou=groups,ou=ekw,dc=lottechilsung,dc=co,dc=kr" -ResultSize unlimited | Search-Mailbox -SearchQuery {subject:"1/6 주가 현황" AND Sent:"01/06/2021"}  -TargetMailbox mail13 -TargetFolder "양소현 매니저"

Get-Mailbox -OrganizationalUnit "ou=롯데칠성음료(주),ou=JJ,ou=groups,ou=ekw,dc=lottechilsung,dc=co,dc=kr" -ResultSize unlimited | Search-Mailbox -SearchQuery {subject:"1/6 주가 현황" AND Sent:"01/06/2021"} -DeleteContent

# 2021-02-01 스팸 메일 삭제

Get-Mailbox -OrganizationalUnit "ou=롯데칠성음료(주),ou=JJ,ou=groups,ou=ekw,dc=lottechilsung,dc=co,dc=kr" -ResultSize unlimited | Search-Mailbox -SearchQuery {subject:"지불 기다림" } -DeleteContent

# 2021-02-01 문혜연 매니저

Get-Mailbox -OrganizationalUnit "ou=롯데칠성음료(주),ou=JJ,ou=groups,ou=ekw,dc=lottechilsung,dc=co,dc=kr" -ResultSize unlimited | Search-Mailbox -SearchQuery {subject:"★중요) 위스키 선물세트 공장별 입고 및 CT수송 관련안내_첨부파일 누락 재전송" AND Sent:"02/01/2021" } -DeleteContent

Get-Mailbox -OrganizationalUnit "ou=롯데칠성음료(주),ou=JJ,ou=groups,ou=ekw,dc=lottechilsung,dc=co,dc=kr" -ResultSize unlimited | Search-Mailbox -SearchQuery {subject:"★중요) 위스키 선물세트 공장별 입고 및 CT수송 관련안내" AND Sent:"02/01/2021" } -DeleteContent

