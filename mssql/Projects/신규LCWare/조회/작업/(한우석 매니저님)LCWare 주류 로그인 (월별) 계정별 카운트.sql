select datepart(mm,login_time), user_name, count(*) from [dbo].[LOGON_LOG_2016] 
WHERE site_code = 'SITE01' 
AND login_time > '2018-06-01' 
--AND user_name = 'ÀÌ¿Ï»ó' 
group by datepart(mm,login_time), user_name
order by datepart(mm,login_time) desc









