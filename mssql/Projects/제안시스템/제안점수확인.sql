
--제안 점수 확인 


-- 제안자 사번으로 검색 
select top 100 * from dbo.INOC_MILEAGE_TBL where mileage_userno = '19212082'


-- 해당 제안서 누구에게 제안점수가 갔는지 
select top 100 * from dbo.INOC_MILEAGE_TBL where document_key = 'I20150200450'   -- 제안건에 대한 마일리지 누가 받은지