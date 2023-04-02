select	ROW_NUMBER() Over (Order By document_grade asc, document_point desc) As RowNumber  \r\n");
                    ,		    b.company   \r\n");
                    ,		    b.document_key		    \r\n");
                    ,		    document_subject    \r\n");
                    ,		    document_typecd   \r\n");
                    ,		    document_deptnm    \r\n");
                    ,		    document_workerno   \r\n");
                    ,		    user_nm as document_workernm    \r\n");
                    ,		    document_gradenm    \r\n");
                    ,		    document_read   \r\n");
                    ,		    document_good     \r\n"); 
                    ,		    document_writedate    \r\n"); 
                    from	    INOC_DOCUMENT_MASTER_TBL b    \r\n");
                    left     outer    join INOC_USER_TBL c  on   b.company = c.company    \r\n");
                                                  and	 b.document_workerno = c.user_no    \r\n");
                    left     outer    join INOC_DEPT_TBL d  on   b.company = d.company    \r\n");
                                                  and	 b.document_deptcd = d.dept_code    \r\n");
                    where    b.company = '" + company + "'    \r\n");
                    and      b.document_evaluatestep = 'E'    \r\n");
                    and      b.document_choicetype = 'O'      \r\n");
                    and      document_grade <=   (select  code_type2                    \r\n");
				    					            from	INOC_ADMIN_CODE_TBL           \r\n");
                    								where   company = b.company           \r\n");
                    					            and     code_highcd = '5AA43C56'      \r\n");
				    					            and     code_name = b.document_typecd)              \r\n");


select document_grade from [dbo].[INOC_DOCUMENT_MASTER_TBL] where document_key = 'I20160300327'