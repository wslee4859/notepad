select 
U.group_name,
--O.seq,
U.user_name,
U.position_name,
L.login_id,
count(L.login_id)
--ip_address
from [dbo].[LOGON_LOG_2016] AS L
INNER JOIN [IM].[VIEW_USER] AS U
ON L.login_id = U.login_id 
INNER JOIN [IM].[VIEW_ORG] AS O
ON U.group_code = O.group_code
WHERE login_time > '2018-03-01' AND L.site_code = 'SITE01'
AND U.group_name not like '%신협%'
AND U.group_name not like '%CH%'
AND U.group_name not like '%백학%'
AND (U.display_yn = 'Y' OR U.display_yn is null)
group by L.login_id, U.group_name, O.seq, U.user_name, U.classpos_seq, U.position_name
order by O.seq, U.classpos_seq




--[dbo].[LOGON_LOG_2016] where ip_address = '10.121.100.202' AND user_name = '문요한'

select 
U.group_name,
O.seq,
U.user_name,
U.position_name,
L.login_id,
count(L.login_id),
ip_address
from [dbo].[LOGON_LOG_2016] AS L
INNER JOIN [IM].[VIEW_USER] AS U
ON L.login_id = U.login_id 
INNER JOIN [IM].[VIEW_ORG] AS O
ON U.group_code = O.group_code
WHERE login_time > '2018-03-01'
AND 
ip_address in (
'10.121.65.201',
'10.121.75.44',
'10.121.44.41',
'10.121.89.203',
'10.121.67.200',
'10.121.67.72',
'10.121.93.223',
'10.121.89.202',
'10.121.68.200',
'10.121.38.89',
'10.121.102.26',
'10.121.66.201',
'10.121.47.50',
'10.121.55.202',
'10.121.55.201',
'10.121.38.90',
'10.121.102.25',
'10.121.49.36',
'10.121.44.220',
'10.121.44.221',
'10.121.55.200',
'10.121.102.221',
'10.121.49.200',
'10.121.49.201',
'10.121.109.220',
'10.121.65.200',
'10.121.67.60',
'10.121.68.201',
'10.121.66.202',
'10.121.66.200',
'10.121.89.200',
'10.121.89.201',
'10.121.38.200',
'10.121.93.219',
'10.121.93.220',
'10.121.75.220',
'10.121.75.221',
'10.121.75.222',
'10.121.21.200',
'10.121.53.220',
'10.121.42.200',
'10.121.132.200',
'10.121.57.200',
'10.121.57.201',
'10.121.102.220',
'10.121.21.203',
'10.121.31.106',
'10.121.50.201',
'10.121.56.201',
'10.121.99.199',
'10.121.99.200',
'10.121.70.199',
'10.121.64.40',
'10.121.95.95',
'10.121.90.200',
'10.121.73.200',
'10.121.81.55',
'10.121.83.200',
'10.121.105.45',
'10.121.105.46',
'10.121.98.32',
'10.121.87.200',
'10.121.87.201',
'10.121.100.202' )
group by L.login_id, L.ip_address, U.group_name, O.seq, U.user_name, U.position_name
order by O.seq

































































