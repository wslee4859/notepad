use emanage
select * from dbo.TB_DEPT where deptName like '%�ƻ���%'





use ewfform
YE642705502F94481AE9024674E18A103  --���κ��� 
select * from form_YE642705502F94481AE9024674E18A103 where CREATOR_DEPT like '%�ƻ���%' OR DEPTNAME like '%�ƻ���%'  order by suggestdate   -- 2015-01-17

select count(doc_name) from form_Y80F6EE6C87564C248CD342E46C890AE9  group by doc_name   --5602
select count(doc_name) from form_Y80F6EE6C87564C248CD342E46C890AE9 where suggestdate > '20140401' AND suggestdate <'20150501'  group by doc_name --2029
select count(doc_name) from form_Y80F6EE6C87564C248CD342E46C890AE9 where suggestdate > '2014' AND suggestdate <'2015'  group by doc_name --5401
select count(doc_name) from form_Y80F6EE6C87564C248CD342E46C890AE9 where suggestdate > '2015' AND suggestdate <'2016'  group by doc_name --2029

Y72AEB236B04E460FA3B81DAB9125D58E  --��ǰ��û��
select * from form_Y72AEB236B04E460FA3B81DAB9125D58E where CREATOR_DEPT like '%�ƻ���%' order by suggestdate   -- 2015-01-17
select count(doc_name) from form_Y72AEB236B04E460FA3B81DAB9125D58E where suggestdate > '20140401' AND suggestdate <'20150501' AND CREATOR_DEPT like '%�ƻ���%'  group by doc_name --0

Y00651F8C793843BDB04C6DB25765FB41   --ĥ��(��)���ѿ�û
select top 1 * from form_Y00651F8C793843BDB04C6DB25765FB41  where CREATOR_DEPT like '%�ƻ���%' order by suggestdate   -- 2015-01-17
select doc_name, count(doc_name) from form_Y00651F8C793843BDB04C6DB25765FB41  where CREATOR_DEPT like '%�ƻ���%' group by doc_name   -- 2015-01-17
select count(doc_name) from form_Y00651F8C793843BDB04C6DB25765FB41 where suggestdate > '20140401' AND suggestdate <'20150501' AND CREATOR_DEPT like '%�ƻ���%'  group by doc_name --0
select count(doc_name) from form_Y00651F8C793843BDB04C6DB25765FB41 where suggestdate > '2010' AND suggestdate <'2011' AND CREATOR_DEPT like '%�ƻ���%' group by doc_name --5401
select count(doc_name) from form_Y00651F8C793843BDB04C6DB25765FB41 where suggestdate > '2011' AND suggestdate <'2012' AND CREATOR_DEPT like '%�ƻ���%' group by doc_name --2029
select count(doc_name) from form_Y00651F8C793843BDB04C6DB25765FB41 where suggestdate > '2012' AND suggestdate <'2013' AND CREATOR_DEPT like '%�ƻ���%' group by doc_name --5401
select count(doc_name) from form_Y00651F8C793843BDB04C6DB25765FB41 where suggestdate > '2013' AND suggestdate <'2014' AND CREATOR_DEPT like '%�ƻ���%' group by doc_name --2029
select count(doc_name) from form_Y00651F8C793843BDB04C6DB25765FB41 where suggestdate > '2014' AND suggestdate <'2015' AND CREATOR_DEPT like '%�ƻ���%' group by doc_name --2029
select count(doc_name) from form_Y00651F8C793843BDB04C6DB25765FB41 where suggestdate > '2015' AND suggestdate <'2016' AND CREATOR_DEPT like '%�ƻ���%' group by doc_name --2029
select count(doc_name) from form_Y00651F8C793843BDB04C6DB25765FB41 where suggestdate is null AND CREATOR_DEPT like '%�ƻ���%' group by doc_name --2029


YAE2F85A901AF4B43BC6906EF06C8DB83
select  * from form_YAE2F85A901AF4B43BC6906EF06C8DB83  where CREATOR_DEPT like '%�ƻ���%' order by suggestdate   -- 2015-01-17
select '��',doc_name, count(doc_name) from form_YAE2F85A901AF4B43BC6906EF06C8DB83  where CREATOR_DEPT like '%�ƻ���%' group by doc_name   -- 2015-01-17
select '1��',count(doc_name) from form_YAE2F85A901AF4B43BC6906EF06C8DB83 where suggestdate > '20140401' AND suggestdate <'20150501' AND CREATOR_DEPT like '%�ƻ���%'  group by doc_name --0
select '2010',count(doc_name) from form_YAE2F85A901AF4B43BC6906EF06C8DB83 where suggestdate > '2010' AND suggestdate <'2011' AND CREATOR_DEPT like '%�ƻ���%' group by doc_name --5401
select '2011',count(doc_name) from form_YAE2F85A901AF4B43BC6906EF06C8DB83 where suggestdate > '2011' AND suggestdate <'2012' AND CREATOR_DEPT like '%�ƻ���%' group by doc_name --2029
select '2012',count(doc_name) from form_YAE2F85A901AF4B43BC6906EF06C8DB83 where suggestdate > '2012' AND suggestdate <'2013' AND CREATOR_DEPT like '%�ƻ���%' group by doc_name --5401
select '2013',count(doc_name) from form_YAE2F85A901AF4B43BC6906EF06C8DB83 where suggestdate > '2013' AND suggestdate <'2014' AND CREATOR_DEPT like '%�ƻ���%' group by doc_name --2029
select '2014',count(doc_name) from form_YAE2F85A901AF4B43BC6906EF06C8DB83 where suggestdate > '2014' AND suggestdate <'2015' AND CREATOR_DEPT like '%�ƻ���%' group by doc_name --2029
select '2015',count(doc_name) from form_YAE2F85A901AF4B43BC6906EF06C8DB83 where suggestdate > '2015' AND suggestdate <'2016' AND CREATOR_DEPT like '%�ƻ���%' group by doc_name --2029
select 'NULL',count(doc_name) from form_YAE2F85A901AF4B43BC6906EF06C8DB83 where suggestdate is null AND CREATOR_DEPT like '%�ƻ���%' group by doc_name --2029



Y916C53AF4A1B45C3A2E5110227D8530B  -- ����Ҹ�ǰ ��û�� 
select  * from form_Y916C53AF4A1B45C3A2E5110227D8530B  where CREATOR_DEPT like '%�ƻ���%' order by suggestdate   -- 2015-01-17
select '��',doc_name, count(doc_name) from form_Y916C53AF4A1B45C3A2E5110227D8530B  where CREATOR_DEPT like '%�ƻ���%' group by doc_name   -- 2015-01-17
select '1��',count(doc_name) from form_Y916C53AF4A1B45C3A2E5110227D8530B where suggestdate > '20140401' AND suggestdate <'20150501' AND CREATOR_DEPT like '%�ƻ���%'  group by doc_name --0
select '2010',count(doc_name) from form_Y916C53AF4A1B45C3A2E5110227D8530B where suggestdate > '2010' AND suggestdate <'2011' AND CREATOR_DEPT like '%�ƻ���%' group by doc_name --5401
select '2011',count(doc_name) from form_Y916C53AF4A1B45C3A2E5110227D8530B where suggestdate > '2011' AND suggestdate <'2012' AND CREATOR_DEPT like '%�ƻ���%' group by doc_name --2029
select '2012',count(doc_name) from form_Y916C53AF4A1B45C3A2E5110227D8530B where suggestdate > '2012' AND suggestdate <'2013' AND CREATOR_DEPT like '%�ƻ���%' group by doc_name --5401
select '2013',count(doc_name) from form_Y916C53AF4A1B45C3A2E5110227D8530B where suggestdate > '2013' AND suggestdate <'2014' AND CREATOR_DEPT like '%�ƻ���%' group by doc_name --2029
select '2014',count(doc_name) from form_Y916C53AF4A1B45C3A2E5110227D8530B where suggestdate > '2014' AND suggestdate <'2015' AND CREATOR_DEPT like '%�ƻ���%' group by doc_name --2029
select '2015',count(doc_name) from form_Y916C53AF4A1B45C3A2E5110227D8530B where suggestdate > '2015' AND suggestdate <'2016' AND CREATOR_DEPT like '%�ƻ���%' group by doc_name --2029
select 'NULL',count(doc_name) from form_Y916C53AF4A1B45C3A2E5110227D8530B where suggestdate is null AND CREATOR_DEPT like '%�ƻ���%' group by doc_name --2029

Y97D6742FAE98424D94B34107A1B900D1   --�ް���
select  * from form_Y97D6742FAE98424D94B34107A1B900D1  where CREATOR_DEPT like '%�ƻ���%' order by suggestdate   -- 2015-01-17
select '��',doc_name, count(doc_name) from form_Y97D6742FAE98424D94B34107A1B900D1  where CREATOR_DEPT like '%�ƻ���%' group by doc_name   -- 2015-01-17
select '1��',count(doc_name) from form_Y97D6742FAE98424D94B34107A1B900D1 where suggestdate > '20140401' AND suggestdate <'20150501' AND CREATOR_DEPT like '%�ƻ���%'  group by doc_name --0
select '2010',count(doc_name) from form_Y97D6742FAE98424D94B34107A1B900D1 where suggestdate > '2010' AND suggestdate <'2011' AND CREATOR_DEPT like '%�ƻ���%' group by doc_name --5401
select '2011',count(doc_name) from form_Y97D6742FAE98424D94B34107A1B900D1 where suggestdate > '2011' AND suggestdate <'2012' AND CREATOR_DEPT like '%�ƻ���%' group by doc_name --2029
select '2012',count(doc_name) from form_Y97D6742FAE98424D94B34107A1B900D1 where suggestdate > '2012' AND suggestdate <'2013' AND CREATOR_DEPT like '%�ƻ���%' group by doc_name --5401
select '2013',count(doc_name) from form_Y97D6742FAE98424D94B34107A1B900D1 where suggestdate > '2013' AND suggestdate <'2014' AND CREATOR_DEPT like '%�ƻ���%' group by doc_name --2029
select '2014',count(doc_name) from form_Y97D6742FAE98424D94B34107A1B900D1 where suggestdate > '2014' AND suggestdate <'2015' AND CREATOR_DEPT like '%�ƻ���%' group by doc_name --2029
select '2015',count(doc_name) from form_Y97D6742FAE98424D94B34107A1B900D1 where suggestdate > '2015' AND suggestdate <'2016' AND CREATOR_DEPT like '%�ƻ���%' group by doc_name --2029
select 'NULL',count(doc_name) from form_Y97D6742FAE98424D94B34107A1B900D1 where suggestdate is null AND CREATOR_DEPT like '%�ƻ���%' group by doc_name --2029

-- ��ȼ� Y28B72F2F7EE54FB5BE13E8F2A3637978   
select  * from form_Y28B72F2F7EE54FB5BE13E8F2A3637978  where CREATOR_DEPT like '%�ƻ���%' order by suggestdate   -- 2015-01-17
select '��',doc_name, count(doc_name) from form_Y28B72F2F7EE54FB5BE13E8F2A3637978  where CREATOR_DEPT like '%�ƻ���%' group by doc_name   -- 2015-01-17
select '1��',count(doc_name) from form_Y28B72F2F7EE54FB5BE13E8F2A3637978 where suggestdate > '20140401' AND suggestdate <'20150501' AND CREATOR_DEPT like '%�ƻ���%'  group by doc_name --0
select '2010',count(doc_name) from form_Y28B72F2F7EE54FB5BE13E8F2A3637978 where suggestdate > '2010' AND suggestdate <'2011' AND CREATOR_DEPT like '%�ƻ���%' group by doc_name --5401
select '2011',count(doc_name) from form_Y28B72F2F7EE54FB5BE13E8F2A3637978 where suggestdate > '2011' AND suggestdate <'2012' AND CREATOR_DEPT like '%�ƻ���%' group by doc_name --2029
select '2012',count(doc_name) from form_Y28B72F2F7EE54FB5BE13E8F2A3637978 where suggestdate > '2012' AND suggestdate <'2013' AND CREATOR_DEPT like '%�ƻ���%' group by doc_name --5401
select '2013',count(doc_name) from form_Y28B72F2F7EE54FB5BE13E8F2A3637978 where suggestdate > '2013' AND suggestdate <'2014' AND CREATOR_DEPT like '%�ƻ���%' group by doc_name --2029
select '2014',count(doc_name) from form_Y28B72F2F7EE54FB5BE13E8F2A3637978 where suggestdate > '2014' AND suggestdate <'2015' AND CREATOR_DEPT like '%�ƻ���%' group by doc_name --2029
select '2015',count(doc_name) from form_Y28B72F2F7EE54FB5BE13E8F2A3637978 where suggestdate > '2015' AND suggestdate <'2016' AND CREATOR_DEPT like '%�ƻ���%' group by doc_name --2029
select 'NULL',count(doc_name) from form_Y28B72F2F7EE54FB5BE13E8F2A3637978 where suggestdate is null AND CREATOR_DEPT like '%�ƻ���%' group by doc_name --2029

YFA4BC440266849EB8DBA1A1FE7C55EE6   --��ȼ�(������)
select '��',doc_name, count(doc_name) from form_YFA4BC440266849EB8DBA1A1FE7C55EE6  where CREATOR_DEPT like '%�ƻ���%' group by doc_name   -- 2015-01-17

Y6641518B4578423DA1C957F43B0D8073   --������ġǰ�Ǽ�
select '��',doc_name, count(doc_name) from form_Y6641518B4578423DA1C957F43B0D8073  where CREATOR_DEPT like '%�ƻ���%' group by doc_name   -- 2015-01-17

YB9222DABFA484AC6AC97F2A23C649789   --�ŷ�ó����ǰ�Ǽ�(��������) 
select '��',doc_name, count(doc_name) from form_YB9222DABFA484AC6AC97F2A23C649789 group by doc_name -- 2015-01-17



Y4161CD2F12EF4D3189DBB7A86DD35AA1	�̵�����û��
select  * from form_Y4161CD2F12EF4D3189DBB7A86DD35AA1  where CREATOR_DEPT like '%�ƻ���%' order by suggestdate   -- 2015-01-17
select '��',doc_name, count(doc_name) from form_Y4161CD2F12EF4D3189DBB7A86DD35AA1  where CREATOR_DEPT like '%�ƻ���%' group by doc_name   -- 2015-01-17





Y53451C069B8C4053A29BB19AD20ACC3A	��������
select  * from form_Y53451C069B8C4053A29BB19AD20ACC3A  where CREATOR_DEPT like '%�ƻ���%' order by suggestdate   -- 2015-01-17
select '��',doc_name, count(doc_name) from form_Y53451C069B8C4053A29BB19AD20ACC3A  where CREATOR_DEPT like '%�ƻ���%' group by doc_name   -- 2015-01-17

YF4D485FF13FD45A686B9D34765374B3D	��ü�����μ�
select  * from form_YF4D485FF13FD45A686B9D34765374B3D  where CREATOR_DEPT like '%�ƻ���%' order by suggestdate   -- 2015-01-17
select '��',doc_name, count(doc_name) from form_YF4D485FF13FD45A686B9D34765374B3D  where CREATOR_DEPT like '%�ƻ���%' group by doc_name   -- 2015-01-17


Y554019E6C220421B8E055DA484EB5305	��������������������ݽ�û��
select  * from form_Y554019E6C220421B8E055DA484EB5305  where CREATOR_DEPT like '%�ƻ���%' order by suggestdate   -- 2015-01-17
select '��',doc_name, count(doc_name) from form_Y554019E6C220421B8E055DA484EB5305  where CREATOR_DEPT like '%�ƻ���%' group by doc_name   -- 2015-01-17

Y5E3DDBF6A9A34CD092669F81E166B5B1	��Ź���Ž�û��
select  * from form_Y5E3DDBF6A9A34CD092669F81E166B5B1  where CREATOR_DEPT like '%�ƻ���%' order by suggestdate   -- 2015-01-17
select '��',doc_name, count(doc_name) from form_Y5E3DDBF6A9A34CD092669F81E166B5B1  where CREATOR_DEPT like '%�ƻ���%' group by doc_name   -- 2015-01-17



YDAB0A870E3EF4DE1B8902C498A69E652  --����ó���Ƿڼ�
select * from form_YDAB0A870E3EF4DE1B8902C498A69E652  where CREATOR_DEPT like '%�ƻ���%' order by suggestdate   -- 2015-01-17
select count(doc_name) from form_YDAB0A870E3EF4DE1B8902C498A69E652 where suggestdate > '20140401' AND suggestdate <'20150501' AND CREATOR_DEPT like '%�ƻ���%'  group by doc_name --0



