--회계공지	273  	
select * from Bd.BoardBase where BoardID = '273'

select * from Bd.BoardBase where  MigMessageID IN 
(
'690',
'685',
'677',
'670',
'667',
'660',
'653',
'649',
'646',
'642',
'636',
'631',
'628',
'624',
'620',
'614',
'611')
begin tran 
UPDATE Bd.BoardBase
SET BoardID='273'
WHERE MigMessageID IN 
(
'690',
'685',
'677',
'670',
'667',
'660',
'653',
'649',
'646',
'642',
'636',
'631',
'628',
'624',
'620',
'614',
'611')
--총 17건
commit


690
685
677
670
667
660
653
649
646
642
636
631
628
624
620
614
611
