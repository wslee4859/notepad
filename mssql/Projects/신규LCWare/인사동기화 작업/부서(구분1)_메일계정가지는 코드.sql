select 
employee_num,
user_name ,
email 
from [IM].[VIEW_USER]
where 1=1
AND email is not null
AND employee_num in (
'00100',
'00101',
'00102',
'00103',
'00107',
'00118',
'00120',
'00121',
'00122',
'00123',
'00126',
'00127',
'00129',
'00131',
'00132',
'00133',
'00134',
'00135',
'00136',
'00140',
'00148',
'00149',
'00153',
'00155',
'00157',
'00158',
'00161',
'00173',
'00177',
'00178',
'00180',
'00181',
'00183',
'00184',
'00185',
'00186',
'00187',
'00188',
'00190',
'00191',
'00192',
'00193',
'00195',
'00196',
'00197',
'00199',
'00200',
'00201',
'00203',
'00204',
'00205',
'00206',
'00209',
'00210',
'00211',
'00212',
'00213',
'00215',
'00216',
'00217',
'00218',
'00220',
'00221',
'00222',
'00223',
'00224',
'00225',
'00226',
'00227',
'00228',
'00229',
'00230',
'00231',
'00234',
'00235',
'00236',
'00237',
'00238',
'00239',
'00240',
'00241',
'00243',
'00244',
'00245',
'00246',
'00251',
'00252',
'00253',
'00254',
'00255',
'00257',
'00258',
'00259',
'00260',
'00261',
'00262',
'00263',
'00264',
'00269',
'00270',
'00271',
'00272',
'00273',
'00274',
'00275',
'00276',
'00277',
'00278',
'00286',
'00287',
'00289',
'00290',
'00291',
'00292',
'00293',
'00294',
'00295',
'00297',
'00299',
'00301',
'00302',
'00304',
'00312',
'00318',
'00319',
'00335',
'00336',
'00339',
'00344',
'00345',
'00354',
'00373',
'00383',
'00394',
'00403',
'00406',
'00413',
'00433',
'00434',
'00530',
'00531',
'00536',
'00566',
'00568',
'00569',
'00570',
'00571',
'00572',
'00573',
'00574',
'00576',
'00577',
'00578',
'00579',
'00580',
'00581',
'00582',
'00583',
'00584',
'00585',
'00586',
'00587',
'00588',
'00589',
'00591',
'00592',
'00593',
'00594',
'00595',
'00610',
'01001',
'01002',
'01006',
'01024',
'01025',
'01026',
'01027',
'01028',
'01033',
'01034',
'01035',
'01113',
'01137',
'01138',
'01139',
'01141',
'01152',
'01153',
'01155',
'01166',
'01171',
'01172',
'01186',
'01200',
'01201',
'01202',
'01203',
'01204',
'01207',
'01213',
'01214',
'01215',
'01216',
'01218',
'01219',
'01220',
'01221',
'01222',
'01223',
'01224',
'01230',
'01232',
'01233',
'01234',
'01235',
'01236',
'01237',
'01238',
'01239',
'01242',
'01243',
'01266',
'01291',
'01292',
'01293',
'01294',
'01296',
'01298',
'01300',
'01301',
'01302',
'01307',
'01308',
'01310',
'01311',
'01314',
'01369' ,
'08158',
'08238' )
order by employee_num 