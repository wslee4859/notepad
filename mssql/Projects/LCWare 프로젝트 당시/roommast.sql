
update mrbook.dbo.roommast
set sortOrder = '2'
where companyNm = '������û'

insert into mrbook.dbo.roommast values ('023602','ȸ�ǽ�','3','1','�Ե��ַ� ȸ�ǽ� ��û ���α׷�',getdate(),'N')
insert into mrbook.dbo.roommast values ('023603','������û','3','2','�Ե��ַ� ���� ��û ���α׷�',getdate(),'N','1')

alter table mrbook.dbo.roommast add companyCd varchar(10)
use mrbook

begin tran
update mrbook.dbo.roommast
set delYN = 'Y'
where domain_id = '11' AND companyCd = 'car'
-- companyGbn in ('023601','023603')
--companyGbn = '023601' OR companyGbn = '023600'
commit

select * from dbo.roommast (nolock) where delYN = 'N' AND domain_id = '11' order by sortOrder

select * from mrbook.[dbo].[roommast]
select * from [dbo].[roominfo]

select * from dbo.roommast (nolock) where delYN = 'N' AND domain_id = '11' order by sortOrder

select * from dbo.roommast (nolock) where delYN = 'N' and domain_id = '11' order by sortOrder
     �� �� select * from dbo.roommast (nolock) where delYN = 'N' and domain_id = '11' order by sortOrder
 ȸ�ǽ� 


  �� �� ȸ�ǽ� 
   
 
 

 
 
 
 
   
 
 
select * from im30.[dbo].[org_domain]
 
 
