begin tran 
update im80.[dbo].[org_user]
set ex_mmoin_yn = 'Y'
where code in 
(
'2010A083',
'20120006',
'20145751',
'2010A072',
'19448494',
'20047036',
'2010A674',
'20112430',
'20111940',
'20046456',
'2010A675',
'19701263',
'20112424',
'20031084',
'2010A676',
'2010A689',
'2010A677',
'2010A678',
'20011188',
'19900671',
'20111563',
'2010A680',
'19504187',
'20030732',
'20071301',
'2010A685',
'2010A683',
'2010A081',
'2010A094',
'2010A684',
'19108264' )
commit
select ex_mmoin_yn from org_user where code in
(
'2010A083',
'20120006',
'20145751',
'2010A072',
'19448494',
'20047036',
'2010A674',
'20112430',
'20111940',
'20046456',
'2010A675',
'19701263',
'20112424',
'20031084',
'2010A676',
'2010A689',
'2010A677',
'2010A678',
'20011188',
'19900671',
'20111563',
'2010A680',
'19504187',
'20030732',
'20071301',
'2010A685',
'2010A683',
'2010A081',
'2010A094',
'2010A684',
'19108264' )