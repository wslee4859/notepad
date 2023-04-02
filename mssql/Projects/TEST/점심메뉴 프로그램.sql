/* 점심 메뉴 추가***********************
INSERT LunchMenu VALUES ('김명자 굴 국밥')
INSERT LunchMenu VALUES ('명동칼국수')
INSERT LunchMenu VALUES ('누들박스')
INSERT LunchMenu VALUES ('놀부 부대찌개')
INSERT LunchMenu VALUES ('보부선')
INSERT LunchMenu VALUES ('수가성')
INSERT LunchMenu VALUES ('예솔감자탕')
INSERT LunchMenu VALUES ('차이나스토리')
INSERT LunchMenu VALUES ('전선생')
INSERT LunchMenu VALUES ('맥도날드')
INSERT LunchMenu VALUES ('준스시')
INSERT LunchMenu VALUES ('모랑')
INSERT LunchMenu VALUES ('시부야')
INSERT LunchMenu VALUES ('토도로끼')
INSERT LunchMenu VALUES ('전주콩나물국밥')
INSERT LunchMenu VALUES ('포차이')
INSERT LunchMenu VALUES ('우리집맛집')
INSERT LUnchMenu VALUES ('반포식스')
INSERT LunchMenu VALUES ('엉터리')
INSERT LunchMenu VALUES ('홈플러스 일본라면')
INSERT LunchMenu VALUES ('신선본')
INSERT LunchMenu VALUES ('병천순대')
INSERT LunchMenu VALUES ('사월의 보리밥')
INSERT LunchMenu VALUES ('일품낙지')
INSERT LunchMenu VALUES ('장닭(돈가스)')
INSERT LunchMenu VALUES ('홍대돈부리')
INSERT LunchMenu VALUES ('아비꼬(월드몰)')
INSERT LunchMenu VALUES ('봉추찜닭')
INSERT LunchMenu VALUES ('논헌삼계탕')
INSERT LunchMenu VALUES ('서래냉면')
INSERT LunchMenu VALUES ('장미상가 김치찜')
*******************************************/

--SELECT * FROM LunchMenu

--EXEC SP_LUNCH_SETTING    --초기화   (메뉴뽑아오는 랜덤값 테이블 세팅 
EXEC SP_LUNCH_SELECT_V3
