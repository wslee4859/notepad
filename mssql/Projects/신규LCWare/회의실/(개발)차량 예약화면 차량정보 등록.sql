
rollback
/******************
* ���� �߰�
*******************/
('','3','����(����ũ)','','����','�����������','4','','','','','','','',getdate(),getdate(),'N','3','N','31��9523','2','11',''),
--commit
begin tran
insert into [dbo].[roominfo] values
('','1','����(���)','','����','�ڱݴ��','4','','','','','','','',getdate(),getdate(),'N','3','N','49��0442','2','11','�����н� �ܸ���'),
('','2','�¿���(�ƹݶ�)','','����','S&OP���','5','','','','','','','',getdate(),getdate(),'N','3','N','23��6520','2','11','�����н� �ܸ���'),
('','3','����(����ũ)','','����','�����������','4','','','','','','','',getdate(),getdate(),'N','3','N','31��9523','2','11',''),
('','4','����(����ũ)','','����','ä�δ��','4','','','','','','','',getdate(),getdate(),'N','4','N','31��9502','2','11',''),
('','5','�¿���(�ƹݶ�)','','����','�����������','5','','','','','','','',getdate(),getdate(),'N','5','N','69��2529','2','11',''),
('','6','�¿���(�ƹݶ�)','','����','EDS��ȹ���','5','','','','','','','',getdate(),getdate(),'N','6','Y','63��5370','2','11',''),
('','7','�¿���(SM3)','','����','���1���','5','','','','','','','',getdate(),getdate(),'N','7','N','15��0617','2','11',''),
('','8','�¿���(�Ÿ)','','����','ǰ���������','5','','','','','','','',getdate(),getdate(),'N','8','N','63ȣ1175','2','11','')

begin tran
update [dbo].[roominfo]
set location = 3
where locationNm = '����'

--commit


select  location, locationNm, count(locationNm) cnt
from dbo.roominfo (nolock)
where delYN      = 'N' 
AND bookType = '2'
group by location, locationNm
order by location 


select  location, locationNm, count(locationNm) cnt
from dbo.roominfo (nolock)
where delYN      = 'N' 
AND bookType = '1'
group by location, locationNm
order by location 


select * from roominfo (nolock) 
	where bookType = '2' 	
	  and delYN      = 'N'
      And locationNm = '����' 
     order by sortOrder
        

select  carNo
from dbo.roominfo (nolock)
where delYN      = 'N' 
AND bookType = '2'
--group by location, locationNm
order by carNo 


select  locationNm
from dbo.roominfo (nolock)
where delYN      = 'N' 
AND bookType = '2'
--group by location, locationNm
order by carNo 


