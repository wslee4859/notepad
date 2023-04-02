select * from mrbook.[dbo].[roominfo] where location = '1' order by sortOrder 
select * from mrbook.[dbo].[roominfo] where bookType = '2' order by sortOrder 
insert into [dbo].[roominfo] values ('023603','1','무쏘','1','광명물류센터','1','8','N','N','N','02-3479-9299','Y','N','Y',getdate(),getdate(),'N','1','N','대구45라9289')


insert into [dbo].[roominfo] values ('','1','전산팀회의실','3','잠실루터회관','6','10','N','N','N','02-3479-9299','Y','N','Y',getdate(),getdate(),'N','1','N','','1','11')
insert into [dbo].[roominfo] values ('','2','5-1','1','롯데캐슬본사','5','10','N','N','N','','Y','N','Y',getdate(),getdate(),'N','2','N','','1','11')
insert into [dbo].[roominfo] values ('','3','5-2','1','롯데캐슬본사','5','10','N','N','N','','Y','N','Y',getdate(),getdate(),'N','3','N','','1','11')
insert into [dbo].[roominfo] values ('','4','5-3','1','롯데캐슬본사','5','10','N','N','N','','Y','N','Y',getdate(),getdate(),'N','4','N','','1','11')
insert into [dbo].[roominfo] values ('','5','5-4','1','롯데캐슬본사','5','10','N','N','N','','Y','N','Y',getdate(),getdate(),'N','5','N','','1','11')
insert into [dbo].[roominfo] values ('','6','5-5','1','롯데캐슬본사','5','10','N','N','N','','Y','N','Y',getdate(),getdate(),'N','6','N','','1','11')
insert into [dbo].[roominfo] values ('','7','5-6','1','롯데캐슬본사','5','10','N','N','N','','Y','N','Y',getdate(),getdate(),'N','7','N','','1','11')
insert into [dbo].[roominfo] values ('','8','회의실 4-1','1','롯데캐슬본사','5','10','N','N','N','','Y','N','Y',getdate(),getdate(),'N','8','N','','1','11')
insert into [dbo].[roominfo] values ('','9','회의실','2','시그마타워','7','10','N','N','N','','Y','N','Y',getdate(),getdate(),'N','9','N','','1','11')


begin tran 
insert into [dbo].[roominfo] (roomNo, roomNm, locationNm, numPersons, indate, changedate, delYN, sortOrder, carNo, bookType, domain_id, remark)
values ('2', 'BMW','전산팀','6',getdate(),getdate(),'N','2','31허0411','2','11','네비게이션')

commit
rollback


-- 업데이트 
begin tran
update mrbook.dbo.roominfo
set delYN = 'N' , roomNm = '5-4 A 회의실', floor = '5층 (주류 영업지원팀 옆)',
numPersons = '6', projectorYn = 'Y', wboardYn = 'Y', videoYn = 'N', sortOrder = '10'
--set numPersons = '30'
where roomNo = '10'
commit

rollback
--테이블  행 삭제 
begin tran
delete mrbook.dbo.roominfo
where roomNo in ('7')
commit


begin tran
update mrbook.dbo.roominfo
set projectorYn = 'N'
where roomNo = '10'
commit


begin tran
update mrbook.dbo.roominfo
set roomNo = '18' , naviYn = 'N' 
--set numPersons = '30'
where roomNo = '2' AND bookType = '2'


commit