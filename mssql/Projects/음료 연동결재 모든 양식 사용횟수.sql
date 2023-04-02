select top 10 * from dbo.WF_FORMS

select * from form_YC4EBC95FF8E44A87AD77392D2914166C   --예산부서월실적
select count(doc_name) from form_YC4EBC95FF8E44A87AD77392D2914166C where suggestdate > '20140401' AND suggestdate <'20150501'  group by doc_name --2029

select * from form_Y747BB57D3D334E53A0CA83F8BE4E379C order by suggestdate
select count(doc_name) from form_Y747BB57D3D334E53A0CA83F8BE4E379C where suggestdate > '20140401' AND suggestdate <'20150501'  group by doc_name --2029
select * from form_Y747BB57D3D334E53A0CA83F8BE4E379C where suggestdate > '2010' AND suggestdate <'2011'  order by suggestdate 
select * from form_Y747BB57D3D334E53A0CA83F8BE4E379C where suggestdate > '2011' AND suggestdate <'2012'  order by suggestdate 
select * from form_Y747BB57D3D334E53A0CA83F8BE4E379C where suggestdate > '2012' AND suggestdate <'2013'  order by suggestdate 
select * from form_Y747BB57D3D334E53A0CA83F8BE4E379C where suggestdate > '2013' AND suggestdate <'2014'  order by suggestdate 
select * from form_Y747BB57D3D334E53A0CA83F8BE4E379C where suggestdate > '2014' AND suggestdate <'2015'  order by suggestdate 
select * from form_Y747BB57D3D334E53A0CA83F8BE4E379C where suggestdate > '2015' AND suggestdate <'2016'  order by suggestdate 


select * from form_YAE7EEC57433B4884AAC95B65128C3F0A order by suggestdate


select top 100 * from form_YB9222DABFA484AC6AC97F2A23C649789 order by suggestdate
select count(suggestdate) from form_YB9222DABFA484AC6AC97F2A23C649789 group by doc_name  --29343
select * from form_YB9222DABFA484AC6AC97F2A23C649789 where suggestdate > '2011' AND suggestdate <'2012'  order by suggestdate --3270
select count(doc_name) from form_YB9222DABFA484AC6AC97F2A23C649789 where suggestdate >= '20140401' AND suggestdate <'20150431'  group by doc_name --2029
select count(suggestdate) from form_YB9222DABFA484AC6AC97F2A23C649789 where suggestdate > '2010' AND suggestdate <'2011'  group by doc_name --3270
select count(suggestdate) from form_YB9222DABFA484AC6AC97F2A23C649789 where suggestdate > '2011' AND suggestdate <'2012'  group by doc_name --3270
select count(doc_name) from form_YB9222DABFA484AC6AC97F2A23C649789 where suggestdate > '2012' AND suggestdate <'2013' group by doc_name  --7741
select count(doc_name) from form_YB9222DABFA484AC6AC97F2A23C649789 where suggestdate > '2013' AND suggestdate <'2014'  group by doc_name --6244
select count(doc_name) from form_YB9222DABFA484AC6AC97F2A23C649789 where suggestdate > '2014' AND suggestdate <'2015'  group by doc_name --6930
select count(doc_name) from form_YB9222DABFA484AC6AC97F2A23C649789 where suggestdate > '2015' AND suggestdate <'2016'  group by doc_name --5158



Y1A35F931BEE0476E8119290B4240C7D2
select top 1 * from form_Y1A35F931BEE0476E8119290B4240C7D2 order by suggestdate   --어음수표잔고명세서
select count(doc_name) from form_Y1A35F931BEE0476E8119290B4240C7D2 group by doc_name   --1363
select count(doc_name) from form_Y1A35F931BEE0476E8119290B4240C7D2 where suggestdate > '20140401' AND suggestdate <'20150501'  group by doc_name --2029
select count(doc_name) from form_Y1A35F931BEE0476E8119290B4240C7D2 where suggestdate > '2010' AND suggestdate <'2011'  group by doc_name --255
select count(doc_name) from form_Y1A35F931BEE0476E8119290B4240C7D2 where suggestdate > '2011' AND suggestdate <'2012'  group by doc_name --264
select count(doc_name) from form_Y1A35F931BEE0476E8119290B4240C7D2 where suggestdate > '2012' AND suggestdate <'2013'  group by doc_name --259
select count(doc_name) from form_Y1A35F931BEE0476E8119290B4240C7D2 where suggestdate > '2013' AND suggestdate <'2014'  group by doc_name --249
select count(doc_name) from form_Y1A35F931BEE0476E8119290B4240C7D2 where suggestdate > '2014' AND suggestdate <'2015'  group by doc_name --243
select count(doc_name) from form_Y1A35F931BEE0476E8119290B4240C7D2 where suggestdate > '2015' AND suggestdate <'2016'  group by doc_name --93


Y8D4A994E63054A5EB14621BDD3A4483E   --구매의뢰서
select top 1 * from form_Y8D4A994E63054A5EB14621BDD3A4483E order by suggestdate --   2008-05-27 
select count(doc_name) from form_Y8D4A994E63054A5EB14621BDD3A4483E group by doc_name   --35012
select top 100 * from form_Y8D4A994E63054A5EB14621BDD3A4483E where suggestdate > '20140331' AND suggestdate <'20150501'  group by doc_name --2029
select count(doc_name) from form_Y8D4A994E63054A5EB14621BDD3A4483E where suggestdate > '2010' AND suggestdate <'2011'  group by doc_name --8092
select count(doc_name) from form_Y8D4A994E63054A5EB14621BDD3A4483E where suggestdate > '2011' AND suggestdate <'2012'  group by doc_name --7663
select count(doc_name) from form_Y8D4A994E63054A5EB14621BDD3A4483E where suggestdate > '2012' AND suggestdate <'2013'  group by doc_name --6354
select count(doc_name) from form_Y8D4A994E63054A5EB14621BDD3A4483E where suggestdate > '2013' AND suggestdate <'2014'  group by doc_name --5473
select count(doc_name) from form_Y8D4A994E63054A5EB14621BDD3A4483E where suggestdate > '2014' AND suggestdate <'2015'  group by doc_name --5401
select count(doc_name) from form_Y8D4A994E63054A5EB14621BDD3A4483E where suggestdate > '2015' AND suggestdate <'2016'  group by doc_name --2029


Y7E5B0FAAB0674180B1172BA02147A81E
Y7E5B0FAAB0674180B1172BA02147A81E
select top 1 * from form_Y7E5B0FAAB0674180B1172BA02147A81E order by suggestdate    0


Y54CFE93E9F684353B8861A1B4644EAEE

select top 1 * from form_Y54CFE93E9F684353B8861A1B4644EAEE order by suggestdate      --5-27
select count(doc_name) from form_Y54CFE93E9F684353B8861A1B4644EAEE  group by doc_name   --1142
select count(doc_name) from form_Y54CFE93E9F684353B8861A1B4644EAEE where suggestdate > '20140401' AND suggestdate <'20150501'  group by doc_name --2029
select count(doc_name) from form_Y54CFE93E9F684353B8861A1B4644EAEE where suggestdate > '2010' AND suggestdate <'2011'  group by doc_name --526
select count(doc_name) from form_Y54CFE93E9F684353B8861A1B4644EAEE where suggestdate > '2011' AND suggestdate <'2012'  group by doc_name --252
select count(doc_name) from form_Y54CFE93E9F684353B8861A1B4644EAEE where suggestdate > '2012' AND suggestdate <'2013'  group by doc_name --158
select count(doc_name) from form_Y54CFE93E9F684353B8861A1B4644EAEE where suggestdate > '2013' AND suggestdate <'2014'  group by doc_name --5
select count(doc_name) from form_Y54CFE93E9F684353B8861A1B4644EAEE where suggestdate > '2014' AND suggestdate <'2015'  group by doc_name --5401
select count(doc_name) from form_Y54CFE93E9F684353B8861A1B4644EAEE where suggestdate > '2015' AND suggestdate <'2016'  group by doc_name --2029


YA97EEB2C70C141EDA9A553E0135C7A0C   -- 항목변경신청서
select top 1 * from form_YA97EEB2C70C141EDA9A553E0135C7A0C order by suggestdate      --5-27
select count(doc_name) from form_YA97EEB2C70C141EDA9A553E0135C7A0C  group by doc_name   --5966
select count(doc_name) from form_YA97EEB2C70C141EDA9A553E0135C7A0C where suggestdate > '20140401' AND suggestdate <'20150501'  group by doc_name --2029
select count(doc_name) from form_YA97EEB2C70C141EDA9A553E0135C7A0C where suggestdate > '2010' AND suggestdate <'2011'  group by doc_name --526
select count(doc_name) from form_YA97EEB2C70C141EDA9A553E0135C7A0C where suggestdate > '2011' AND suggestdate <'2012'  group by doc_name --252
select count(doc_name) from form_YA97EEB2C70C141EDA9A553E0135C7A0C where suggestdate > '2012' AND suggestdate <'2013'  group by doc_name --158
select count(doc_name) from form_YA97EEB2C70C141EDA9A553E0135C7A0C where suggestdate > '2013' AND suggestdate <'2014'  group by doc_name --5
select count(doc_name) from form_YA97EEB2C70C141EDA9A553E0135C7A0C where suggestdate > '2014' AND suggestdate <'2015'  group by doc_name --5401
select count(doc_name) from form_YA97EEB2C70C141EDA9A553E0135C7A0C where suggestdate > '2015' AND suggestdate <'2016'  group by doc_name --2029


Y3AAADA3BB0CE45D58106CDB1CA308EE1   --구매결의서
select top 1 * from form_Y3AAADA3BB0CE45D58106CDB1CA308EE1 order by suggestdate      --5-27
select count(doc_name) from form_Y3AAADA3BB0CE45D58106CDB1CA308EE1  group by doc_name   --38901
select count(doc_name) from form_Y3AAADA3BB0CE45D58106CDB1CA308EE1 where suggestdate > '20140401' AND suggestdate <'20150431'  group by doc_name --2029
select count(doc_name) from form_Y3AAADA3BB0CE45D58106CDB1CA308EE1 where suggestdate > '2010' AND suggestdate <'2011'  group by doc_name --526
select count(doc_name) from form_Y3AAADA3BB0CE45D58106CDB1CA308EE1 where suggestdate > '2011' AND suggestdate <'2012'  group by doc_name --252
select count(doc_name) from form_Y3AAADA3BB0CE45D58106CDB1CA308EE1 where suggestdate > '2012' AND suggestdate <'2013'  group by doc_name --158
select count(doc_name) from form_Y3AAADA3BB0CE45D58106CDB1CA308EE1 where suggestdate > '2013' AND suggestdate <'2014'  group by doc_name --5
select count(doc_name) from form_Y3AAADA3BB0CE45D58106CDB1CA308EE1 where suggestdate > '2014' AND suggestdate <'2015'  group by doc_name --5401
select count(doc_name) from form_Y3AAADA3BB0CE45D58106CDB1CA308EE1 where suggestdate > '2015' AND suggestdate <'2016'  group by doc_name --2029


YB8260780E3D44144AD24B38163F5AF88   --출고의뢰서
select top 1 * from form_YB8260780E3D44144AD24B38163F5AF88 order by suggestdate      --5-27
select count(doc_name) from form_YB8260780E3D44144AD24B38163F5AF88  group by doc_name   --38901
select count(doc_name) from form_YB8260780E3D44144AD24B38163F5AF88 where suggestdate > '20140401' AND suggestdate <'20150501'  group by doc_name --2029
select count(doc_name) from form_YB8260780E3D44144AD24B38163F5AF88 where suggestdate > '2010' AND suggestdate <'2011'  group by doc_name --526
select count(doc_name) from form_YB8260780E3D44144AD24B38163F5AF88 where suggestdate > '2011' AND suggestdate <'2012'  group by doc_name --252
select count(doc_name) from form_YB8260780E3D44144AD24B38163F5AF88 where suggestdate > '2012' AND suggestdate <'2013'  group by doc_name --158
select count(doc_name) from form_YB8260780E3D44144AD24B38163F5AF88 where suggestdate > '2013' AND suggestdate <'2014'  group by doc_name --5
select count(doc_name) from form_YB8260780E3D44144AD24B38163F5AF88 where suggestdate > '2014' AND suggestdate <'2015'  group by doc_name --5401
select count(doc_name) from form_YB8260780E3D44144AD24B38163F5AF88 where suggestdate > '2015' AND suggestdate <'2016'  group by doc_name --2029


Y2641100C6E3F4A0FB8B23776E6E79F1B
select top 1 * from form_Y2641100C6E3F4A0FB8B23776E6E79F1B order by suggestdate      --5-27


Y6974AA653C114E53AC44157AA05F19EF    --반납의뢰서
select top 1 * from form_Y6974AA653C114E53AC44157AA05F19EF order by suggestdate      --5-27
select count(doc_name) from form_Y6974AA653C114E53AC44157AA05F19EF  group by doc_name   --38901
select count(doc_name) from form_Y6974AA653C114E53AC44157AA05F19EF where suggestdate > '20140401' AND suggestdate <'20150501'  group by doc_name --2029
select count(doc_name) from form_Y6974AA653C114E53AC44157AA05F19EF where suggestdate > '2010' AND suggestdate <'2011'  group by doc_name --526
select count(doc_name) from form_Y6974AA653C114E53AC44157AA05F19EF where suggestdate > '2011' AND suggestdate <'2012'  group by doc_name --252
select count(doc_name) from form_Y6974AA653C114E53AC44157AA05F19EF where suggestdate > '2012' AND suggestdate <'2013'  group by doc_name --158
select count(doc_name) from form_Y6974AA653C114E53AC44157AA05F19EF where suggestdate > '2013' AND suggestdate <'2014'  group by doc_name --5
select count(doc_name) from form_Y6974AA653C114E53AC44157AA05F19EF where suggestdate > '2014' AND suggestdate <'2015'  group by doc_name --5401
select count(doc_name) from form_Y6974AA653C114E53AC44157AA05F19EF where suggestdate > '2015' AND suggestdate <'2016'  group by doc_name --2029


Y761BB6954DC2408FA7927804B7E5BA4D
select top 1 * from form_Y761BB6954DC2408FA7927804B7E5BA4D order by suggestdate      --5-27
select count(doc_name) from form_Y761BB6954DC2408FA7927804B7E5BA4D  group by doc_name   --38901
select count(doc_name) from form_Y761BB6954DC2408FA7927804B7E5BA4D where suggestdate > '20140518' AND suggestdate <'20150519'  group by doc_name --2029
select count(doc_name) from form_Y761BB6954DC2408FA7927804B7E5BA4D where suggestdate > '2010' AND suggestdate <'2011'  group by doc_name --526
select count(doc_name) from form_Y761BB6954DC2408FA7927804B7E5BA4D where suggestdate > '2011' AND suggestdate <'2012'  group by doc_name --252
select count(doc_name) from form_Y761BB6954DC2408FA7927804B7E5BA4D where suggestdate > '2012' AND suggestdate <'2013'  group by doc_name --158
select count(doc_name) from form_Y761BB6954DC2408FA7927804B7E5BA4D where suggestdate > '2013' AND suggestdate <'2014'  group by doc_name --5
select count(doc_name) from form_Y761BB6954DC2408FA7927804B7E5BA4D where suggestdate > '2014' AND suggestdate <'2015'  group by doc_name --5401
select count(doc_name) from form_Y761BB6954DC2408FA7927804B7E5BA4D where suggestdate > '2015' AND suggestdate <'2016'  group by doc_name --2029

Y42EF509649FD4AAA80646C681FDBF7B5    --판매장비철수요청서
select top 1 * from form_Y42EF509649FD4AAA80646C681FDBF7B5 order by suggestdate      --5-27
select count(doc_name) from form_Y42EF509649FD4AAA80646C681FDBF7B5  group by doc_name   --43094
select count(doc_name) from form_Y42EF509649FD4AAA80646C681FDBF7B5 where suggestdate > '20140401' AND suggestdate <'20150501'  group by doc_name --2029
select count(doc_name) from form_Y42EF509649FD4AAA80646C681FDBF7B5 where suggestdate > '2010' AND suggestdate <'2011'  group by doc_name --526
select count(doc_name) from form_Y42EF509649FD4AAA80646C681FDBF7B5 where suggestdate > '2011' AND suggestdate <'2012'  group by doc_name --252
select count(doc_name) from form_Y42EF509649FD4AAA80646C681FDBF7B5 where suggestdate > '2012' AND suggestdate <'2013'  group by doc_name --158
select count(doc_name) from form_Y42EF509649FD4AAA80646C681FDBF7B5 where suggestdate > '2013' AND suggestdate <'2014'  group by doc_name --5
select count(doc_name) from form_Y42EF509649FD4AAA80646C681FDBF7B5 where suggestdate > '2014' AND suggestdate <'2015'  group by doc_name --5401
select count(doc_name) from form_Y42EF509649FD4AAA80646C681FDBF7B5 where suggestdate > '2015' AND suggestdate <'2016'  group by doc_name --2029


Y5149C2A149D24EADA29D306082EBA5F3    판매장비설치요청서
select top 1 * from form_Y5149C2A149D24EADA29D306082EBA5F3 order by suggestdate      --5-27
select count(doc_name) from form_Y5149C2A149D24EADA29D306082EBA5F3  group by doc_name   --43094
select count(doc_name) from form_Y5149C2A149D24EADA29D306082EBA5F3 where suggestdate > '20140401' AND suggestdate <'20150501'  group by doc_name --2029
select count(doc_name) from form_Y5149C2A149D24EADA29D306082EBA5F3 where suggestdate > '2010' AND suggestdate <'2011'  group by doc_name --526
select count(doc_name) from form_Y5149C2A149D24EADA29D306082EBA5F3 where suggestdate > '2011' AND suggestdate <'2012'  group by doc_name --252
select count(doc_name) from form_Y5149C2A149D24EADA29D306082EBA5F3 where suggestdate > '2012' AND suggestdate <'2013'  group by doc_name --158
select count(doc_name) from form_Y5149C2A149D24EADA29D306082EBA5F3 where suggestdate > '2013' AND suggestdate <'2014'  group by doc_name --5
select count(doc_name) from form_Y5149C2A149D24EADA29D306082EBA5F3 where suggestdate > '2014' AND suggestdate <'2015'  group by doc_name --5401
select count(doc_name) from form_Y5149C2A149D24EADA29D306082EBA5F3 where suggestdate > '2015' AND suggestdate <'2016'  group by doc_name --2029

YFEA425C4FB9346D0B81C119099FB5F35
select top 1 * from form_YFEA425C4FB9346D0B81C119099FB5F35 order by suggestdate      --5-27
select count(doc_name) from form_YFEA425C4FB9346D0B81C119099FB5F35  group by doc_name   --43094
select count(doc_name) from form_YFEA425C4FB9346D0B81C119099FB5F35 where suggestdate > '20140401' AND suggestdate <'20150501'  group by doc_name --2029
select count(doc_name) from form_YFEA425C4FB9346D0B81C119099FB5F35 where suggestdate > '2010' AND suggestdate <'2011'  group by doc_name --526
select count(doc_name) from form_YFEA425C4FB9346D0B81C119099FB5F35 where suggestdate > '2011' AND suggestdate <'2012'  group by doc_name --252
select count(doc_name) from form_YFEA425C4FB9346D0B81C119099FB5F35 where suggestdate > '2012' AND suggestdate <'2013'  group by doc_name --158
select count(doc_name) from form_YFEA425C4FB9346D0B81C119099FB5F35 where suggestdate > '2013' AND suggestdate <'2014'  group by doc_name --5
select count(doc_name) from form_YFEA425C4FB9346D0B81C119099FB5F35 where suggestdate > '2014' AND suggestdate <'2015'  group by doc_name --5401
select count(doc_name) from form_YFEA425C4FB9346D0B81C119099FB5F35 where suggestdate > '2015' AND suggestdate <'2016'  group by doc_name --2029

YF2F3672C68C148E3841A6C236DE6A504
select top 1 * from form_YF2F3672C68C148E3841A6C236DE6A504 order by suggestdate      --2006-02-22
select count(doc_name) from form_YF2F3672C68C148E3841A6C236DE6A504  group by doc_name   --43094
select count(doc_name) from form_Y5149C2A149D24EADA29D306082EBA5F3 where suggestdate > '20140518' AND suggestdate <'20150519'  group by doc_name --2029

YC231645BE11A4A0A9358F60410C222C4
select top 1 * from form_YC231645BE11A4A0A9358F60410C222C4 order by suggestdate      --2008-05-27
select count(doc_name) from form_YC231645BE11A4A0A9358F60410C222C4  group by doc_name   --43094
select count(doc_name) from form_Y5149C2A149D24EADA29D306082EBA5F3 where suggestdate > '20140518' AND suggestdate <'20150519'  group by doc_name --2029


YB68D2E23A8F74970967B4D08912F0B9C     --환경점검현황
select top 1 * from form_YB68D2E23A8F74970967B4D08912F0B9C order by suggestdate      --2008-05-27
select count(doc_name) from form_YB68D2E23A8F74970967B4D08912F0B9C  group by doc_name   --43094
select count(doc_name) from form_YB68D2E23A8F74970967B4D08912F0B9C where suggestdate > '20140401' AND suggestdate <'20150501'  group by doc_name --2029
select count(doc_name) from form_YB68D2E23A8F74970967B4D08912F0B9C where suggestdate > '2010' AND suggestdate <'2011'  group by doc_name --526
select count(doc_name) from form_YB68D2E23A8F74970967B4D08912F0B9C where suggestdate > '2011' AND suggestdate <'2012'  group by doc_name --252
select count(doc_name) from form_YB68D2E23A8F74970967B4D08912F0B9C where suggestdate > '2012' AND suggestdate <'2013'  group by doc_name --158
select count(doc_name) from form_YB68D2E23A8F74970967B4D08912F0B9C where suggestdate > '2013' AND suggestdate <'2014'  group by doc_name --5
select count(doc_name) from form_YB68D2E23A8F74970967B4D08912F0B9C where suggestdate > '2014' AND suggestdate <'2015'  group by doc_name --5401
select count(doc_name) from form_YB68D2E23A8F74970967B4D08912F0B9C where suggestdate > '2015' AND suggestdate <'2016'  group by doc_name --2029


Y35CED4073A514D94875F61A63FBE3666   --환경 점검 주보
select top 1 * from form_Y35CED4073A514D94875F61A63FBE3666 order by suggestdate      --2008-05-27
select count(doc_name) from form_Y35CED4073A514D94875F61A63FBE3666  group by doc_name   --43094
select count(doc_name) from form_Y35CED4073A514D94875F61A63FBE3666 where suggestdate > '20140401' AND suggestdate <'20150501'  group by doc_name --2029
select count(doc_name) from form_Y35CED4073A514D94875F61A63FBE3666 where suggestdate > '2010' AND suggestdate <'2011'  group by doc_name --526
select count(doc_name) from form_Y35CED4073A514D94875F61A63FBE3666 where suggestdate > '2011' AND suggestdate <'2012'  group by doc_name --252
select count(doc_name) from form_Y35CED4073A514D94875F61A63FBE3666 where suggestdate > '2012' AND suggestdate <'2013'  group by doc_name --158
select count(doc_name) from form_Y35CED4073A514D94875F61A63FBE3666 where suggestdate > '2013' AND suggestdate <'2014'  group by doc_name --5
select count(doc_name) from form_Y35CED4073A514D94875F61A63FBE3666 where suggestdate > '2014' AND suggestdate <'2015'  group by doc_name --5401
select count(doc_name) from form_Y35CED4073A514D94875F61A63FBE3666 where suggestdate > '2015' AND suggestdate <'2016'  group by doc_name --2029

Y462E36DD55F74F098C8A3D141BB0FCCF
select top 1 * from form_Y462E36DD55F74F098C8A3D141BB0FCCF order by suggestdate      --2008-05-27
select count(doc_name) from form_Y462E36DD55F74F098C8A3D141BB0FCCF  group by doc_name   --43094
select count(doc_name) from form_Y462E36DD55F74F098C8A3D141BB0FCCF where suggestdate > '20140518' AND suggestdate <'20150519'  group by doc_name --2029
select count(doc_name) from form_Y462E36DD55F74F098C8A3D141BB0FCCF where suggestdate > '2010' AND suggestdate <'2011'  group by doc_name --526
select count(doc_name) from form_Y462E36DD55F74F098C8A3D141BB0FCCF where suggestdate > '2011' AND suggestdate <'2012'  group by doc_name --252
select count(doc_name) from form_Y462E36DD55F74F098C8A3D141BB0FCCF where suggestdate > '2012' AND suggestdate <'2013'  group by doc_name --158
select count(doc_name) from form_Y462E36DD55F74F098C8A3D141BB0FCCF where suggestdate > '2013' AND suggestdate <'2014'  group by doc_name --5
select count(doc_name) from form_Y462E36DD55F74F098C8A3D141BB0FCCF where suggestdate > '2014' AND suggestdate <'2015'  group by doc_name --5401
select count(doc_name) from form_Y462E36DD55F74F098C8A3D141BB0FCCF where suggestdate > '2015' AND suggestdate <'2016'  group by doc_name --2029

YDF9B8101D3C0454884DEDC383C620B71
select top 1 * from form_YDF9B8101D3C0454884DEDC383C620B71 order by suggestdate      --2008-05-27
select count(doc_name) from form_YDF9B8101D3C0454884DEDC383C620B71  group by doc_name   --299
select count(doc_name) from form_YDF9B8101D3C0454884DEDC383C620B71 where suggestdate > '20140518' AND suggestdate <'20150519'  group by doc_name --2029
select count(doc_name) from form_YDF9B8101D3C0454884DEDC383C620B71 where suggestdate > '2010' AND suggestdate <'2011'  group by doc_name --526
select count(doc_name) from form_YDF9B8101D3C0454884DEDC383C620B71 where suggestdate > '2011' AND suggestdate <'2012'  group by doc_name --252
select count(doc_name) from form_YDF9B8101D3C0454884DEDC383C620B71 where suggestdate > '2012' AND suggestdate <'2013'  group by doc_name --158
select count(doc_name) from form_YDF9B8101D3C0454884DEDC383C620B71 where suggestdate > '2013' AND suggestdate <'2014'  group by doc_name --5
select count(doc_name) from form_YDF9B8101D3C0454884DEDC383C620B71 where suggestdate > '2014' AND suggestdate <'2015'  group by doc_name --5401
select count(doc_name) from form_YDF9B8101D3C0454884DEDC383C620B71 where suggestdate > '2015' AND suggestdate <'2016'  group by doc_name --2029

Y85CE2A875E674904A4FAB9D7E50375BB    --인수인계서
select top 1 * from form_Y85CE2A875E674904A4FAB9D7E50375BB order by suggestdate      --2008-05-27  
select count(doc_name) from form_Y85CE2A875E674904A4FAB9D7E50375BB  group by doc_name   --5602
select count(doc_name) from form_Y85CE2A875E674904A4FAB9D7E50375BB where suggestdate > '20140401' AND suggestdate <'20150501'  group by doc_name --2029
select count(doc_name) from form_Y85CE2A875E674904A4FAB9D7E50375BB where suggestdate > '2010' AND suggestdate <'2011'  group by doc_name --526
select count(doc_name) from form_Y85CE2A875E674904A4FAB9D7E50375BB where suggestdate > '2011' AND suggestdate <'2012'  group by doc_name --252
select count(doc_name) from form_Y85CE2A875E674904A4FAB9D7E50375BB where suggestdate > '2012' AND suggestdate <'2013'  group by doc_name --158
select count(doc_name) from form_Y85CE2A875E674904A4FAB9D7E50375BB where suggestdate > '2013' AND suggestdate <'2014'  group by doc_name --5
select count(doc_name) from form_Y85CE2A875E674904A4FAB9D7E50375BB where suggestdate > '2014' AND suggestdate <'2015'  group by doc_name --5401
select count(doc_name) from form_Y85CE2A875E674904A4FAB9D7E50375BB where suggestdate > '2015' AND suggestdate <'2016'  group by doc_name --2029


Y76D76F2606D748BE8E72C77D8B5D9AD9   -- 년간예산신청서
select top 1 * from form_Y76D76F2606D748BE8E72C77D8B5D9AD9 order by suggestdate      --2008-05-27
select count(doc_name) from form_Y76D76F2606D748BE8E72C77D8B5D9AD9  group by doc_name   --5602
select count(doc_name) from form_Y76D76F2606D748BE8E72C77D8B5D9AD9 where suggestdate > '20140401' AND suggestdate <'20150501'  group by doc_name --2029
select count(doc_name) from form_Y76D76F2606D748BE8E72C77D8B5D9AD9 where suggestdate > '2010' AND suggestdate <'2011'  group by doc_name --526
select count(doc_name) from form_Y76D76F2606D748BE8E72C77D8B5D9AD9 where suggestdate > '2011' AND suggestdate <'2012'  group by doc_name --252
select count(doc_name) from form_Y76D76F2606D748BE8E72C77D8B5D9AD9 where suggestdate > '2012' AND suggestdate <'2013'  group by doc_name --158
select count(doc_name) from form_Y76D76F2606D748BE8E72C77D8B5D9AD9 where suggestdate > '2013' AND suggestdate <'2014'  group by doc_name --5
select count(doc_name) from form_Y76D76F2606D748BE8E72C77D8B5D9AD9 where suggestdate > '2014' AND suggestdate <'2015'  group by doc_name --5401
select count(doc_name) from form_Y76D76F2606D748BE8E72C77D8B5D9AD9 where suggestdate > '2015' AND suggestdate <'2016'  group by doc_name --2029





Declare @n char(50)
set @n='form_Y85CE2A875E674904A4FAB9D7E50375BB'
select top 1 * from @n order by suggestdate      --2008-05-27



Y2AC6C1CC89A545C5A4350669B66271FA    --유가증권입고현황
select top 1 * from form_Y2AC6C1CC89A545C5A4350669B66271FA order by suggestdate      --2008-05-27
select count(doc_name) from form_Y2AC6C1CC89A545C5A4350669B66271FA  group by doc_name   --5602
select count(doc_name) from form_Y2AC6C1CC89A545C5A4350669B66271FA where suggestdate > '20140401' AND suggestdate <'20150501'  group by doc_name --2029
select count(doc_name) from form_Y2AC6C1CC89A545C5A4350669B66271FA where suggestdate > '2010' AND suggestdate <'2011'  group by doc_name --526
select count(doc_name) from form_Y2AC6C1CC89A545C5A4350669B66271FA where suggestdate > '2011' AND suggestdate <'2012'  group by doc_name --252
select count(doc_name) from form_Y2AC6C1CC89A545C5A4350669B66271FA where suggestdate > '2012' AND suggestdate <'2013'  group by doc_name --158
select count(doc_name) from form_Y2AC6C1CC89A545C5A4350669B66271FA where suggestdate > '2013' AND suggestdate <'2014'  group by doc_name --5
select count(doc_name) from form_Y2AC6C1CC89A545C5A4350669B66271FA where suggestdate > '2014' AND suggestdate <'2015'  group by doc_name --5401
select count(doc_name) from form_Y2AC6C1CC89A545C5A4350669B66271FA where suggestdate > '2015' AND suggestdate <'2016'  group by doc_name --2029

Y85DE0C0BF5FE4764954B2C71D6E86100    --불량채권심사결과통보서
select top 1 * from form_Y85DE0C0BF5FE4764954B2C71D6E86100 order by suggestdate      --2008-01-26
select count(doc_name) from form_Y85DE0C0BF5FE4764954B2C71D6E86100  group by doc_name   --5602
select count(doc_name) from form_Y85DE0C0BF5FE4764954B2C71D6E86100 where suggestdate > '20140401' AND suggestdate <'20150501'  group by doc_name 
select count(doc_name) from form_Y85DE0C0BF5FE4764954B2C71D6E86100 where suggestdate > '2010' AND suggestdate <'2011'  group by doc_name --526
select count(doc_name) from form_Y85DE0C0BF5FE4764954B2C71D6E86100 where suggestdate > '2011' AND suggestdate <'2012'  group by doc_name --252
select count(doc_name) from form_Y85DE0C0BF5FE4764954B2C71D6E86100 where suggestdate > '2012' AND suggestdate <'2013'  group by doc_name --158
select count(doc_name) from form_Y85DE0C0BF5FE4764954B2C71D6E86100 where suggestdate > '2013' AND suggestdate <'2014'  group by doc_name --5
select count(doc_name) from form_Y85DE0C0BF5FE4764954B2C71D6E86100 where suggestdate > '2014' AND suggestdate <'2015'  group by doc_name --5401
select count(doc_name) from form_Y85DE0C0BF5FE4764954B2C71D6E86100 where suggestdate > '2015' AND suggestdate <'2016'  group by doc_name --2029


Y7738807F64624140A4EEA15167EBEF82   MOBILE장비사고보고서
select top 1 * from form_Y7738807F64624140A4EEA15167EBEF82 order by suggestdate      --2008-04-07
select count(doc_name) from form_Y7738807F64624140A4EEA15167EBEF82  group by doc_name   --5602
select count(doc_name) from form_Y7738807F64624140A4EEA15167EBEF82 where suggestdate > '20140401' AND suggestdate <'20150501'  group by doc_name --2029
select count(doc_name) from form_Y7738807F64624140A4EEA15167EBEF82 where suggestdate > '2010' AND suggestdate <'2011'  group by doc_name --526
select count(doc_name) from form_Y7738807F64624140A4EEA15167EBEF82 where suggestdate > '2011' AND suggestdate <'2012'  group by doc_name --252
select count(doc_name) from form_Y7738807F64624140A4EEA15167EBEF82 where suggestdate > '2012' AND suggestdate <'2013'  group by doc_name --158
select count(doc_name) from form_Y7738807F64624140A4EEA15167EBEF82 where suggestdate > '2013' AND suggestdate <'2014'  group by doc_name --5
select count(doc_name) from form_Y7738807F64624140A4EEA15167EBEF82 where suggestdate > '2014' AND suggestdate <'2015'  group by doc_name --5401
select count(doc_name) from form_Y7738807F64624140A4EEA15167EBEF82 where suggestdate > '2015' AND suggestdate <'2016'  group by doc_name --2029

Y107F69F84EF742A9A10EE695EDFB56DC   --판매장비이동요청서
select top 1 * from form_Y107F69F84EF742A9A10EE695EDFB56DC order by suggestdate      --2008-05-07
select count(doc_name) from form_Y107F69F84EF742A9A10EE695EDFB56DC  group by doc_name   --5602
select count(doc_name) from form_Y107F69F84EF742A9A10EE695EDFB56DC where suggestdate > '2014' AND suggestdate <'20140518'  group by doc_name --2029
select count(doc_name) from form_Y107F69F84EF742A9A10EE695EDFB56DC where suggestdate > '20140401' AND suggestdate <'20150501'  group by doc_name --2029
select count(doc_name) from form_Y107F69F84EF742A9A10EE695EDFB56DC where suggestdate > '2010' AND suggestdate <'2011'  group by doc_name --526
select count(doc_name) from form_Y107F69F84EF742A9A10EE695EDFB56DC where suggestdate > '2011' AND suggestdate <'2012'  group by doc_name --252
select count(doc_name) from form_Y107F69F84EF742A9A10EE695EDFB56DC where suggestdate > '2012' AND suggestdate <'2013'  group by doc_name --158
select count(doc_name) from form_Y107F69F84EF742A9A10EE695EDFB56DC where suggestdate > '2013' AND suggestdate <'2014'  group by doc_name --5
select count(doc_name) from form_Y107F69F84EF742A9A10EE695EDFB56DC where suggestdate > '2014' AND suggestdate <'2015'  group by doc_name --5401
select count(doc_name) from form_Y107F69F84EF742A9A10EE695EDFB56DC where suggestdate > '2015' AND suggestdate <'2016'  group by doc_name --2029


Y83BC2165F7D640D7ACD9BD062327106E
select top 1 * from form_Y83BC2165F7D640D7ACD9BD062327106E order by suggestdate      --2008-05-07
select count(doc_name) from form_Y83BC2165F7D640D7ACD9BD062327106E  group by doc_name   --5602


Y816CA0D39251426586019F803013CB59
select top 1 * from form_Y816CA0D39251426586019F803013CB59 order by suggestdate      --2008-12-09
select count(doc_name) from form_Y816CA0D39251426586019F803013CB59  group by doc_name   --5602

Y9A282068897043E08905CD42881773D5    --차량정비발생현황
select top 1 * from form_Y9A282068897043E08905CD42881773D5 order by suggestdate      --2009-10-19
select count(doc_name) from form_Y9A282068897043E08905CD42881773D5  group by doc_name   --5602
select count(doc_name) from form_Y9A282068897043E08905CD42881773D5 where suggestdate > '20140401' AND suggestdate <'20150501'  group by doc_name --2029
select count(doc_name) from form_Y9A282068897043E08905CD42881773D5 where suggestdate > '2010' AND suggestdate <'2011'  group by doc_name --526
select count(doc_name) from form_Y9A282068897043E08905CD42881773D5 where suggestdate > '2011' AND suggestdate <'2012'  group by doc_name --252
select count(doc_name) from form_Y9A282068897043E08905CD42881773D5 where suggestdate > '2012' AND suggestdate <'2013'  group by doc_name --158
select count(doc_name) from form_Y9A282068897043E08905CD42881773D5 where suggestdate > '2013' AND suggestdate <'2014'  group by doc_name --5
select count(doc_name) from form_Y9A282068897043E08905CD42881773D5 where suggestdate > '2014' AND suggestdate <'2015'  group by doc_name --5401
select count(doc_name) from form_Y9A282068897043E08905CD42881773D5 where suggestdate > '2015' AND suggestdate <'2016'  group by doc_name --2029


YF57EBFF214194D0DB20F7B53FC26DEBE   -- 임대용 냉온수기 신청서
select top 1 * from form_YF57EBFF214194D0DB20F7B53FC26DEBE order by suggestdate      --2010-05-13
select count(doc_name) from form_YF57EBFF214194D0DB20F7B53FC26DEBE  group by doc_name   --5602
select count(doc_name) from form_YF57EBFF214194D0DB20F7B53FC26DEBE where suggestdate > '20140401' AND suggestdate <'20150501'  group by doc_name --2029
select count(doc_name) from form_YF57EBFF214194D0DB20F7B53FC26DEBE where suggestdate > '2010' AND suggestdate <'2011'  group by doc_name --526
select count(doc_name) from form_YF57EBFF214194D0DB20F7B53FC26DEBE where suggestdate > '2011' AND suggestdate <'2012'  group by doc_name --252
select count(doc_name) from form_YF57EBFF214194D0DB20F7B53FC26DEBE where suggestdate > '2012' AND suggestdate <'2013'  group by doc_name --158
select count(doc_name) from form_YF57EBFF214194D0DB20F7B53FC26DEBE where suggestdate > '2013' AND suggestdate <'2014'  group by doc_name --5
select count(doc_name) from form_YF57EBFF214194D0DB20F7B53FC26DEBE where suggestdate > '2014' AND suggestdate <'2015'  group by doc_name --5401
select count(doc_name) from form_YF57EBFF214194D0DB20F7B53FC26DEBE where suggestdate > '2015' AND suggestdate <'2016'  group by doc_name --2029


Y07D3A5CE2A10422982430EBECA4E93D9
select top 1 * from form_Y07D3A5CE2A10422982430EBECA4E93D9 order by suggestdate      --2010-06-30
select count(doc_name) from form_Y07D3A5CE2A10422982430EBECA4E93D9  group by doc_name   --5602
select count(doc_name) from form_Y07D3A5CE2A10422982430EBECA4E93D9 where suggestdate > '20140401' AND suggestdate <'20150501'  group by doc_name --2029
select count(doc_name) from form_Y07D3A5CE2A10422982430EBECA4E93D9 where suggestdate > '2010' AND suggestdate <'2011'  group by doc_name --526
select count(doc_name) from form_Y07D3A5CE2A10422982430EBECA4E93D9 where suggestdate > '2011' AND suggestdate <'2012'  group by doc_name --252
select count(doc_name) from form_Y07D3A5CE2A10422982430EBECA4E93D9 where suggestdate > '2012' AND suggestdate <'2013'  group by doc_name --158
select count(doc_name) from form_Y07D3A5CE2A10422982430EBECA4E93D9 where suggestdate > '2013' AND suggestdate <'2014'  group by doc_name --5
select count(doc_name) from form_Y07D3A5CE2A10422982430EBECA4E93D9 where suggestdate > '2014' AND suggestdate <'2015'  group by doc_name --5401
select count(doc_name) from form_Y07D3A5CE2A10422982430EBECA4E93D9 where suggestdate > '2015' AND suggestdate <'2016'  group by doc_name --2029


YC05DF302C43742958445939F7E97CFF7   --구매결의서(아사히)
select top 1 * from form_YC05DF302C43742958445939F7E97CFF7 order by suggestdate      --2010-06-30
select count(doc_name) from form_YC05DF302C43742958445939F7E97CFF7  group by doc_name   --5602
select count(doc_name) from form_YC05DF302C43742958445939F7E97CFF7 where suggestdate > '20140401' AND suggestdate <'20150501'  group by doc_name --2029
select count(doc_name) from form_YC05DF302C43742958445939F7E97CFF7 where suggestdate > '2010' AND suggestdate <'2011'  group by doc_name --526
select count(doc_name) from form_YC05DF302C43742958445939F7E97CFF7 where suggestdate > '2011' AND suggestdate <'2012'  group by doc_name --252
select count(doc_name) from form_YC05DF302C43742958445939F7E97CFF7 where suggestdate > '2012' AND suggestdate <'2013'  group by doc_name --158
select count(doc_name) from form_YC05DF302C43742958445939F7E97CFF7 where suggestdate > '2013' AND suggestdate <'2014'  group by doc_name --5
select count(doc_name) from form_YC05DF302C43742958445939F7E97CFF7 where suggestdate > '2014' AND suggestdate <'2015'  group by doc_name --5401
select count(doc_name) from form_YC05DF302C43742958445939F7E97CFF7 where suggestdate > '2015' AND suggestdate <'2016'  group by doc_name --2029


Y4741F41EBEE9457C9C76107DB444FFB8
select top 1 * from form_Y4741F41EBEE9457C9C76107DB444FFB8 order by suggestdate      --2011-01-01 
select count(doc_name) from form_Y4741F41EBEE9457C9C76107DB444FFB8  group by doc_name   --5602

Y2B172D247B4B4E03A74ABC4B674FEA11   --차량사고보고서
select top 1 * from form_Y2B172D247B4B4E03A74ABC4B674FEA11 order by suggestdate      --2010-04-20
select count(doc_name) from form_Y2B172D247B4B4E03A74ABC4B674FEA11  group by doc_name   --5602
select count(doc_name) from form_Y2B172D247B4B4E03A74ABC4B674FEA11 where suggestdate > '20140401' AND suggestdate <'20150501'  group by doc_name --2029
select count(doc_name) from form_Y2B172D247B4B4E03A74ABC4B674FEA11 where suggestdate > '2010' AND suggestdate <'2011'  group by doc_name --526
select count(doc_name) from form_Y2B172D247B4B4E03A74ABC4B674FEA11 where suggestdate > '2011' AND suggestdate <'2012'  group by doc_name --252
select count(doc_name) from form_Y2B172D247B4B4E03A74ABC4B674FEA11 where suggestdate > '2012' AND suggestdate <'2013'  group by doc_name --158
select count(doc_name) from form_Y2B172D247B4B4E03A74ABC4B674FEA11 where suggestdate > '2013' AND suggestdate <'2014'  group by doc_name --5
select count(doc_name) from form_Y2B172D247B4B4E03A74ABC4B674FEA11 where suggestdate > '2014' AND suggestdate <'2015'  group by doc_name --5401
select count(doc_name) from form_Y2B172D247B4B4E03A74ABC4B674FEA11 where suggestdate > '2015' AND suggestdate <'2016'  group by doc_name --2029


YAA6EC409DF3F41309D27D86DB9D606E7    --2012-03-16    --행사보고서
select top 1 * from form_YAA6EC409DF3F41309D27D86DB9D606E7 order by suggestdate      --2012-03-16
select count(doc_name) from form_YAA6EC409DF3F41309D27D86DB9D606E7  group by doc_name   --5602
select count(doc_name) from form_YAA6EC409DF3F41309D27D86DB9D606E7 where suggestdate > '20140518' AND suggestdate <'20150519'  group by doc_name --2029
select count(doc_name) from form_YAA6EC409DF3F41309D27D86DB9D606E7 where suggestdate > '2010' AND suggestdate <'2011'  group by doc_name --526
select count(doc_name) from form_YAA6EC409DF3F41309D27D86DB9D606E7 where suggestdate > '2011' AND suggestdate <'2012'  group by doc_name --252
select count(doc_name) from form_YAA6EC409DF3F41309D27D86DB9D606E7 where suggestdate > '2012' AND suggestdate <'2013'  group by doc_name --158
select count(doc_name) from form_YAA6EC409DF3F41309D27D86DB9D606E7 where suggestdate > '2013' AND suggestdate <'2014'  group by doc_name --5
select count(doc_name) from form_YAA6EC409DF3F41309D27D86DB9D606E7 where suggestdate > '2014' AND suggestdate <'2015'  group by doc_name --5401
select count(doc_name) from form_YAA6EC409DF3F41309D27D86DB9D606E7 where suggestdate > '2015' AND suggestdate <'2016'  group by doc_name --2029


Y0028F2733E8B449A8186BC8922E5DBFE    --제상품의뢰서
select top 1 * from form_Y0028F2733E8B449A8186BC8922E5DBFE order by suggestdate      --2012-07-10
select count(doc_name) from form_Y0028F2733E8B449A8186BC8922E5DBFE  group by doc_name   --5602
select count(doc_name) from form_Y0028F2733E8B449A8186BC8922E5DBFE where suggestdate > '20140401' AND suggestdate <'20150501'  group by doc_name --2029
select count(doc_name) from form_Y0028F2733E8B449A8186BC8922E5DBFE where suggestdate > '2010' AND suggestdate <'2011'  group by doc_name --526
select count(doc_name) from form_Y0028F2733E8B449A8186BC8922E5DBFE where suggestdate > '2011' AND suggestdate <'2012'  group by doc_name --252
select count(doc_name) from form_Y0028F2733E8B449A8186BC8922E5DBFE where suggestdate > '2012' AND suggestdate <'2013'  group by doc_name --158
select count(doc_name) from form_Y0028F2733E8B449A8186BC8922E5DBFE where suggestdate > '2013' AND suggestdate <'2014'  group by doc_name --5
select count(doc_name) from form_Y0028F2733E8B449A8186BC8922E5DBFE where suggestdate > '2014' AND suggestdate <'2015'  group by doc_name --5401
select count(doc_name) from form_Y0028F2733E8B449A8186BC8922E5DBFE where suggestdate > '2015' AND suggestdate <'2016'  group by doc_name --2029


Y58438F138FA641D9A31B8107F180129B   --변동투자예산신청서
select top 1 * from form_Y58438F138FA641D9A31B8107F180129B order by suggestdate      --2013-04-22
select count(doc_name) from form_Y58438F138FA641D9A31B8107F180129B  group by doc_name   --5602
select count(doc_name) from form_Y58438F138FA641D9A31B8107F180129B where suggestdate > '20140401' AND suggestdate <'20150501'  group by doc_name --2029
select count(doc_name) from form_Y58438F138FA641D9A31B8107F180129B where suggestdate > '2010' AND suggestdate <'2011'  group by doc_name --526
select count(doc_name) from form_Y58438F138FA641D9A31B8107F180129B where suggestdate > '2011' AND suggestdate <'2012'  group by doc_name --252
select count(doc_name) from form_Y58438F138FA641D9A31B8107F180129B where suggestdate > '2012' AND suggestdate <'2013'  group by doc_name --158
select count(doc_name) from form_Y58438F138FA641D9A31B8107F180129B where suggestdate > '2013' AND suggestdate <'2014'  group by doc_name --5
select count(doc_name) from form_Y58438F138FA641D9A31B8107F180129B where suggestdate > '2014' AND suggestdate <'2015'  group by doc_name --5401
select count(doc_name) from form_Y58438F138FA641D9A31B8107F180129B where suggestdate > '2015' AND suggestdate <'2016'  group by doc_name --2029


Y7D123377DEBE43ED9EEADC93098C768E   --퇴직금계산서
select top 1 * from form_Y7D123377DEBE43ED9EEADC93098C768E order by suggestdate      --2013-11-07
select count(doc_name) from form_Y7D123377DEBE43ED9EEADC93098C768E  group by doc_name   --5602
select count(doc_name) from form_Y7D123377DEBE43ED9EEADC93098C768E where suggestdate > '20140401' AND suggestdate <'20150501'  group by doc_name --2029
select count(doc_name) from form_Y7D123377DEBE43ED9EEADC93098C768E where suggestdate > '2010' AND suggestdate <'2011'  group by doc_name --526
select count(doc_name) from form_Y7D123377DEBE43ED9EEADC93098C768E where suggestdate > '2011' AND suggestdate <'2012'  group by doc_name --252
select count(doc_name) from form_Y7D123377DEBE43ED9EEADC93098C768E where suggestdate > '2012' AND suggestdate <'2013'  group by doc_name --158
select count(doc_name) from form_Y7D123377DEBE43ED9EEADC93098C768E where suggestdate > '2013' AND suggestdate <'2014'  group by doc_name --5
select count(doc_name) from form_Y7D123377DEBE43ED9EEADC93098C768E where suggestdate > '2014' AND suggestdate <'2015'  group by doc_name --5401
select count(doc_name) from form_Y7D123377DEBE43ED9EEADC93098C768E where suggestdate > '2015' AND suggestdate <'2016'  group by doc_name --2029


Y7B497D24B8DB4D3E99741B7D4DD76227    --수출제품출고의뢰서
select top 1 * from form_Y7B497D24B8DB4D3E99741B7D4DD76227 order by suggestdate      --2014-04-18
select count(doc_name) from form_Y7B497D24B8DB4D3E99741B7D4DD76227  group by doc_name   --5602
select count(doc_name) from form_Y7B497D24B8DB4D3E99741B7D4DD76227 where suggestdate > '20140401' AND suggestdate <'20150501'  group by doc_name --2029
select count(doc_name) from form_Y7B497D24B8DB4D3E99741B7D4DD76227 where suggestdate > '2010' AND suggestdate <'2011'  group by doc_name --526
select count(doc_name) from form_Y7B497D24B8DB4D3E99741B7D4DD76227 where suggestdate > '2011' AND suggestdate <'2012'  group by doc_name --252
select count(doc_name) from form_Y7B497D24B8DB4D3E99741B7D4DD76227 where suggestdate > '2012' AND suggestdate <'2013'  group by doc_name --158
select count(doc_name) from form_Y7B497D24B8DB4D3E99741B7D4DD76227 where suggestdate > '2013' AND suggestdate <'2014'  group by doc_name --5
select count(doc_name) from form_Y7B497D24B8DB4D3E99741B7D4DD76227 where suggestdate > '2014' AND suggestdate <'2015'  group by doc_name --5401
select count(doc_name) from form_Y7B497D24B8DB4D3E99741B7D4DD76227 where suggestdate > '2015' AND suggestdate <'2016'  group by doc_name --2029


Y4A71D90C86984A5E89158C23FFA0D19B    --수출제품출고의뢰서2
select top 1 * from form_Y4A71D90C86984A5E89158C23FFA0D19B order by suggestdate      --2014-06-17
select count(doc_name) from form_Y4A71D90C86984A5E89158C23FFA0D19B  group by doc_name   --5602
select count(doc_name) from form_Y4A71D90C86984A5E89158C23FFA0D19B where suggestdate > '20140401' AND suggestdate <'20150501'  group by doc_name --2029
select count(doc_name) from form_Y4A71D90C86984A5E89158C23FFA0D19B where suggestdate > '2010' AND suggestdate <'2011'  group by doc_name --526
select count(doc_name) from form_Y4A71D90C86984A5E89158C23FFA0D19B where suggestdate > '2011' AND suggestdate <'2012'  group by doc_name --252
select count(doc_name) from form_Y4A71D90C86984A5E89158C23FFA0D19B where suggestdate > '2012' AND suggestdate <'2013'  group by doc_name --158
select count(doc_name) from form_Y4A71D90C86984A5E89158C23FFA0D19B where suggestdate > '2013' AND suggestdate <'2014'  group by doc_name --5
select count(doc_name) from form_Y4A71D90C86984A5E89158C23FFA0D19B where suggestdate > '2014' AND suggestdate <'2015'  group by doc_name --5401
select count(doc_name) from form_Y4A71D90C86984A5E89158C23FFA0D19B where suggestdate > '2015' AND suggestdate <'2016'  group by doc_name --2029


Y00BE91A5F6794FEC83D8BFEEB4E897CD    --정보시스템변경서
select top 1 * from form_Y00BE91A5F6794FEC83D8BFEEB4E897CD order by suggestdate      --2014-06-27
select count(doc_name) from form_Y00BE91A5F6794FEC83D8BFEEB4E897CD  group by doc_name   --5602
select count(doc_name) from form_Y00BE91A5F6794FEC83D8BFEEB4E897CD where suggestdate > '20140401' AND suggestdate <'20150501'  group by doc_name --2029
select count(doc_name) from form_Y00BE91A5F6794FEC83D8BFEEB4E897CD where suggestdate > '2010' AND suggestdate <'2011'  group by doc_name --526
select count(doc_name) from form_Y00BE91A5F6794FEC83D8BFEEB4E897CD where suggestdate > '2011' AND suggestdate <'2012'  group by doc_name --252
select count(doc_name) from form_Y00BE91A5F6794FEC83D8BFEEB4E897CD where suggestdate > '2012' AND suggestdate <'2013'  group by doc_name --158
select count(doc_name) from form_Y00BE91A5F6794FEC83D8BFEEB4E897CD where suggestdate > '2013' AND suggestdate <'2014'  group by doc_name --5
select count(doc_name) from form_Y00BE91A5F6794FEC83D8BFEEB4E897CD where suggestdate > '2014' AND suggestdate <'2015'  group by doc_name --5401
select count(doc_name) from form_Y00BE91A5F6794FEC83D8BFEEB4E897CD where suggestdate > '2015' AND suggestdate <'2016'  group by doc_name --2029


Y96114A5C446F45EAA7DED812C7BF1A54    --시스템권한신청서
select top 1 * from form_Y96114A5C446F45EAA7DED812C7BF1A54 order by suggestdate      --2014-08-26
select count(doc_name) from form_Y96114A5C446F45EAA7DED812C7BF1A54  group by doc_name   --5602
select count(doc_name) from form_Y96114A5C446F45EAA7DED812C7BF1A54 where suggestdate > '20140401' AND suggestdate <'20150501'  group by doc_name --2029
select count(doc_name) from form_Y96114A5C446F45EAA7DED812C7BF1A54 where suggestdate > '2010' AND suggestdate <'2011'  group by doc_name --526
select count(doc_name) from form_Y96114A5C446F45EAA7DED812C7BF1A54 where suggestdate > '2011' AND suggestdate <'2012'  group by doc_name --252
select count(doc_name) from form_Y96114A5C446F45EAA7DED812C7BF1A54 where suggestdate > '2012' AND suggestdate <'2013'  group by doc_name --158
select count(doc_name) from form_Y96114A5C446F45EAA7DED812C7BF1A54 where suggestdate > '2013' AND suggestdate <'2014'  group by doc_name --5
select count(doc_name) from form_Y96114A5C446F45EAA7DED812C7BF1A54 where suggestdate > '2014' AND suggestdate <'2015'  group by doc_name --5401
select count(doc_name) from form_Y96114A5C446F45EAA7DED812C7BF1A54 where suggestdate > '2015' AND suggestdate <'2016'  group by doc_name --2029


YB8BBB793520E47748E392E1234610027   --전산처리의뢰서(CSR)
select top 10 * from form_YB8BBB793520E47748E392E1234610027 order by suggestdate      --2014-12-01
select count(doc_name) from form_YB8BBB793520E47748E392E1234610027  group by doc_name   --5602
select count(doc_name) from form_YB8BBB793520E47748E392E1234610027 where suggestdate > '20140401' AND suggestdate <'20150501'  group by doc_name --2029
select count(doc_name) from form_YB8BBB793520E47748E392E1234610027 where suggestdate > '2014' AND suggestdate <'20140401'  group by doc_name --2029
select count(doc_name) from form_YB8BBB793520E47748E392E1234610027 where suggestdate > '2010' AND suggestdate <'2011'  group by doc_name --526
select count(doc_name) from form_YB8BBB793520E47748E392E1234610027 where suggestdate > '2011' AND suggestdate <'2012'  group by doc_name --252
select count(doc_name) from form_YB8BBB793520E47748E392E1234610027 where suggestdate > '2012' AND suggestdate <'2013'  group by doc_name --158
select count(doc_name) from form_YB8BBB793520E47748E392E1234610027 where suggestdate > '2013' AND suggestdate <'2014'  group by doc_name --5
select count(doc_name) from form_YB8BBB793520E47748E392E1234610027 where suggestdate > '2014' AND suggestdate <'2015'  group by doc_name --5401
select count(doc_name) from form_YB8BBB793520E47748E392E1234610027 where suggestdate > '2015' AND suggestdate <'2016'  group by doc_name --2029


Y54C64AC297CD4218968B965CE9EA2482     --전산처리의뢰서(개발/변경)
select top 1 * from form_Y54C64AC297CD4218968B965CE9EA2482 order by suggestdate      --2014-12-15
select count(doc_name) from form_Y54C64AC297CD4218968B965CE9EA2482  group by doc_name   --5602
select count(doc_name) from form_Y54C64AC297CD4218968B965CE9EA2482 where suggestdate > '20140401' AND suggestdate <'20150501'  group by doc_name --2029
select count(doc_name) from form_Y54C64AC297CD4218968B965CE9EA2482 where suggestdate > '2010' AND suggestdate <'2011'  group by doc_name --526
select count(doc_name) from form_Y54C64AC297CD4218968B965CE9EA2482 where suggestdate > '2011' AND suggestdate <'2012'  group by doc_name --252
select count(doc_name) from form_Y54C64AC297CD4218968B965CE9EA2482 where suggestdate > '2012' AND suggestdate <'2013'  group by doc_name --158
select count(doc_name) from form_Y54C64AC297CD4218968B965CE9EA2482 where suggestdate > '2013' AND suggestdate <'2014'  group by doc_name --5
select count(doc_name) from form_Y54C64AC297CD4218968B965CE9EA2482 where suggestdate > '2014' AND suggestdate <'2015'  group by doc_name --5401
select count(doc_name) from form_Y54C64AC297CD4218968B965CE9EA2482 where suggestdate > '2015' AND suggestdate <'2016'  group by doc_name --2029


Y34842D9B404A4D72A55DC5AED0C20BDC    --전산처리의뢰서(자료추출/권한요청)
select top 1 * from form_Y34842D9B404A4D72A55DC5AED0C20BDC order by suggestdate      --2014-12-15
select count(doc_name) from form_Y34842D9B404A4D72A55DC5AED0C20BDC  group by doc_name   --5602
select count(doc_name) from form_Y34842D9B404A4D72A55DC5AED0C20BDC where suggestdate > '20140401' AND suggestdate <'20150501'  group by doc_name --2029
select count(doc_name) from form_Y34842D9B404A4D72A55DC5AED0C20BDC where suggestdate > '2010' AND suggestdate <'2011'  group by doc_name --526
select count(doc_name) from form_Y34842D9B404A4D72A55DC5AED0C20BDC where suggestdate > '2011' AND suggestdate <'2012'  group by doc_name --252
select count(doc_name) from form_Y34842D9B404A4D72A55DC5AED0C20BDC where suggestdate > '2012' AND suggestdate <'2013'  group by doc_name --158
select count(doc_name) from form_Y34842D9B404A4D72A55DC5AED0C20BDC where suggestdate > '2013' AND suggestdate <'2014'  group by doc_name --5
select count(doc_name) from form_Y34842D9B404A4D72A55DC5AED0C20BDC where suggestdate > '2014' AND suggestdate <'2015'  group by doc_name --5401
select count(doc_name) from form_Y34842D9B404A4D72A55DC5AED0C20BDC where suggestdate > '2015' AND suggestdate <'2016'  group by doc_name --2029



Y9818DD0694314EE3B0FD3157E6B21B81    --이월체상신청서
select * from form_Y9818DD0694314EE3B0FD3157E6B21B81 order by suggestdate    --2015-02-11
select count(doc_name) from form_Y9818DD0694314EE3B0FD3157E6B21B81  group by doc_name   --5602
select count(doc_name) from form_Y9818DD0694314EE3B0FD3157E6B21B81 where suggestdate > '20140401' AND suggestdate <'20150500'  group by doc_name --2029
select count(doc_name) from form_Y9818DD0694314EE3B0FD3157E6B21B81 where suggestdate > '20150501' AND suggestdate <'20150519'  group by doc_name --2029
select count(doc_name) from form_Y9818DD0694314EE3B0FD3157E6B21B81 where suggestdate > '2010' AND suggestdate <'2011'  group by doc_name --526
select count(doc_name) from form_Y9818DD0694314EE3B0FD3157E6B21B81 where suggestdate > '2011' AND suggestdate <'2012'  group by doc_name --252
select count(doc_name) from form_Y9818DD0694314EE3B0FD3157E6B21B81 where suggestdate > '2012' AND suggestdate <'2013'  group by doc_name --158
select count(doc_name) from form_Y9818DD0694314EE3B0FD3157E6B21B81 where suggestdate > '2013' AND suggestdate <'2014'  group by doc_name --5
select count(doc_name) from form_Y9818DD0694314EE3B0FD3157E6B21B81 where suggestdate > '2014' AND suggestdate <'2015'  group by doc_name --5401
select count(doc_name) from form_Y9818DD0694314EE3B0FD3157E6B21B81 where suggestdate > '2015' AND suggestdate <'2016'  group by doc_name --2029


Y6FDAA64B62544CF1B4ABAD28550BFE23
select top 1 * from form_Y6FDAA64B62544CF1B4ABAD28550BFE23 order by suggestdate      --2008-05-27
select count(doc_name) from form_Y6FDAA64B62544CF1B4ABAD28550BFE23  group by doc_name   --5602
select count(doc_name) from form_Y6FDAA64B62544CF1B4ABAD28550BFE23 where suggestdate > '20140401' AND suggestdate <'20150501'  group by doc_name --2029
select count(doc_name) from form_Y6FDAA64B62544CF1B4ABAD28550BFE23 where suggestdate > '2010' AND suggestdate <'2011'  group by doc_name --526
select count(doc_name) from form_Y6FDAA64B62544CF1B4ABAD28550BFE23 where suggestdate > '2011' AND suggestdate <'2012'  group by doc_name --252
select count(doc_name) from form_Y6FDAA64B62544CF1B4ABAD28550BFE23 where suggestdate > '2012' AND suggestdate <'2013'  group by doc_name --158
select count(doc_name) from form_Y6FDAA64B62544CF1B4ABAD28550BFE23 where suggestdate > '2013' AND suggestdate <'2014'  group by doc_name --5
select count(doc_name) from form_Y6FDAA64B62544CF1B4ABAD28550BFE23 where suggestdate > '2014' AND suggestdate <'2015'  group by doc_name --5401
select count(doc_name) from form_Y6FDAA64B62544CF1B4ABAD28550BFE23 where suggestdate > '2015' AND suggestdate <'2016'  group by doc_name --2029


Y8410F34EDFE44A6098AF6F9938C8F8C2    --화재및안전사고점검일지
select top 1 * from form_Y8410F34EDFE44A6098AF6F9938C8F8C2 order by suggestdate      --2008-05-27
select count(doc_name) from form_Y8410F34EDFE44A6098AF6F9938C8F8C2  group by doc_name   --5602
select count(doc_name) from form_Y8410F34EDFE44A6098AF6F9938C8F8C2 where suggestdate > '20140401' AND suggestdate <'20150501'  group by doc_name --2029
select count(doc_name) from form_Y8410F34EDFE44A6098AF6F9938C8F8C2 where suggestdate > '2010' AND suggestdate <'2011'  group by doc_name --526
select count(doc_name) from form_Y8410F34EDFE44A6098AF6F9938C8F8C2 where suggestdate > '2011' AND suggestdate <'2012'  group by doc_name --252
select count(doc_name) from form_Y8410F34EDFE44A6098AF6F9938C8F8C2 where suggestdate > '2012' AND suggestdate <'2013'  group by doc_name --158
select count(doc_name) from form_Y8410F34EDFE44A6098AF6F9938C8F8C2 where suggestdate > '2013' AND suggestdate <'2014'  group by doc_name --5
select count(doc_name) from form_Y8410F34EDFE44A6098AF6F9938C8F8C2 where suggestdate > '2014' AND suggestdate <'2015'  group by doc_name --5401
select count(doc_name) from form_Y8410F34EDFE44A6098AF6F9938C8F8C2 where suggestdate > '2015' AND suggestdate <'2016'  group by doc_name --2029



Y41917174934749BAA72F13D558BFDAD9
select top 1 * from form_Y41917174934749BAA72F13D558BFDAD9 order by suggestdate      --2014-12-05
select count(doc_name) from form_Y41917174934749BAA72F13D558BFDAD9  group by doc_name   --5602
select count(doc_name) from form_Y41917174934749BAA72F13D558BFDAD9 where suggestdate > '20140401' AND suggestdate <'20150501'  group by doc_name --2029
select count(doc_name) from form_Y41917174934749BAA72F13D558BFDAD9 where suggestdate > '2014' AND suggestdate <'2015'  group by doc_name --5401
select count(doc_name) from form_Y41917174934749BAA72F13D558BFDAD9 where suggestdate > '2015' AND suggestdate <'2016'  group by doc_name --2029

Y3EAF96CF291D44AD885E970420231CDD    --전산처리완료보고서(개발/변경)
select top 1 * from form_Y3EAF96CF291D44AD885E970420231CDD order by suggestdate      --2014-12-15
select count(doc_name) from form_Y3EAF96CF291D44AD885E970420231CDD  group by doc_name   --5602
select count(doc_name) from form_Y3EAF96CF291D44AD885E970420231CDD where suggestdate > '20140401' AND suggestdate <'20150501'  group by doc_name --2029
select count(doc_name) from form_Y3EAF96CF291D44AD885E970420231CDD where suggestdate > '2014' AND suggestdate <'2015'  group by doc_name --5401
select count(doc_name) from form_Y3EAF96CF291D44AD885E970420231CDD where suggestdate > '2015' AND suggestdate <'2016'  group by doc_name --2029


YA8A03008E3B44079A4C41705CDA97979   --담보의뢰품의서
select top 1 * from form_YA8A03008E3B44079A4C41705CDA97979 order by suggestdate      --2008-05-27
select count(doc_name) from form_YA8A03008E3B44079A4C41705CDA97979  group by doc_name   --5602
select count(doc_name) from form_YA8A03008E3B44079A4C41705CDA97979 where suggestdate > '20140401' AND suggestdate <'20150501'  group by doc_name --2029
select count(doc_name) from form_YA8A03008E3B44079A4C41705CDA97979 where suggestdate > '2010' AND suggestdate <'2011'  group by doc_name --526
select count(doc_name) from form_YA8A03008E3B44079A4C41705CDA97979 where suggestdate > '2011' AND suggestdate <'2012'  group by doc_name --252
select count(doc_name) from form_YA8A03008E3B44079A4C41705CDA97979 where suggestdate > '2012' AND suggestdate <'2013'  group by doc_name --158
select count(doc_name) from form_YA8A03008E3B44079A4C41705CDA97979 where suggestdate > '2013' AND suggestdate <'2014'  group by doc_name --5
select count(doc_name) from form_YA8A03008E3B44079A4C41705CDA97979 where suggestdate > '2014' AND suggestdate <'2015'  group by doc_name --5401
select count(doc_name) from form_YA8A03008E3B44079A4C41705CDA97979 where suggestdate > '2015' AND suggestdate <'2016'  group by doc_name --2029

Y0E59258A07B345E8864D70DB9531B186  사외교육수강신청서

select top 1 * from form_Y0E59258A07B345E8864D70DB9531B186 order by suggestdate      --2008-05-27
select count(doc_name) from form_Y0E59258A07B345E8864D70DB9531B186  group by doc_name   --5602
select count(doc_name) from form_Y0E59258A07B345E8864D70DB9531B186 where suggestdate > '20140401' AND suggestdate <'20150501'  group by doc_name --2029
select count(doc_name) from form_Y0E59258A07B345E8864D70DB9531B186 where suggestdate > '2010' AND suggestdate <'2011'  group by doc_name --526
select count(doc_name) from form_Y0E59258A07B345E8864D70DB9531B186 where suggestdate > '2011' AND suggestdate <'2012'  group by doc_name --252
select count(doc_name) from form_Y0E59258A07B345E8864D70DB9531B186 where suggestdate > '2012' AND suggestdate <'2013'  group by doc_name --158
select count(doc_name) from form_Y0E59258A07B345E8864D70DB9531B186 where suggestdate > '2013' AND suggestdate <'2014'  group by doc_name --5
select count(doc_name) from form_Y0E59258A07B345E8864D70DB9531B186 where suggestdate > '2014' AND suggestdate <'2015'  group by doc_name --5401
select count(doc_name) from form_Y0E59258A07B345E8864D70DB9531B186 where suggestdate > '2015' AND suggestdate <'2016'  group by doc_name --2029


Y1154FBB3DE604374AABE54642BE7ADC5   --월근태현황보고서
select top 1 * from form_Y1154FBB3DE604374AABE54642BE7ADC5 order by suggestdate      --2008-05-27
select count(doc_name) from form_Y1154FBB3DE604374AABE54642BE7ADC5  group by doc_name   --5602
select count(doc_name) from form_Y1154FBB3DE604374AABE54642BE7ADC5 where suggestdate > '20140401' AND suggestdate <'20150501'  group by doc_name --2029
select count(doc_name) from form_Y1154FBB3DE604374AABE54642BE7ADC5 where suggestdate > '2010' AND suggestdate <'2011'  group by doc_name --526
select count(doc_name) from form_Y1154FBB3DE604374AABE54642BE7ADC5 where suggestdate > '2011' AND suggestdate <'2012'  group by doc_name --252
select count(doc_name) from form_Y1154FBB3DE604374AABE54642BE7ADC5 where suggestdate > '2012' AND suggestdate <'2013'  group by doc_name --158
select count(doc_name) from form_Y1154FBB3DE604374AABE54642BE7ADC5 where suggestdate > '2013' AND suggestdate <'2014'  group by doc_name --5
select count(doc_name) from form_Y1154FBB3DE604374AABE54642BE7ADC5 where suggestdate > '2014' AND suggestdate <'2015'  group by doc_name --5401
select count(doc_name) from form_Y1154FBB3DE604374AABE54642BE7ADC5 where suggestdate > '2015' AND suggestdate <'2016'  group by doc_name --2029


YEF7F7187DC3F4AD48B2FC7308DEB9B28    준공(기성)조서

select top 1 * from form_YEF7F7187DC3F4AD48B2FC7308DEB9B28 order by suggestdate   -- 2008-02-28
select count(doc_name) from form_YEF7F7187DC3F4AD48B2FC7308DEB9B28  group by doc_name   --5602
select count(doc_name) from form_YEF7F7187DC3F4AD48B2FC7308DEB9B28 where suggestdate > '20140401' AND suggestdate <'20150501'  group by doc_name --2029
select count(doc_name) from form_YEF7F7187DC3F4AD48B2FC7308DEB9B28 where suggestdate > '2010' AND suggestdate <'2011'  group by doc_name --526
select count(doc_name) from form_YEF7F7187DC3F4AD48B2FC7308DEB9B28 where suggestdate > '2011' AND suggestdate <'2012'  group by doc_name --252
select count(doc_name) from form_YEF7F7187DC3F4AD48B2FC7308DEB9B28 where suggestdate > '2012' AND suggestdate <'2013'  group by doc_name --158
select count(doc_name) from form_YEF7F7187DC3F4AD48B2FC7308DEB9B28 where suggestdate > '2013' AND suggestdate <'2014'  group by doc_name --5
select count(doc_name) from form_YEF7F7187DC3F4AD48B2FC7308DEB9B28 where suggestdate > '2014' AND suggestdate <'2015'  group by doc_name --5401
select count(doc_name) from form_YEF7F7187DC3F4AD48B2FC7308DEB9B28 where suggestdate > '2015' AND suggestdate <'2016'  group by doc_name --2029

YCA1568A371EB4B81B78F2A0708B2461D  콘도이용신청서(연동)

select top 1 * from form_YCA1568A371EB4B81B78F2A0708B2461D order by suggestdate   -- 2008-02-28


YB979AF89EE92423B8F6A66C122F2E39E   --법인인감사용신청서
select top 1 * from form_YB979AF89EE92423B8F6A66C122F2E39E order by suggestdate   -- 2013-08-01
select count(doc_name) from form_YB979AF89EE92423B8F6A66C122F2E39E  group by doc_name   --5602
select count(doc_name) from form_YB979AF89EE92423B8F6A66C122F2E39E where suggestdate > '20140401' AND suggestdate <'20150501'  group by doc_name --2029
select count(doc_name) from form_YB979AF89EE92423B8F6A66C122F2E39E where suggestdate > '2010' AND suggestdate <'2011'  group by doc_name --526
select count(doc_name) from form_YB979AF89EE92423B8F6A66C122F2E39E where suggestdate > '2011' AND suggestdate <'2012'  group by doc_name --252
select count(doc_name) from form_YB979AF89EE92423B8F6A66C122F2E39E where suggestdate > '2012' AND suggestdate <'2013'  group by doc_name --158
select count(doc_name) from form_YB979AF89EE92423B8F6A66C122F2E39E where suggestdate > '2013' AND suggestdate <'2014'  group by doc_name --5
select count(doc_name) from form_YB979AF89EE92423B8F6A66C122F2E39E where suggestdate > '2014' AND suggestdate <'2015'  group by doc_name --5401
select count(doc_name) from form_YB979AF89EE92423B8F6A66C122F2E39E where suggestdate > '2015' AND suggestdate <'2016'  group by doc_name --2029



Y99738B95642141AABB7CCD387668E6FF
select top 1 * from form_Y99738B95642141AABB7CCD387668E6FF order by suggestdate   -- 2014-06-27
select count(doc_name) from form_Y99738B95642141AABB7CCD387668E6FF  group by doc_name   --5602
select count(doc_name) from form_Y99738B95642141AABB7CCD387668E6FF where suggestdate > '20140401' AND suggestdate <'20150501'  group by doc_name --2029
select count(doc_name) from form_Y99738B95642141AABB7CCD387668E6FF where suggestdate > '2014' AND suggestdate <'2015'  group by doc_name --5401
select count(doc_name) from form_Y99738B95642141AABB7CCD387668E6FF where suggestdate > '2015' AND suggestdate <'2016'  group by doc_name --2029



Y80F6EE6C87564C248CD342E46C890AE9    --법인차량휴일운행신청
select top 1 * from form_Y80F6EE6C87564C248CD342E46C890AE9 order by suggestdate   -- 2015-01-17
select count(doc_name) from form_Y80F6EE6C87564C248CD342E46C890AE9  group by doc_name   --5602
select count(doc_name) from form_Y80F6EE6C87564C248CD342E46C890AE9 where suggestdate > '20140401' AND suggestdate <'20150501'  group by doc_name --2029
select count(doc_name) from form_Y80F6EE6C87564C248CD342E46C890AE9 where suggestdate > '2014' AND suggestdate <'2015'  group by doc_name --5401
select count(doc_name) from form_Y80F6EE6C87564C248CD342E46C890AE9 where suggestdate > '2015' AND suggestdate <'2016'  group by doc_name --2029




