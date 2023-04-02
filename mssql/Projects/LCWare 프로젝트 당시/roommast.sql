
update mrbook.dbo.roommast
set sortOrder = '2'
where companyNm = '차량신청'

insert into mrbook.dbo.roommast values ('023602','회의실','3','1','롯데주류 회의실 신청 프로그램',getdate(),'N')
insert into mrbook.dbo.roommast values ('023603','차량신청','3','2','롯데주류 차량 신청 프로그램',getdate(),'N','1')

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
     김 영 select * from dbo.roommast (nolock) where delYN = 'N' and domain_id = '11' order by sortOrder
 회의실 


  김 영 회의실 
   
 
 

 
 
 
 
   
 
 
select * from im30.[dbo].[org_domain]
 
 
