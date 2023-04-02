use mrbook
[dbo].[roominfo]
commit
rollback

begin tran
insert into [dbo].[roominfo]
values 
('','11','3-1 회의실','1','롯데캐슬본사','3층 (음료 신유통팀 뒤)','21','Y','N','N','','Y','N','Y',getdate(),getdate(),'N','1','N','','1','11'),
('','12','3-2 회의실','1','롯데캐슬본사','3층 (음료 신유통팀 뒤)','6','N','N','N','','Y','N','Y',getdate(),getdate(),'N','2','N','','1','11'),
('','13','3-3 회의실','1','롯데캐슬본사','3층 (음료 신유통팀 뒤)','8','N','N','N','','Y','N','Y',getdate(),getdate(),'N','3','N','','1','11'),
('','14','4-2 회의실','1','롯데캐슬본사','4층 (음료 브랜드팀 옆)','10','Y','N','N','','Y','N','Y',getdate(),getdate(),'N','5','N','','1','11'),
('','15','윤리경영팀 회의실','3','잠실루터회관','6층 (윤리경영팀 옆)','8','N','N','N','','Y','N','Y',getdate(),getdate(),'N','2','N','','1','11')

begin tran
update [dbo].[roominfo]
set roomNm = '5-1 회의실', sortOrder = '6', floor = '5층 (음료 지원팀 앞)'
where roomNo = '2'

update [dbo].[roominfo]
set roomNm = '5-2 회의실', sortOrder = '7', floor = '5층 (인포데스크 옆)'
where roomNo = '3'

update [dbo].[roominfo]
set roomNm = '5-3 회의실', sortOrder = '8', floor = '5층 (음료 기획팀 옆)'
where roomNo = '4'

update [dbo].[roominfo]
set roomNm = '5-4 회의실', sortOrder = '9',  floor = '5층 (주류 영업지원팀 옆)'
where roomNo = '5'

update [dbo].[roominfo]
set roomNm = '5-5 회의실', sortOrder = '10', floor = '5층 (주류 해외영업팀 옆)'
where roomNo = '6'

update [dbo].[roominfo]
set roomNm = '5-6 회의실', sortOrder = '11', floor = '5층 (주류 해외영업팀 옆)'
where roomNo = '7'		

update [dbo].[roominfo]
set roomNm = '4-1 회의실', sortOrder = '4', numPersons = '20', projectorYn = 'Y', floor = '4층 (음료 영업지원팀 옆)'
where roomNo = '8'		

update [dbo].[roominfo]
set roomNm = '생산본부 회의실', sortOrder = '1', floor = '4층 (생산본부 內)'
where roomNo = '9'	

update [dbo].[roominfo]
set roomNm = '전산팀 회의실', sortOrder = '1', floor = '6층 (전산팀 內)'
where roomNo = '1'	

update [dbo].[roominfo]
set delYN = 'Y'
where roomNo = '10'




select @@trancount