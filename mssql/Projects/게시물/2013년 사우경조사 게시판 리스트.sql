
--LCWare �������� 
--convert(datetime,convert(char(8),20070320),112)
--convert(datetime,'20121231',120)

--2013�⵵ 
select * from eGW.[dbo].[TB_CELEBRATION] where CreateDate > convert(datetime,'20130101',120) AND CreateDate < convert(datetime,'20140101',120) order by CreateDate 

--2012����� �ֱ� 
select * from eGW.[dbo].[TB_CELEBRATION] where CreateDate > convert(datetime,'20120101',120) AND CreateDate < convert(datetime,getdate(),120) order by CreateDate 

select convert(datetime,'2013010',120)