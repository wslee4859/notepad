use mrbook

select * from [dbo].[roommast]

update dbo.roommast
set bookType = 2
where companyNm = '차량신청'


select * from dbo.roommast (nolock) where delYN = 'N' and domain_id = '11' and bookType = '1' order by sortOrder



select * from [dbo].[roominfo] 
where companyGbn = '023601'

update dbo.roominfo
set domain_id = '1'
where companyGbn = '023603'

Alter table dbo.roominfo add  domain_id varchar(2)

select * from [dbo].[mrbooklist]
select * from [dbo].[calendar]
select * from [dbo].[userinfo]


-- mrbooklist
select * from [dbo].[mrbooklist]

alter table dbo.mrbooklist add bookType int
alter table dbo.mrbooklist add domain_id varchar(2)
