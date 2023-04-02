

-- 구매결의서(아사히), 구매의뢰서(아사히) 2014년 1월부터 12월까지 건수 추출


use ewfform
-- YC05DF302C43742958445939F7E97CFF7   --구매결의서(아사히)
--select top 1 * from form_YC05DF302C43742958445939F7E97CFF7 WHERE CREATOR_DEPT like '%아사히%' order by suggestdate     
--select count(*) from form_YC05DF302C43742958445939F7E97CFF7 WHERE CREATOR_DEPT like '%아사히%'      --2010-06-30

select count(*) from form_YC05DF302C43742958445939F7E97CFF7 WHERE suggestdate > '2014' AND suggestdate < '20141232'
select count(*) from form_YC05DF302C43742958445939F7E97CFF7 WHERE suggestdate > '20131231' AND suggestdate < '20140201'
select count(*) from form_YC05DF302C43742958445939F7E97CFF7 WHERE suggestdate > '201402' AND suggestdate < '201403'
select count(*) from form_YC05DF302C43742958445939F7E97CFF7 WHERE suggestdate > '201403' AND suggestdate < '201404'
select count(*) from form_YC05DF302C43742958445939F7E97CFF7 WHERE suggestdate > '201404' AND suggestdate < '201405'
select * from form_YC05DF302C43742958445939F7E97CFF7 WHERE suggestdate > '201405' AND suggestdate < '201406'
select count(*) from form_YC05DF302C43742958445939F7E97CFF7 WHERE suggestdate > '201406' AND suggestdate < '201407'
select count(*) from form_YC05DF302C43742958445939F7E97CFF7 WHERE suggestdate > '201407' AND suggestdate < '201408'
select count(*) from form_YC05DF302C43742958445939F7E97CFF7 WHERE suggestdate > '201408' AND suggestdate < '201409'
select * from form_YC05DF302C43742958445939F7E97CFF7 WHERE suggestdate > '201409' AND suggestdate < '201410'
select count(*) from form_YC05DF302C43742958445939F7E97CFF7 WHERE suggestdate > '201410' AND suggestdate < '201411'
select count(*) from form_YC05DF302C43742958445939F7E97CFF7 WHERE suggestdate > '201411' AND suggestdate < '201412'
select count(*) from form_YC05DF302C43742958445939F7E97CFF7 WHERE suggestdate > '201412' AND suggestdate < '201501'










--Y07D3A5CE2A10422982430EBECA4E93D9	구매의뢰서(아사히)
select count(*) from form_Y07D3A5CE2A10422982430EBECA4E93D9 WHERE CREATOR_DEPT like '%아사히%'     --2010-06-30
select * from form_Y07D3A5CE2A10422982430EBECA4E93D9    --2010-06-30
select count(doc_name) from form_Y07D3A5CE2A10422982430EBECA4E93D9   group by doc_name   --5602
select count(doc_name) from form_Y07D3A5CE2A10422982430EBECA4E93D9 WHERE suggestdate > '20140401' AND suggestdate <'20150501'  group by doc_name --2029
select count(doc_name) from form_Y07D3A5CE2A10422982430EBECA4E93D9 WHERE suggestdate > '2010' AND suggestdate <'2011'  group by doc_name --144
select count(doc_name) from form_Y07D3A5CE2A10422982430EBECA4E93D9 WHERE suggestdate > '2011' AND suggestdate <'2012'  group by doc_name --509
select count(doc_name) from form_Y07D3A5CE2A10422982430EBECA4E93D9 WHERE suggestdate > '2012' AND suggestdate <'2013'  group by doc_name --560
select count(doc_name) from form_Y07D3A5CE2A10422982430EBECA4E93D9 WHERE suggestdate > '2013' AND suggestdate <'2014'  group by doc_name --300
select count(doc_name) from form_Y07D3A5CE2A10422982430EBECA4E93D9 WHERE suggestdate > '2014' AND suggestdate <'2015'  group by doc_name --420
select count(doc_name) from form_Y07D3A5CE2A10422982430EBECA4E93D9 WHERE suggestdate > '2015' AND suggestdate <'2016'  group by doc_name --168

select count(*) from form_Y07D3A5CE2A10422982430EBECA4E93D9 WHERE suggestdate > '2014' AND suggestdate < '20141232'
select count(*) from form_Y07D3A5CE2A10422982430EBECA4E93D9 WHERE suggestdate > '20131231' AND suggestdate < '20140201'
select count(*) from form_Y07D3A5CE2A10422982430EBECA4E93D9 WHERE suggestdate > '201402' AND suggestdate < '201403'
select count(*) from form_Y07D3A5CE2A10422982430EBECA4E93D9 WHERE suggestdate > '201403' AND suggestdate < '201404'
select count(*) from form_Y07D3A5CE2A10422982430EBECA4E93D9 WHERE suggestdate > '201404' AND suggestdate < '201405'
select * from form_Y07D3A5CE2A10422982430EBECA4E93D9 WHERE suggestdate > '201405' AND suggestdate < '201406' order by suggestdate   
select count(*) from form_Y07D3A5CE2A10422982430EBECA4E93D9 WHERE suggestdate > '201406' AND suggestdate < '201407'
select count(*) from form_Y07D3A5CE2A10422982430EBECA4E93D9 WHERE suggestdate > '201407' AND suggestdate < '201408'
select count(*) from form_Y07D3A5CE2A10422982430EBECA4E93D9 WHERE suggestdate > '201408' AND suggestdate < '201409'
select * from form_Y07D3A5CE2A10422982430EBECA4E93D9 WHERE suggestdate > '201409' AND suggestdate < '201410' order by suggestdate   
select count(*) from form_Y07D3A5CE2A10422982430EBECA4E93D9 WHERE suggestdate > '201410' AND suggestdate < '201411'
select count(*) from form_Y07D3A5CE2A10422982430EBECA4E93D9 WHERE suggestdate > '201411' AND suggestdate < '201412'
select count(*) from form_Y07D3A5CE2A10422982430EBECA4E93D9 WHERE suggestdate > '201412' AND suggestdate < '201501'