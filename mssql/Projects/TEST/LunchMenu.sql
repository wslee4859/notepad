/*************************************
* ���� �޴� ���̺� 
**************************************/

-- DROP TABLE LunchMenu
-- 
CREATE TABLE LunchMenu
( num INT IDENTITY NOT NULL,
	Menu NVARCHAR(20),
	Sort INT
)
/* ���� �޴� �߰�***********************
INSERT LunchMenu VALUES ('����� �� ����', 1)
INSERT LunchMenu VALUES ('��Į����', 1)
INSERT LunchMenu VALUES ('����ڽ�' , 4)
INSERT LunchMenu VALUES ('��� �δ��', 1)
INSERT LunchMenu VALUES ('���μ�', 1)
INSERT LunchMenu VALUES ('������', 1)
INSERT LunchMenu VALUES ('���ְ�����', 1)
INSERT LunchMenu VALUES ('���̳����丮', 2 )
INSERT LunchMenu VALUES ('������', 1)
INSERT LunchMenu VALUES ('�Ƶ�����', 4)
INSERT LunchMenu VALUES ('�ؽ���' , 3)
INSERT LunchMenu VALUES ('���' , 1)
INSERT LunchMenu VALUES ('�úξ�', 3)
INSERT LunchMenu VALUES ('�䵵�γ�' , 3)
INSERT LunchMenu VALUES ('�����ᳪ������', 1)
INSERT LunchMenu VALUES ('������', 4)
INSERT LunchMenu VALUES ('�츮������', 1)
INSERT LUnchMenu VALUES ('�����Ľ�', 4 )
INSERT LunchMenu VALUES ('���͸�', 3)
INSERT LunchMenu VALUES ('Ȩ�÷��� �Ϻ����', 3)
INSERT LunchMenu VALUES ('�ż���', 3)
INSERT LunchMenu VALUES ('��õ����', 1)
INSERT LunchMenu VALUES ('����� ������', 1)
INSERT LunchMenu VALUES ('��ǰ����', 1)
INSERT LunchMenu VALUES ('���(������)', 3)
INSERT LunchMenu VALUES ('ȫ�뵷�θ�', 3)
INSERT LunchMenu VALUES ('�ƺ�(�����)', 4)
INSERT LunchMenu VALUES ('�������', 1)
INSERT LunchMenu VALUES ('��������', 1)
INSERT LunchMenu VALUES ('�����ø�', 1)
INSERT LunchMenu VALUES ('��̻� ��ġ��', 1)

SELECT * FROM LunchMenu
*******************************************/
/*Update lunchmenu
set sort = 3
where menu='���͸�'*/


