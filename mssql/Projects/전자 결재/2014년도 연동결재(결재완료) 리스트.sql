use ewfform
--declare @startDate varchar(30),
--		@endDate varchar(30)
-- 변수지정 못하는게 변수지정하면 변수까지 F5번으로 전체 실행을 해야함. 일일이 블록으로 실행 못함.(테이블명도 변수지정안됨)



--YC4EBC95FF8E44A87AD77392D2914166C   --예산부서월실적
select SUBJECT, DOC_NUMBER, CREATOR_DEPT, CREATOR, SUGGESTDATE 
from form_YC4EBC95FF8E44A87AD77392D2914166C
where suggestdate > '2014' AND suggestdate <'2015' AND PROCESS_INSTANCE_STATE ='7'  order by suggestdate


--form_Y747BB57D3D334E53A0CA83F8BE4E379C    변동예산신청서
select SUBJECT, DOC_NUMBER, CREATOR_DEPT, CREATOR, SUGGESTDATE 
from form_Y747BB57D3D334E53A0CA83F8BE4E379C
where suggestdate > '2014' AND suggestdate <'2015' AND PROCESS_INSTANCE_STATE ='7'  order by suggestdate



-- form_YAE7EEC57433B4884AAC95B65128C3F0A        YAE7EEC57433B4884AAC95B65128C3F0A   거래서품위지원서
select SUBJECT, DOC_NUMBER, CREATOR_DEPT, CREATOR, SUGGESTDATE 
from form_YAE7EEC57433B4884AAC95B65128C3F0A
where suggestdate > '2014' AND suggestdate <'2015' AND PROCESS_INSTANCE_STATE ='7'  order by suggestdate


--form_YB9222DABFA484AC6AC97F2A23C649789        
	 --YB9222DABFA484AC6AC97F2A23C649789
select SUBJECT, DOC_NUMBER, CREATOR_DEPT, CREATOR, SUGGESTDATE 
from form_YB9222DABFA484AC6AC97F2A23C649789
where suggestdate > '2014' AND suggestdate <'2015' AND PROCESS_INSTANCE_STATE ='7'  order by suggestdate

--Y1A35F931BEE0476E8119290B4240C7D2--어음수표잔고명세서
select SUBJECT, DOC_NUMBER, CREATOR_DEPT, CREATOR, SUGGESTDATE 
from form_Y1A35F931BEE0476E8119290B4240C7D2
where suggestdate > '2014' AND suggestdate <'2015' AND PROCESS_INSTANCE_STATE ='7'  order by suggestdate


--Y8D4A994E63054A5EB14621BDD3A4483E   --구매의뢰서
select SUBJECT, DOC_NUMBER, CREATOR_DEPT, CREATOR, SUGGESTDATE 
from form_Y8D4A994E63054A5EB14621BDD3A4483E
where suggestdate > '2014' AND suggestdate <'2015' AND PROCESS_INSTANCE_STATE ='7'  order by suggestdate


-- Y7E5B0FAAB0674180B1172BA02147A81E  입학축의금
-- Y7E5B0FAAB0674180B1172BA02147A81E
select SUBJECT, DOC_NUMBER, CREATOR_DEPT, CREATOR, SUGGESTDATE 
from form_Y7E5B0FAAB0674180B1172BA02147A81E
where suggestdate > '2014' AND suggestdate <'2015' AND PROCESS_INSTANCE_STATE ='7'  order by suggestdate

--Y54CFE93E9F684353B8861A1B4644EAEE   판매용장비신청서
select SUBJECT, DOC_NUMBER, CREATOR_DEPT, CREATOR, SUGGESTDATE 
from form_Y54CFE93E9F684353B8861A1B4644EAEE
where suggestdate > '2014' AND suggestdate <'2015' AND PROCESS_INSTANCE_STATE ='7'  order by suggestdate

--YA97EEB2C70C141EDA9A553E0135C7A0C   -- 항목변경신청서
select SUBJECT, DOC_NUMBER, CREATOR_DEPT, CREATOR, SUGGESTDATE 
from form_YA97EEB2C70C141EDA9A553E0135C7A0C
where suggestdate > '2014' AND suggestdate <'2015' AND PROCESS_INSTANCE_STATE ='7'  order by suggestdate


-- Y3AAADA3BB0CE45D58106CDB1CA308EE1   --구매결의서
select SUBJECT, DOC_NUMBER, CREATOR_DEPT, CREATOR, SUGGESTDATE 
from form_Y3AAADA3BB0CE45D58106CDB1CA308EE1
where suggestdate > '2014' AND suggestdate <'2015' AND PROCESS_INSTANCE_STATE ='7'  order by suggestdate


--YB8260780E3D44144AD24B38163F5AF88   --출고의뢰서
select SUBJECT, DOC_NUMBER, CREATOR_DEPT, CREATOR, SUGGESTDATE 
from form_YB8260780E3D44144AD24B38163F5AF88
where suggestdate > '2014' AND suggestdate <'2015' AND PROCESS_INSTANCE_STATE ='7'  order by suggestdate


-- Y2641100C6E3F4A0FB8B23776E6E79F1B 부가세 신고서
select SUBJECT, DOC_NUMBER, CREATOR_DEPT, CREATOR, SUGGESTDATE 
from form_Y2641100C6E3F4A0FB8B23776E6E79F1B
where suggestdate > '2014' AND suggestdate <'2015' AND PROCESS_INSTANCE_STATE ='7'  order by suggestdate


--Y6974AA653C114E53AC44157AA05F19EF    --반납의뢰서
select SUBJECT, DOC_NUMBER, CREATOR_DEPT, CREATOR, SUGGESTDATE 
from form_Y6974AA653C114E53AC44157AA05F19EF
where suggestdate > '2014' AND suggestdate <'2015' AND PROCESS_INSTANCE_STATE ='7'  order by suggestdate

-- Y761BB6954DC2408FA7927804B7E5BA4D SpareParts사용보고서
select SUBJECT, DOC_NUMBER, CREATOR_DEPT, CREATOR, SUGGESTDATE 
from form_Y761BB6954DC2408FA7927804B7E5BA4D
where suggestdate > '2014' AND suggestdate <'2015' AND PROCESS_INSTANCE_STATE ='7'  order by suggestdate

--Y42EF509649FD4AAA80646C681FDBF7B5    --판매장비철수요청서
select SUBJECT, DOC_NUMBER, CREATOR_DEPT, CREATOR, SUGGESTDATE 
from form_Y42EF509649FD4AAA80646C681FDBF7B5
where suggestdate > '2014' AND suggestdate <'2015' AND PROCESS_INSTANCE_STATE ='7'  order by suggestdate

--Y5149C2A149D24EADA29D306082EBA5F3    판매장비설치요청서
select SUBJECT, DOC_NUMBER, CREATOR_DEPT, CREATOR, SUGGESTDATE 
from form_Y5149C2A149D24EADA29D306082EBA5F3
where suggestdate > '2014' AND suggestdate <'2015' AND PROCESS_INSTANCE_STATE ='7'  order by suggestdate


--YFEA425C4FB9346D0B81C119099FB5F35 판매장비교체요청서
select SUBJECT, DOC_NUMBER, CREATOR_DEPT, CREATOR, SUGGESTDATE 
from form_YFEA425C4FB9346D0B81C119099FB5F35
where suggestdate > '2014' AND suggestdate <'2015' AND PROCESS_INSTANCE_STATE ='7'  order by suggestdate

-- YF2F3672C68C148E3841A6C236DE6A504  차량수불내역
select SUBJECT, DOC_NUMBER, CREATOR_DEPT, CREATOR, SUGGESTDATE 
from form_YF2F3672C68C148E3841A6C236DE6A504
where suggestdate > '2014' AND suggestdate <'2015' AND PROCESS_INSTANCE_STATE ='7'  order by suggestdate


--YC231645BE11A4A0A9358F60410C222C4  선급금일별잔액현황
select SUBJECT, DOC_NUMBER, CREATOR_DEPT, CREATOR, SUGGESTDATE 
from form_YC231645BE11A4A0A9358F60410C222C4
where suggestdate > '2014' AND suggestdate <'2015' AND PROCESS_INSTANCE_STATE ='7'  order by suggestdate

--YB68D2E23A8F74970967B4D08912F0B9C     --환경점검현황
select SUBJECT, DOC_NUMBER, CREATOR_DEPT, CREATOR, SUGGESTDATE 
from form_YB68D2E23A8F74970967B4D08912F0B9C
where suggestdate > '2014' AND suggestdate <'2015' AND PROCESS_INSTANCE_STATE ='7'  order by suggestdate


--Y35CED4073A514D94875F61A63FBE3666  환경점검주보
select SUBJECT, DOC_NUMBER, CREATOR_DEPT, CREATOR, SUGGESTDATE 
from form_Y35CED4073A514D94875F61A63FBE3666
where suggestdate > '2014' AND suggestdate <'2015' AND PROCESS_INSTANCE_STATE ='7'  order by suggestdate


--Y462E36DD55F74F098C8A3D141BB0FCCF  화재및안전사고점검주보
select SUBJECT, DOC_NUMBER, CREATOR_DEPT, CREATOR, SUGGESTDATE 
from form_Y462E36DD55F74F098C8A3D141BB0FCCF
where suggestdate > '2014' AND suggestdate <'2015' AND PROCESS_INSTANCE_STATE ='7'  order by suggestdate

--YDF9B8101D3C0454884DEDC383C620B71
select SUBJECT, DOC_NUMBER, CREATOR_DEPT, CREATOR, SUGGESTDATE 
from form_YDF9B8101D3C0454884DEDC383C620B71
where suggestdate > '2014' AND suggestdate <'2015' AND PROCESS_INSTANCE_STATE ='7'  order by suggestdate

--Y85CE2A875E674904A4FAB9D7E50375BB  인수인계서
select SUBJECT, DOC_NUMBER, CREATOR_DEPT, CREATOR, SUGGESTDATE 
from form_Y85CE2A875E674904A4FAB9D7E50375BB
where suggestdate > '2014' AND suggestdate <'2015' AND PROCESS_INSTANCE_STATE ='7'  order by suggestdate

--Y76D76F2606D748BE8E72C77D8B5D9AD9   -- 년간예산신청서
select SUBJECT, DOC_NUMBER, CREATOR_DEPT, CREATOR, SUGGESTDATE 
from form_Y76D76F2606D748BE8E72C77D8B5D9AD9
where suggestdate > '2014' AND suggestdate <'2015' AND PROCESS_INSTANCE_STATE ='7'  order by suggestdate

-- Y2AC6C1CC89A545C5A4350669B66271FA    --유가증권입고현황
select SUBJECT, DOC_NUMBER, CREATOR_DEPT, CREATOR, SUGGESTDATE 
from form_Y2AC6C1CC89A545C5A4350669B66271FA
where suggestdate > '2014' AND suggestdate <'2015' AND PROCESS_INSTANCE_STATE ='7'  order by suggestdate


-- Y85DE0C0BF5FE4764954B2C71D6E86100    --불량채권심사결과통보서
select SUBJECT, DOC_NUMBER, CREATOR_DEPT, CREATOR, SUGGESTDATE 
from form_Y85DE0C0BF5FE4764954B2C71D6E86100
where suggestdate > '2014' AND suggestdate <'2015' AND PROCESS_INSTANCE_STATE ='7'  order by suggestdate


--Y7738807F64624140A4EEA15167EBEF82  MOBILE장비사고보고서
select SUBJECT, DOC_NUMBER, CREATOR_DEPT, CREATOR, SUGGESTDATE 
from form_Y7738807F64624140A4EEA15167EBEF82
where suggestdate > '2014' AND suggestdate <'2015' AND PROCESS_INSTANCE_STATE ='7'  order by suggestdate

--Y107F69F84EF742A9A10EE695EDFB56DC   --판매장비이동요청서
select SUBJECT, DOC_NUMBER, CREATOR_DEPT, CREATOR, SUGGESTDATE 
from form_Y107F69F84EF742A9A10EE695EDFB56DC
where suggestdate > '2014' AND suggestdate <'2015' AND PROCESS_INSTANCE_STATE ='7'  order by suggestdate

-- Y83BC2165F7D640D7ACD9BD062327106E  판매장비부품사용보고서
select SUBJECT, DOC_NUMBER, CREATOR_DEPT, CREATOR, SUGGESTDATE 
from form_Y83BC2165F7D640D7ACD9BD062327106E
where suggestdate > '2014' AND suggestdate <'2015' AND PROCESS_INSTANCE_STATE ='7'  order by suggestdate

--Y816CA0D39251426586019F803013CB59  년간예산신청서(아사히)
select SUBJECT, DOC_NUMBER, CREATOR_DEPT, CREATOR, SUGGESTDATE 
from form_Y816CA0D39251426586019F803013CB59
where suggestdate > '2014' AND suggestdate <'2015' AND PROCESS_INSTANCE_STATE ='7'  order by suggestdate

--Y9A282068897043E08905CD42881773D5    --차량정비발생현황
select SUBJECT, DOC_NUMBER, CREATOR_DEPT, CREATOR, SUGGESTDATE 
from form_Y9A282068897043E08905CD42881773D5
where suggestdate > '2014' AND suggestdate <'2015' AND PROCESS_INSTANCE_STATE ='7'  order by suggestdate

-- YF57EBFF214194D0DB20F7B53FC26DEBE   -- 임대용 냉온수기 신청서
select SUBJECT, DOC_NUMBER, CREATOR_DEPT, CREATOR, SUGGESTDATE 
from form_YF57EBFF214194D0DB20F7B53FC26DEBE
where suggestdate > '2014' AND suggestdate <'2015' AND PROCESS_INSTANCE_STATE ='7'  order by suggestdate

-- Y07D3A5CE2A10422982430EBECA4E93D9 구매의뢰서(아사히)
select SUBJECT, DOC_NUMBER, CREATOR_DEPT, CREATOR, SUGGESTDATE 
from form_Y07D3A5CE2A10422982430EBECA4E93D9
where suggestdate > '2014' AND suggestdate <'2015' AND PROCESS_INSTANCE_STATE ='7'  order by suggestdate


-- YC05DF302C43742958445939F7E97CFF7   --구매결의서(아사히)
select SUBJECT, DOC_NUMBER, CREATOR_DEPT, CREATOR, SUGGESTDATE 
from form_YC05DF302C43742958445939F7E97CFF7
where suggestdate > '2014' AND suggestdate <'2015' AND PROCESS_INSTANCE_STATE ='7'  order by suggestdate

-- Y4741F41EBEE9457C9C76107DB444FFB8 이상발생보고서
select SUBJECT, DOC_NUMBER, CREATOR_DEPT, CREATOR, SUGGESTDATE 
from form_Y4741F41EBEE9457C9C76107DB444FFB8
where suggestdate > '2014' AND suggestdate <'2015' AND PROCESS_INSTANCE_STATE ='7'  order by suggestdate

--Y2B172D247B4B4E03A74ABC4B674FEA11   --차량사고보고서
select SUBJECT, DOC_NUMBER, CREATOR_DEPT, CREATOR, SUGGESTDATE 
from form_Y2B172D247B4B4E03A74ABC4B674FEA11
where suggestdate > '2014' AND suggestdate <'2015' AND PROCESS_INSTANCE_STATE ='7'  order by suggestdate


-- YAA6EC409DF3F41309D27D86DB9D606E7  --행사보고서
select SUBJECT, DOC_NUMBER, CREATOR_DEPT, CREATOR, SUGGESTDATE 
from form_YAA6EC409DF3F41309D27D86DB9D606E7
where suggestdate > '2014' AND suggestdate <'2015' AND PROCESS_INSTANCE_STATE ='7'  order by suggestdate

-- Y0028F2733E8B449A8186BC8922E5DBFE    --제상품의뢰서
select SUBJECT, DOC_NUMBER, CREATOR_DEPT, CREATOR, SUGGESTDATE 
from form_Y0028F2733E8B449A8186BC8922E5DBFE
where suggestdate > '2014' AND suggestdate <'2015' AND PROCESS_INSTANCE_STATE ='7'  order by suggestdate


-- Y58438F138FA641D9A31B8107F180129B   --변동투자예산신청서
select SUBJECT, DOC_NUMBER, CREATOR_DEPT, CREATOR, SUGGESTDATE 
from form_Y58438F138FA641D9A31B8107F180129B
where suggestdate > '2014' AND suggestdate <'2015' AND PROCESS_INSTANCE_STATE ='7'  order by suggestdate

-- Y7D123377DEBE43ED9EEADC93098C768E   --퇴직금계산서
select SUBJECT, DOC_NUMBER, CREATOR_DEPT, CREATOR, SUGGESTDATE 
from form_Y7D123377DEBE43ED9EEADC93098C768E
where suggestdate > '2014' AND suggestdate <'2015' AND PROCESS_INSTANCE_STATE ='7'  order by suggestdate


--Y7B497D24B8DB4D3E99741B7D4DD76227    --수출제품출고의뢰서
select SUBJECT, DOC_NUMBER, CREATOR_DEPT, CREATOR, SUGGESTDATE 
from form_Y7B497D24B8DB4D3E99741B7D4DD76227
where suggestdate > '2014' AND suggestdate <'2015' AND PROCESS_INSTANCE_STATE ='7'  order by suggestdate

-- Y4A71D90C86984A5E89158C23FFA0D19B    --수출제품출고의뢰서2
select SUBJECT, DOC_NUMBER, CREATOR_DEPT, CREATOR, SUGGESTDATE 
from form_Y4A71D90C86984A5E89158C23FFA0D19B
where suggestdate > '2014' AND suggestdate <'2015' AND PROCESS_INSTANCE_STATE ='7'  order by suggestdate


-- Y00BE91A5F6794FEC83D8BFEEB4E897CD    --정보시스템변경서
select SUBJECT, DOC_NUMBER, CREATOR_DEPT, CREATOR, SUGGESTDATE 
from form_Y00BE91A5F6794FEC83D8BFEEB4E897CD
where suggestdate > '2014' AND suggestdate <'2015' AND PROCESS_INSTANCE_STATE ='7'  order by suggestdate

--Y96114A5C446F45EAA7DED812C7BF1A54    --시스템권한신청서
select SUBJECT, DOC_NUMBER, CREATOR_DEPT, CREATOR, SUGGESTDATE 
from form_Y96114A5C446F45EAA7DED812C7BF1A54
where suggestdate > '2014' AND suggestdate <'2015' AND PROCESS_INSTANCE_STATE ='7'  order by suggestdate


-- YB8BBB793520E47748E392E1234610027   --전산처리의뢰서(CSR)
select SUBJECT, DOC_NUMBER, CREATOR_DEPT, CREATOR, SUGGESTDATE 
from form_YB8BBB793520E47748E392E1234610027
where suggestdate > '2014' AND suggestdate <'2015' AND PROCESS_INSTANCE_STATE ='7'  order by suggestdate


-- Y54C64AC297CD4218968B965CE9EA2482     --전산처리의뢰서(개발/변경)
select SUBJECT, DOC_NUMBER, CREATOR_DEPT, CREATOR, SUGGESTDATE 
from form_Y54C64AC297CD4218968B965CE9EA2482
where suggestdate > '2014' AND suggestdate <'2015' AND PROCESS_INSTANCE_STATE ='7'  order by suggestdate

-- Y34842D9B404A4D72A55DC5AED0C20BDC    --전산처리의뢰서(자료추출/권한요청)
select SUBJECT, DOC_NUMBER, CREATOR_DEPT, CREATOR, SUGGESTDATE 
from form_Y34842D9B404A4D72A55DC5AED0C20BDC
where suggestdate > '2014' AND suggestdate <'2015' AND PROCESS_INSTANCE_STATE ='7'  order by suggestdate

-- Y9818DD0694314EE3B0FD3157E6B21B81    --이월체상신청서
select SUBJECT, DOC_NUMBER, CREATOR_DEPT, CREATOR, SUGGESTDATE 
from form_Y9818DD0694314EE3B0FD3157E6B21B81
where suggestdate > '2014' AND suggestdate <'2015' AND PROCESS_INSTANCE_STATE ='7'  order by suggestdate


-- Y6FDAA64B62544CF1B4ABAD28550BFE23 포장소모품신청서
select SUBJECT, DOC_NUMBER, CREATOR_DEPT, CREATOR, SUGGESTDATE 
from form_Y6FDAA64B62544CF1B4ABAD28550BFE23
where suggestdate > '2014' AND suggestdate <'2015' AND PROCESS_INSTANCE_STATE ='7'  order by suggestdate


-- Y8410F34EDFE44A6098AF6F9938C8F8C2    --화재및안전사고점검일지
select SUBJECT, DOC_NUMBER, CREATOR_DEPT, CREATOR, SUGGESTDATE 
from form_Y8410F34EDFE44A6098AF6F9938C8F8C2
where suggestdate > '2014' AND suggestdate <'2015' AND PROCESS_INSTANCE_STATE ='7'  order by suggestdate


--Y41917174934749BAA72F13D558BFDAD9  전산처리완료보고서(CSR)
select SUBJECT, DOC_NUMBER, CREATOR_DEPT, CREATOR, SUGGESTDATE 
from form_Y41917174934749BAA72F13D558BFDAD9
where suggestdate > '2014' AND suggestdate <'2015' AND PROCESS_INSTANCE_STATE ='7'  order by suggestdate

--Y3EAF96CF291D44AD885E970420231CDD    --전산처리완료보고서(개발/변경)
select SUBJECT, DOC_NUMBER, CREATOR_DEPT, CREATOR, SUGGESTDATE 
from form_Y3EAF96CF291D44AD885E970420231CDD
where suggestdate > '2014' AND suggestdate <'2015' AND PROCESS_INSTANCE_STATE ='7'  order by suggestdate


-- YA8A03008E3B44079A4C41705CDA97979   --담보의뢰품의서
select SUBJECT, DOC_NUMBER, CREATOR_DEPT, CREATOR, SUGGESTDATE 
from form_YA8A03008E3B44079A4C41705CDA97979
where suggestdate > '2014' AND suggestdate <'2015' AND PROCESS_INSTANCE_STATE ='7'  order by suggestdate


-- Y0E59258A07B345E8864D70DB9531B186   사외교육수강신청서
select SUBJECT, DOC_NUMBER, CREATOR_DEPT, CREATOR, SUGGESTDATE 
from form_Y0E59258A07B345E8864D70DB9531B186
where suggestdate > '2014' AND suggestdate <'2015' AND PROCESS_INSTANCE_STATE ='7'  order by suggestdate


-- Y1154FBB3DE604374AABE54642BE7ADC5   --월근태현황보고서
select SUBJECT, DOC_NUMBER, CREATOR_DEPT, CREATOR, SUGGESTDATE 
from form_Y1154FBB3DE604374AABE54642BE7ADC5
where suggestdate > '2014' AND suggestdate <'2015' AND PROCESS_INSTANCE_STATE ='7'  order by suggestdate

-- YEF7F7187DC3F4AD48B2FC7308DEB9B28   준공(기성)조서
select SUBJECT, DOC_NUMBER, CREATOR_DEPT, CREATOR, SUGGESTDATE 
from form_YEF7F7187DC3F4AD48B2FC7308DEB9B28
where suggestdate > '2014' AND suggestdate <'2015' AND PROCESS_INSTANCE_STATE ='7'  order by suggestdate

-- YCA1568A371EB4B81B78F2A0708B2461D  콘도이용신청서(연동)
select SUBJECT, DOC_NUMBER, CREATOR_DEPT, CREATOR, SUGGESTDATE 
from form_YCA1568A371EB4B81B78F2A0708B2461D
where suggestdate > '2014' AND suggestdate <'2015' AND PROCESS_INSTANCE_STATE ='7'  order by suggestdate


-- YB979AF89EE92423B8F6A66C122F2E39E   --법인인감사용신청서
select SUBJECT, DOC_NUMBER, CREATOR_DEPT, CREATOR, SUGGESTDATE 
from form_YB979AF89EE92423B8F6A66C122F2E39E
where suggestdate > '2014' AND suggestdate <'2015' AND PROCESS_INSTANCE_STATE ='7'  order by suggestdate

-- Y99738B95642141AABB7CCD387668E6FF   DB오브젝트변경서
select SUBJECT, DOC_NUMBER, CREATOR_DEPT, CREATOR, SUGGESTDATE 
from form_Y99738B95642141AABB7CCD387668E6FF
where suggestdate > '2014' AND suggestdate <'2015' AND PROCESS_INSTANCE_STATE ='7'  order by suggestdate


-- Y80F6EE6C87564C248CD342E46C890AE9    --법인차량휴일운행신청
select SUBJECT, DOC_NUMBER, CREATOR_DEPT, CREATOR, SUGGESTDATE 
from form_Y80F6EE6C87564C248CD342E46C890AE9
where suggestdate > '2014' AND suggestdate <'2015' AND PROCESS_INSTANCE_STATE ='7'  order by suggestdate



