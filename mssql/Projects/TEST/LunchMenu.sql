/*************************************
* 점심 메뉴 테이블 
**************************************/

-- DROP TABLE LunchMenu
-- 
CREATE TABLE LunchMenu
( num INT IDENTITY NOT NULL,
	Menu NVARCHAR(20),
	Sort INT
)
/* 점심 메뉴 추가***********************
INSERT LunchMenu VALUES ('김명자 굴 국밥', 1)
INSERT LunchMenu VALUES ('명동칼국수', 1)
INSERT LunchMenu VALUES ('누들박스' , 4)
INSERT LunchMenu VALUES ('놀부 부대찌개', 1)
INSERT LunchMenu VALUES ('보부선', 1)
INSERT LunchMenu VALUES ('수가성', 1)
INSERT LunchMenu VALUES ('예솔감자탕', 1)
INSERT LunchMenu VALUES ('차이나스토리', 2 )
INSERT LunchMenu VALUES ('전선생', 1)
INSERT LunchMenu VALUES ('맥도날드', 4)
INSERT LunchMenu VALUES ('준스시' , 3)
INSERT LunchMenu VALUES ('모랑' , 1)
INSERT LunchMenu VALUES ('시부야', 3)
INSERT LunchMenu VALUES ('토도로끼' , 3)
INSERT LunchMenu VALUES ('전주콩나물국밥', 1)
INSERT LunchMenu VALUES ('포차이', 4)
INSERT LunchMenu VALUES ('우리집맛집', 1)
INSERT LUnchMenu VALUES ('반포식스', 4 )
INSERT LunchMenu VALUES ('엉터리', 3)
INSERT LunchMenu VALUES ('홈플러스 일본라면', 3)
INSERT LunchMenu VALUES ('신선본', 3)
INSERT LunchMenu VALUES ('병천순대', 1)
INSERT LunchMenu VALUES ('사월의 보리밥', 1)
INSERT LunchMenu VALUES ('일품낙지', 1)
INSERT LunchMenu VALUES ('장닭(돈가스)', 3)
INSERT LunchMenu VALUES ('홍대돈부리', 3)
INSERT LunchMenu VALUES ('아비꼬(월드몰)', 4)
INSERT LunchMenu VALUES ('봉추찜닭', 1)
INSERT LunchMenu VALUES ('논헌삼계탕', 1)
INSERT LunchMenu VALUES ('서래냉면', 1)
INSERT LunchMenu VALUES ('장미상가 김치찜', 1)

SELECT * FROM LunchMenu
*******************************************/
/*Update lunchmenu
set sort = 3
where menu='엉터리'*/


