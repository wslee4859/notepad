select * from [WF].[WF_FORMS] where form_name like '%����ó��%'

Y198E9EBCFF514411B8A52C6ED3E9C101	1893	����ó���ϷẸ��(����/����)	LIQUOR_ITSM_CSR_02
Y45EC6F988EE34F1E8FEF24E95BDA8BB1	748	����ó���ϷẸ��	LIQUOR_CSR_REPORT	LIQUOR_CSR_REPORT

���� 
YFFAADA0F80644A9F90CF194B70D12C72
�ַ� 
ITSM - Y198E9EBCFF514411B8A52C6ED3E9C101
�Ϲ� - Y45EC6F988EE34F1E8FEF24E95BDA8BB1 
��� - Y4C2B0F81C37042208451BBF370198189

select * from [WF].[FORM_YFFAADA0F80644A9F90CF194B70D12C72]
order by suggestdate 


select * from [WF].[PROCESS_INSTANCE] where form_id = 'Y45EC6F988EE34F1E8FEF24E95BDA8BB1'  AND state in ('7', '1')
order by create_date


select state, subject, creator_dept, creator, create_date, completed_date from [WF].[PROCESS_INSTANCE] where form_id = 'Y45EC6F988EE34F1E8FEF24E95BDA8BB1'  AND state in ('7', '1')
order by create_date
