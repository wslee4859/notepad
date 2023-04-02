USE TestDB
BEGIN TRAN
SELECT @@TRANCOUNT
DROP TABLE bankBook
INSERT INTO bankBook VALUE ('우재남', 1000);

CREATE TABLE bankBook
(	name nVARCHAR(10),
	money INT,
	CONSTRAINT CK_money
	CHECK (money >=0)
)


SELECT * FROM bankBook
SELECT @@TRANCOUNT
COMMIT TRAN



--INSERT INTO bankBook VALUES ('우재남', 1000);
--INSERT INTO bankBook VALUES ('당탕이', 0);
--
--UPDATE bankBook SET money = money - 500 WHERE name = '우재남';
--UPDATE bankBook SET money = money + 500 WHERE name = '당탕이';
--
--BEGIN TRY
--	BEGIN TRAN
--		UPDATE bankBook SET money = money - 600 WHERE name = '우재남';
--		UPDATE bankBook SET money = money + 600 WHERE name = '당탕이';
--	COMMIT TRAN
--END TRY
--BEGIN CATCH
--	ROLLBACK TRAN
--END CATCH
--
--SELECT * FROM bankBook