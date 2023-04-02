 
 -- 전체 임직원 카운터 
 select 
 	count(*) as userCnt 
 from INOC_USER_TBL a 
 inner join INOC_USERINFO_TBL b on a.company = b.company 
 and a.user_no = b.user_no 
 and b.user_valid = 'Y' 


 -- 랭킹 
  select RANK() Over(order by isnull(sum(c.mileage_mileage), 0) desc) as Ranking       
  ,	a.user_no       
  ,	isnull(sum(c.mileage_mileage), 0) as mileage_mileage      
  from INOC_USER_TBL a       
  inner join INOC_USERINFO_TBL b on a.company=b.company      
  							  and a.user_no = b.user_no      
  left outer join INOC_MILEAGE_TBL c on a.company=c.company      
  								  and a.user_no = c.mileage_userno      
  								  and convert(nchar(4), c.mileage_writedate, 112) = '2018'      
  								  and convert(nchar(8), c.mileage_writedate, 112) >= '20130901'      
  where 1=1      
  and  b.user_valid='Y'      
  group by a.user_no      

