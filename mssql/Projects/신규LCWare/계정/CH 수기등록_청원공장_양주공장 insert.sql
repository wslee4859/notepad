[dbo].[lotte_sync_bulk_user]

begin tran 
insert into [dbo].[lotte_sync_bulk_user]
values 
('LotteBev','smg1012',	'���̰�',	'20132012C',	'IM_00011','0066','0495','0015','','N','E','2015-12-23','9999-12-31',''),
('LotteBev','cjh1013',	'����ȣ',	'20132013C',	'IM_00012','0065','0228','0016','','N','E','2015-12-23','9999-12-31',''),
('LotteBev','bsi1014',	'������',	'20132014C',	'IM_00012','0066','0228','0017','','N','E','2015-12-23','9999-12-31',''),
('LotteBev','jjy1016',	'������',	'20132016C',	'IM_00012','0066','0228','0017','','N','E','2015-12-23','9999-12-31',''),
('LotteBev','hss2003',	'�㼺��',	'20152003C',	'IM_00012','0066','0228','0017','','N','E','2015-12-23','9999-12-31',''),
('LotteBev','ssg1019',	'�ۼ���',	'20132019C',	'IM_00012','0066','0084','0017','','N','E','2015-12-23','9999-12-31',''),
('LotteBev','yis1022',	'���λ�',	'20132022C',	'IM_00012','0066','0089','0017','','N','E','2015-12-23','9999-12-31',''),
('LotteBev','bmh1023',	'�����',	'20132023C',	'IM_00012','0065','0089','0016','','N','E','2015-12-23','9999-12-31',''),
('LotteBev','jhc1025',	'����ö',	'20132025C',	'IM_00012','0066','0142','0017','','N','E','2015-12-23','9999-12-31',''),
('LotteBev','hsh2006',	'�ѻ���',	'20142003C',	'IM_00012','0066','0085','0017','','N','E','2015-12-23','9999-12-31',''),
('LotteBev','yyg2007',	'������',	'20142007C',	'IM_00012','0066','0089','0017','','N','E','2015-12-23','9999-12-31',''),
('LotteBev','ky2008',	'�迵',		'20142008C',	'IM_00012','0066','0089','0017','','N','E','2015-12-23','9999-12-31',''),
('LotteBev','kgh2004',	'���ȯ',	'20152004C',	'IM_00012','0066','0084','0017','','N','E','2015-12-23','9999-12-31',''),
('LotteBev','kcg2006',	'��ö��',	'20152006C',	'IM_00012','0066','0089','0017','','N','E','2015-12-23','9999-12-31',''),
('LotteBev','lgh2007',	'�̰���',	'20152007C',	'IM_00012','0066','0089','0017','','N','E','2015-12-23','9999-12-31',''),
('LotteBev','ggj1026',	'������',	'20132026C',	'IM_00012','0065','0085','0016','','N','E','2015-12-23','9999-12-31',''),
('LotteBev','bhb1027',	'����',	'20132027C',	'IM_00012','0065','0085','0016','','N','E','2015-12-23','9999-12-31',''),
('LotteBev','gsh1028',	'�Ǽ���',	'20132028C',	'IM_00012','0066','0116','0017','','N','E','2015-12-23','9999-12-31',''),
('LotteBev','kye1029',	'�迵��',	'20132029C',	'IM_00012','0066','0116','0017','','N','E','2015-12-23','9999-12-31',''),
('LotteBev','jhs2005',	'��ȭ��',	'20152005C',	'IM_00012','0066','0116','0017','','N','E','2015-12-23','9999-12-31','')


begin tran 
update [dbo].[lotte_sync_bulk_user]
set login_id = 'cjh1013'
where code = '20132013C'

commit

begin tran 
insert into [dbo].[lotte_sync_bulk_user]
values 
('LotteBev',	'bhj2006',	'������',	'20133006C',	'IM_00014','0066','0495','0017','','N','E','2015-12-23','9999-12-31',''),
('LotteBev',	'chg2009',	'��ȫ��',	'20133009C',	'IM_00015','0064','0228','0015','','N','E','2015-12-23','9999-12-31',''),
('LotteBev',	'kky2010',	'��⿬',	'20133010C',	'IM_00015','0066','0228','0017','','N','E','2015-12-23','9999-12-31',''),
('LotteBev',	'jmj2016',	'������',	'20133016C',	'IM_00015','0066','0418','0017','','N','E','2015-12-23','9999-12-31','')

commit


       





