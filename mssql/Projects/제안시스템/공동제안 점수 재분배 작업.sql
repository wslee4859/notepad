insert into INOC_MILEAGE_TBL 
 ( 
      company 
 ,    mileage_key 
 ,    document_key 
 ,    document_sort 
 ,    mileage_proctype 
 ,    mileage_deptcd 
 ,    mileage_deptnm 
 ,    mileage_userno 
 ,    mileage_grade 
 ,    mileage_gradenm 
 ,    mileage_mileage 
 ,    mileage_money 
 ,    mileage_type 
 ,    mileage_writedate 
 ) 
select 
     a.company 
 ,   ( select isnull( max(mileage_key), 0) + 1 from INOC_MILEAGE_DETAIL_TBL where company = '00000001' ) + ROW_NUMBER() Over (Order By a.document_key desc)
 ,   a.document_key 
 ,   ( select isnull( max(document_sort), 0) + 1 from INOC_MILEAGE_TBL where company = '00000001' ) + ROW_NUMBER() Over (Order By a.document_key desc)
 ,   document_proctype 
 ,   document_deptcd  
 ,   document_deptnm  
 ,   document_workerno
 ,   document_grade 
 ,   document_gradenm 
 ,	 '' --grade_money 
 ,	 '' --grade_value  
 ,	'U'  + document_proctype 
 ,	getdate() 
 from	INOC_DOCUMENT_MASTER_TBL  a
 inner  join INOC_ADMIN_GRADE_TBL b
 on		a.company = b.company 
 and	a.document_typecd = b.grade_typecd 
 and	a.document_grade = b.grade_code 
 where	a.company =  '00000001'
 and	a.document_key  in ( 'I20180500002')


 ******************************************************************************************************

[dbo].[INOC_DOCUMENT_JOIN_TBL] WHERE  document_key  in ( 'I20170800820')
00000001	I20170200738	1	00592   	광주생산담당              	19503637	50
00000001	I20170200738	2	00592   	광주생산담당              	20150896	50


1. mileage_key, document_sort 키 확인 
	select * from INOC_MILEAGE_TBL where document_key  in ( 'I20170800820')
	29306
2. INSERT 안된거 입력 
	INSERT INOC_MILEAGE_TBL

3. 기존 점수 확인 
	select * from INOC_MILEAGE_TBL where document_key  in ( 'I20170900447') 
	select * from INOC_MILEAGE_DETAIL_TBL where mileage_key = '36279' 
	select * from INOC_MILEAGE_DETAIL_TBL where mileage_content like '%I20170900729%' 
4. 마일리지 키 수정



--commit
rollback

begin tran 
insert into INOC_MILEAGE_TBL 
 ( 
      company 
 ,    mileage_key 
 ,    document_key 
 ,    document_sort 
 ,    mileage_proctype 
 ,    mileage_deptcd 
 ,    mileage_deptnm 
 ,    mileage_userno 
 ,    mileage_grade 
 ,    mileage_gradenm 
 ,    mileage_mileage 
 ,    mileage_money 
 ,    mileage_type 
 ,    mileage_writedate 
 ) 
select 
     a.company 
 ,   ( select isnull( max(mileage_key), 0) + 1 from INOC_MILEAGE_DETAIL_TBL where company = '00000001' ) + ROW_NUMBER() Over (Order By a.document_key desc)
 ,   a.document_key 
 ,   ( select isnull( max(document_sort), 0) + 1 from INOC_MILEAGE_TBL where company = '00000001' ) + ROW_NUMBER() Over (Order By a.document_key desc)
 ,   document_proctype 
 ,   c.document_deptcd  
 ,   c.document_deptnm  
 ,   c.document_userno
 ,   document_grade 
 ,   document_gradenm 
 ,	 (grade_money * document_role / 100) --grade_money 
 --,	 (grade_value * document_role / 100) --grade_value  
 , '7500'
 ,	'U'  + document_proctype 
 ,	getdate()      -- 처음 승인된 날짜로 입력해야됨. 
 from	INOC_DOCUMENT_MASTER_TBL  a 
 inner  join INOC_ADMIN_GRADE_TBL b 
 on		a.company = b.company  
 inner  join [dbo].[INOC_DOCUMENT_JOIN_TBL] c 
 on     a.document_key = c.document_key    AND c.document_sort != '1'
 and	a.document_typecd = b.grade_typecd 
 and	a.document_grade = b.grade_code 
 where	a.company =  '00000001'
 and	a.document_key  in ( 'I20170800820')
 

 insert into INOC_MILEAGE_DETAIL_TBL 
 ( 
     company 
     , mileage_key 
     , mileage_content 
 ) 
 select 
 	 a.company 
 ,   ( select isnull( max(mileage_key), 0) + 1 from INOC_MILEAGE_DETAIL_TBL where company = '00000001' ) + ROW_NUMBER() Over (Order By a.document_key desc) 
 ,	'제안[' + a.document_key + ']' + document_gradenm + ' | ' +  convert(nvarchar(1000), ( select (grade_money * document_role / 100) from INOC_ADMIN_GRADE_TBL where grade_code =  document_grade))
     from INOC_DOCUMENT_MASTER_TBL a 
     inner join INOC_ADMIN_CODE_TBL b on a.company = b.company 
                                     and b.code_highcd = 'BA4D5711' 
                                     and a.document_typecd = b.code_type1 
	  inner  join [dbo].[INOC_DOCUMENT_JOIN_TBL] c
 on     a.document_key = c.document_key    AND c.document_sort != '1'
 where a.company = '00000001'
 and	a.document_key in ('I20170800820')

 --commit

 rollback
 -- 기존 점수 수정 
  select * from INOC_MILEAGE_TBL where document_key in ('I20170800820')
 select * from INOC_MILEAGE_DETAIL_TBL where mileage_key in (select mileage_key from INOC_MILEAGE_TBL where document_key  in ( 'I20170800820'))
begin tran
update INOC_MILEAGE_TBL
set mileage_mileage = '4' , mileage_money = '15000'
where mileage_key = '35331'


update INOC_MILEAGE_DETAIL_TBL
set mileage_content = '제안[I20170800820]개선상                  | 2'
where mileage_key = '35331' 
 
 --commit


-- 날짜 수정
select * from INOC_MILEAGE_TBL  where document_key  in ( 'I20170800820')

 begin tran
 update INOC_MILEAGE_TBL
 set mileage_writedate = '2017-09-06 09:41:30.303'
 where mileage_key in ('40535','40536')
 commit

 select @@trancount

 rollback
 -------------------------------------------------------------------------------------------------------------------------------------

-- 2017년 11월 이전 규정 점수 재분배 작업

I20170900447 
I20170800820 
 
 
 


 
 
 select * from [dbo].[INOC_DOCUMENT_JOIN_TBL] WHERE  document_key  in ( 'I20170800820')
1. mileage_key, document_sort 키 확인 
	select * from INOC_MILEAGE_TBL where document_key  in ( 'I20170800820')



/*
--begin tran 
--update INOC_MILEAGE_TBL 
--set mileage_money = '2500'
--where document_key  in ( 'I20170100613','I20170100834','I20170200738','I20170300845','I20170500470','I20170700615')
--commit



begin tran 
update INOC_MILEAGE_TBL 
set mileage_money = '15000' 
where document_key  in ( 'I20170800296') 
commit

begin tran
update INOC_MILEAGE_TBL 
set mileage_money = '10200' 
where mileage_key = '35261' and document_key  in ( 'I20170800551') 
commit


begin tran
update INOC_MILEAGE_TBL 
set mileage_money = '9900' 
where mileage_key in ('40414','40415') and document_key  in ( 'I20170800551')  
commit
*/





begin tran
update INOC_MILEAGE_DETAIL_TBL
set mileage_content = '제안[I20170600448]개선상                  | 4'
where  mileage_key in ('33715' ,'40396')

begin tran 
update INOC_MILEAGE_TBL 
set mileage_money = '15000', mileage_mileage = '4'
where document_key  in ( 'I20170600448') 

commit