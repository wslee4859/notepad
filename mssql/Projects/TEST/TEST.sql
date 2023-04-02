USE TestDB
BEGIN TRAN
SELECT @@TRANCOUNT
DROP TABLE bankBook
INSERT INTO bankBook VALUE ('���糲', 1000);

CREATE TABLE bankBook
(	name nVARCHAR(10),
	money INT,
	CONSTRAINT CK_money
	CHECK (money >=0)
)


SELECT * FROM bankBook
SELECT @@TRANCOUNT
COMMIT TRAN



--INSERT INTO bankBook VALUES ('���糲', 1000);
--INSERT INTO bankBook VALUES ('������', 0);
--
--UPDATE bankBook SET money = money - 500 WHERE name = '���糲';
--UPDATE bankBook SET money = money + 500 WHERE name = '������';
--
--BEGIN TRY
--	BEGIN TRAN
--		UPDATE bankBook SET money = money - 600 WHERE name = '���糲';
--		UPDATE bankBook SET money = money + 600 WHERE name = '������';
--	COMMIT TRAN
--END TRY
--BEGIN CATCH
--	ROLLBACK TRAN
--END CATCH
--
--SELECT * FROM bankBook