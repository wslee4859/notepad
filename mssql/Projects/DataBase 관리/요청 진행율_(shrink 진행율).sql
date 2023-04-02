select 
percent_complete,
[status],
start_time,
convert(varchar,(total_elapsed_time/(1000))/60) + 'M ' + convert(varchar,(total_elapsed_time/(1000))%60) + 'S' AS [Elapsed],
convert(varchar,(estimated_completion_time/(1000))/60) + 'M ' + convert(varchar,(estimated_completion_time/(1000))%60) + 'S' as [ETA],
command,
[sql_handle],
database_id,
connection_id,
blocking_session_id
from  sys.dm_exec_requests
where estimated_completion_time > 1
order by total_elapsed_time desc


sp_who2


select  T.text, R.Status, R.Command, DatabaseName = db_name(R.database_id)
        , R.cpu_time, R.total_elapsed_time, R.percent_complete
from    sys.dm_exec_requests R
        cross apply sys.dm_exec_sql_text(R.sql_handle) T
