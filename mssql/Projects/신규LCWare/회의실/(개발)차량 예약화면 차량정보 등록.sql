
rollback
/******************
* 차량 추가
*******************/
('','3','경차(스파크)','','영업','영업지원담당','4','','','','','','','',getdate(),getdate(),'N','3','N','31수9523','2','11',''),
--commit
begin tran
insert into [dbo].[roominfo] values
('','1','경차(모닝)','','지원','자금담당','4','','','','','','','',getdate(),getdate(),'N','3','N','49나0442','2','11','하이패스 단말기'),
('','2','승용차(아반떼)','','지원','S&OP담당','5','','','','','','','',getdate(),getdate(),'N','3','N','23머6520','2','11','하이패스 단말기'),
('','3','경차(스파크)','','영업','영업지원담당','4','','','','','','','',getdate(),getdate(),'N','3','N','31수9523','2','11',''),
('','4','경차(스파크)','','영업','채널담당','4','','','','','','','',getdate(),getdate(),'N','4','N','31수9502','2','11',''),
('','5','승용차(아반떼)','','영업','영업전략담당','5','','','','','','','',getdate(),getdate(),'N','5','N','69우2529','2','11',''),
('','6','승용차(아반떼)','','영업','EDS기획담당','5','','','','','','','',getdate(),getdate(),'N','6','Y','63하5370','2','11',''),
('','7','승용차(SM3)','','생산','기술1담당','5','','','','','','','',getdate(),getdate(),'N','7','N','15두0617','2','11',''),
('','8','승용차(쏘나타)','','생산','품질보증담당','5','','','','','','','',getdate(),getdate(),'N','8','N','63호1175','2','11','')

begin tran
update [dbo].[roominfo]
set location = 3
where locationNm = '생산'

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
      And locationNm = '지원' 
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


