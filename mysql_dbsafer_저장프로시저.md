### MY SQL 변수명으로 디비, 테이블 명 받아서 멀티로 데이터 조회 후 output

```sql
DROP PROCEDURE IF EXISTS `sp_datalake_table_select_v2`;
CREATE PROCEDURE `sp_datalake_table_select_v2`(
in vdataBase varchar(50),
in vtableName varchar(50),
in vtableQuery varchar(50)
)
begin	
	# 변수 선언
	DECLARE TemptableNm varchar(100); 	
	DECLARE var1 CHAR(50);
	DECLARE done TINYINT DEFAULT FALSE;
	#테이블 항목들을 가져와서 커서화 
	DECLARE cursor1 CURSOR FOR
 		select TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = vdataBase AND table_name like vtableQuery ;
 	DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
 	
 	#임시 테이블 생성 select 한것들을 하나로 합치기 위해 
	DROP TEMPORARY TABLE IF EXISTS temp_tbl;
 	SET TemptableNm = CONCAT(vdatabase,'.',vtableName) ;
	SET @SQL = CONCAT('CREATE TEMPORARY TABLE IF NOT EXISTS temp_tbl (LIKE ',vdataBase,'.',vtableName,');');
	PREPARE stmt FROM @SQL;
	EXECUTE stmt;
	DEALLOCATE PREPARE stmt;
	DROP INDEX `PRIMARY` ON temp_tbl;
	 OPEN cursor1;
	 my_loop: 
	 LOOP
	 FETCH cursor1 INTO var1;
	  IF done THEN
	   LEAVE my_loop;
	  ELSE
	   SET @SQL = CONCAT('insert into temp_tbl select * from ',vdataBase,'.',var1,';');	    
	   PREPARE stmt FROM @SQL;
	   EXECUTE stmt;
	   DEALLOCATE PREPARE stmt;
	  END IF;
	 END LOOP;
	CLOSE cursor1;
	#string encording 변환을 위해 별도로 select 가 필요 만약 별도 인코딩필요없음 걍 * 으로 select 	
	IF vtableName = 'db_user_01' THEN
		SELECT 
			`index`
			,id
			,clt_ip
			,clt_port
			,private_ip
			,application
			,com_name
			,net_id
			,os
			,com_id
			,sid
			,in_time
			,out_time
			,service_no
			,server_ip
			,server_port
			,policy_no
			,convert(cast(policy_name as BINARY) using euckr) as policy_name
			,manual_auth_id
			,manual_auth_name
			,denied
			,operating_mode
			#,conn_mode
			,alert
			,decide_type
			,decide_time
			,decide_mgr_id
			,loglevel
			,ldap_sno
			,ldap_name
			,convert(cast(ldap_tel as BINARY) using euckr) as ldap_tel
			,gateway
			,svc_type
			,group_index
			,dbsafer_name
			,cmd_count
		FROM temp_tbl;
	ELSEIF vtableName = 'shell_user_01' THEN
		select 
			`index`
			,id
			,user_ip
			,user_port
			,private_ip
			,in_time
			,out_time
			,service_no
			,server_ip
			,server_port
			,policy_no
			,convert(cast(policy_name as BINARY) using euckr) as policy_name
			,manual_auth_id
			,manual_auth_name
			,denied
			,operating_mode
			,conn_mode
			,alert
			,loglevel
			,decide_type
			,decide_time
			,decide_mgr_id
			,ldap_sno
			,ldap_name
			,convert(cast(ldap_tel as BINARY) using euckr) as ldap_tel
			,gateway
			,dbsafer_name
			,cmd_count
		from temp_tbl;		
	ELSE
		select * from temp_tbl;
	END IF;
END

```

```
`call sp_datalake_table_select_v2 ('dbsafer_log_2021_06','db_user_01','db_user___');`
```

