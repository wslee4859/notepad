USE [EWF]
GO
/****** Object:  StoredProcedure [WF].[USP_Slip_List_Insert_Xml]    Script Date: 2018-02-13 ���� 9:53:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

----------------------------------------------------------------------              
----------------------------------------------------------------------              
-- �ۼ���: ����[WIZEN]            
-- �ۼ���: 2017.12.19          
-- ������:               
-- ��   ��: SAP����Ʈ Insert           
--�׽�Ʈ:               
/*          
*/          
ALTER proc [WF].[USP_Slip_List_Insert_Xml]              
 /* Param List */          
 @pid   char(33)          
 ,@systemid  varchar(20)                 
 ,@SlipListXML  nvarchar(max)                 
AS              
              
set nocount on;              
             
DECLARE               
 @intDoc    INT               
              
EXEC sp_xml_preparedocument @intDoc OUTPUT, @SlipListXML          
          
insert into WF.WF_SLIP_LIST(          
PROCESS_INSTANCE_OID,          
SYSTEMID,          
BELNR,              
BUDAT,              
BLART,              
BKTXT,              
BLTXT,              
BSTXT,              
SRBTR,          
FWBAS,            
MWSTS,            
DSC_AFT_BIL_AM,            
MWSKZ,           
ZTEXT0,           
ZTEXT,            
POST1,     
BLDAT,  
CPUDT,             
MC_NM,              
MC_BZ_CL_NM,        
MC_CST_ID,    
FLAG,        
FORMALIAS,
KEYVALUE,      
FUNDSMANAGER,        
FUNDSMANAGERID,  
BUKRS,
LIFNR,
GSBER,
GTEXT,
ADD1,  
ADD2,  
ADD3,  
ADD4,  
ADD5  
)          
SELECT             
@pid,          
@systemid,          
BELNR,              
BUDAT,              
BLART,              
BKTXT,              
BLTXT,              
BSTXT,              
REPLACE(CONVERT(VARCHAR,ISNULL(SRBTR,0),1),'.00','') as SRBTR,          
REPLACE(CONVERT(VARCHAR,ISNULL(FWBAS,0),1),'.00','') as FWBAS,            
REPLACE(CONVERT(VARCHAR,ISNULL(MWSTS,0),1),'.00','') as MWSTS,            
REPLACE(CONVERT(VARCHAR,ISNULL(DSC_AFT_BIL_AM,0),1),'.00','') as DSC_AFT_BIL_AM,            
MWSKZ,           
ZTEXT0,           
ZTEXT,           
POST1,     
BLDAT,  
CPUDT,             
MC_NM,              
MC_BZ_CL_NM,        
MC_CST_ID,          
isnull(FLAG,'N') as FLAG,      
FORMALIAS,
KEYVALUE,      
FUNDSMANAGER,        
FUNDSMANAGERID,  
SUBSTRING(KEYVALUE,2,4) as BUKRS,
LIFNR,
GSBER,
GTEXT,
ADD1,  
ADD2,  
ADD3,  
ADD4,  
ADD5        
 FROM OPENXML (@intDoc,'SLIP_LIST',  2)              
 WITH               
  (  
   BELNR   char(10),              
   BUDAT   char(10),              
   BLART  char(2),              
   BKTXT  nvarchar(20),              
   BLTXT   nvarchar(100),              
   BSTXT   nvarchar(30),              
   SRBTR   money,              
   FWBAS   money,              
   MWSTS   money,              
   DSC_AFT_BIL_AM   money,              
   MWSKZ   varchar(4),           
   ZTEXT0   nvarchar(100),           
   ZTEXT   nvarchar(100),              
   POST1   nvarchar(30),   
   BLDAT   char(10),  
   CPUDT   char(10),             
   MC_NM  nvarchar(50),              
   MC_BZ_CL_NM  nvarchar(50),        
   MC_CST_ID varchar(30),  
   FLAG    char(1),    
   FORMALIAS    varchar(30),        
   KEYVALUE    varchar(2000),        
   FUNDSMANAGER nvarchar(50),        
   FUNDSMANAGERID varchar(30),  
   LIFNR nvarchar(50),
   GSBER char(4),
   GTEXT nvarchar(50),
   ADD1 varchar(10),  
   ADD2 varchar(10),  
   ADD3 varchar(10),  
   ADD4 varchar(10),  
   ADD5 varchar(10)  
  )              
              
EXEC sp_xml_removedocument @intDoc 






USE [EWF]
GO
/****** Object:  StoredProcedure [WF].[USP_SlipApprovalList__Total_Search_Select]    Script Date: 2018-02-13 ���� 10:16:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO        
                
-- =============================================                          
-- Author:  ����                          
-- Create date: 2018-01-15          
-- Description: ��ǥ ��ü��� �˻�                          
/*                          
 exec WF.USP_SlipApprovalList__Total_Search_Select @form_id='',@subject=N'',@create_dept=N'',@orderby_column='CREATE_DATE',@orderby_state=0,@start_date=N'',@end_date=N''             
            
 exec [WF].[USP_SlipApprovalList__Total_Search_Select] @form_id='',@orderby_column='CREATE_DATE',@orderby_state=0,@start_date=N'',@end_date=N'', @scdate='',@scmoney='', @frmoney='',@tomoney='', @sc1='', @sv1='', @sc2 ='', @sv2=''          
*/                          
-- =============================================                          
ALTER PROCEDURE [WF].[USP_SlipApprovalList__Total_Search_Select]                      
 @sitecode varchar(20), -- ����Ʈ�ڵ�        
 @form_id varchar(33), -- ��ǥ����(�˻�)                           
 @orderby_column varchar(50), -- �����÷�                          
 @orderby_state bit,   -- ���Ĺ��                            
 @scdate   varchar(20), -- �˻���¥����                      
 @start_date nvarchar(10), -- �˻�������                            
 @end_date nvarchar(10), -- �˻�������                           
 @scmoney   varchar(20), -- �˻��ݾ�                      
 @frmoney money, -- �˻��ݾ�From                      
 @tomoney money, -- �˻��ݾ�To                      
 @sc1 varchar(30), -- �˻��ʵ�1                      
 @sv1 nvarchar(100), -- �˻�Text1                      
 @sc2 varchar(30), -- �˻��ʵ�1                      
 @sv2 nvarchar(100) -- �˻�Text1                             
AS                          
BEGIN                          
                           
 --set nocount on;                            
 --set transaction isolation level read uncommitted;                              
                            
 declare @sql nvarchar(4000),                                 
 @where nvarchar(1000),                            
 @orderby nvarchar(100)                            
                 
 -- ����                            
if @orderby_column <> ''                            
begin                            
 if UPPER(@orderby_column) = 'DOC_NAME' begin set @orderby_column = 'NAME' end           
 if UPPER(@orderby_column) = 'CREATE_DATE' begin set @orderby_column = 'A.CREATE_DATE' end                              
 if @orderby_state  = 0                            
 begin          
  set @orderby = @orderby_column + N' desc '                            
 end          
 else                            
 begin          
  set @orderby = @orderby_column + N' asc '                            
 end                         
end             
else          
begin                            
 set  @orderby = N' A.CREATE_DATE desc '          
end          


if(@orderby_column = 'FLAG')
begin
	if (@orderby_state  = 0)
	begin
		set @orderby = N' FLAG desc,FUNDSMANAGER desc  '         
	end
	else
	begin
		set @orderby = N' FLAG asc,FUNDSMANAGER asc  '         
	end
end
          
       
 --����Ʈ�ڵ� ����      
 if(@sitecode = 'SITE01')      
 begin      
 set @where = N' where systemid=''BFSAP'' and PROOF_USE_YN=''Y'' and A.STATE in (1,7) '      
 end      
 else      
 begin      
 set @where = N' where systemid=''LFSAP'' and PROOF_USE_YN=''Y'' and A.STATE in (1,7) '      
 end            
                           
 -- �˻�� ���� ó���� �Ѵ�.                            
 if (@form_id <> '')                          
 begin                     
  if(@where is null)          
  begin          
 set @where = N' where '           
  end    
  else    
  begin    
 set @where = @where + N' and '           
  end          
                 
  set @where = @where + N' A.FORM_ID = @form_id '                            
 end                          
                
                 
--��¥Ÿ�� �˻�����( BLDAT:������ CPUDT:��ǥ�Է���, CREATE_DATE:�����                   
   if (@scdate <> '')          
   begin          
  if(@where is null)          
  begin          
   set @where = N' where '           
  end          
  else          
  begin          
   set @where = @where +  N' and '           
  end          
          
  if(@scdate = 'CREATE_DATE')  -- �߰� �̿ϻ�          
  begin          
  set @scdate = 'a.create_date'          
  end          
          
  if(@start_date <> '' and @end_date <> '')                      
  begin                      
   set @where = @where + @scdate + N'  between ''' + @start_date + ''' and ''' + @end_date + ''' '                      
  end        
  else if(@start_date = '' and @end_date <> '')                      
  begin                      
   set @where = @where + @scdate + N' <= ''' + @end_date + ''' '                    
  end                      
  else if(@start_date <> '' and @end_date = '')                      
 begin                      
   set @where = @where  + @scdate + N' >= ''' + @start_date + ''' '                      
  end                      
 end                          
                       
            
 --��¥Ÿ�� �˻�����                         
                  
 --�ݾ�Ÿ�� �˻�����                      
 if (@scmoney <> '' and (@frmoney <> '' or @tomoney <> ''))                        
 begin                          
  if(@where is null)          
 begin          
  set @where = N' where '           
 end          
 else          
 begin          
  set @where = @where +  N' and '           
 end          
                     
  if(@frmoney <> '' and @tomoney <> '')                      
  begin                      
 set @where = @where + @scmoney + N' between @frmoney and @tomoney '                      
  end                      
  else if(@frmoney = '' and @tomoney <> '')                      
  begin                      
 set @where = @where + @scmoney + N' <= @tomoney '                      
  end                      
  else if(@frmoney <> '' and @tomoney = '')                      
  begin                      
 set @where = @where + @scmoney + N' >= @frmoney '                      
  end                      
 end                          
 --�ݾ�Ÿ�� �˻�����                      
                       
 --�˻�TEXT1 ����                      
if (@sc1 <> '' and @sv1 <> '')                         
begin                 
          
 if(@where is null)          
 begin          
  set @where = N' where '           
 end          
 else          
 begin          
 set @where = @where +  N' and '           
 end                   
          
 set @sv1 =  N'%'+ @sv1 +N'%';                             
 set @where = @where + @sc1 + N' like @sv1 '                            
end                          
 --�˻�TEXT1 ����                      
                       
 --�˻�TEXT2 ����                      
if (@sc2 <> '' and @sv2 <> '')                          
begin                 
          
 if(@where is null)          
 begin          
  set @where = N' where '           
 end          
 else          
 begin          
 set @where = @where +  N' and '           
 end                         
 set @sv2 =  N'%'+ @sv2 +N'%';                             
 set @where = @where + @sc2 + N' like @sv2 '                            
end                          
--�˻�TEXT2 ����                      
                   
                         
 if @where is null                              
  set @where = N''                                
           
                         
 set @sql = N'                            
 WITH WorkItemContact AS                          
 (                          
 SELECT                          
  EXIST_ISURGENT,                          
  UPPER(ATTACH_EXTENSION) as ATTACH_EXTENSION,                          
  EXIST_COMMENT,                          
  EXIST_REF_DOCUMENT,                          
  NAME as DOC_NAME,                          
  [SUBJECT],                          
  CREATOR,                          
  CREATOR_DEPT,                          
  EXIST_ATTACH,                          
  CREATOR_ID,                          
  PARENT_OID,                          
  a.FORM_ID,                          
  CURRENT_USER_NAME,                          
  CURRENT_DEPT_NAME,                          
  CURRENT_LEVEL,                          
  a.CREATE_DATE as CREATE_DATE,                
  A.COMPLETED_DATE as COMPLETED_DATE,                                  
  A.OID as PROCESS_INSTANCE_OID,                          
  ROW_NUMBER() OVER ( ORDER BY '+ @orderby + N') AS RowNum,                           
  COUNT(*) OVER ( ) AS [RowCount],                      
  DOC_NUMBER=DOC_NAME                     
  ,BUDAT                  
,BELNR                  
,ZTEXT0                  
,BKTXT                  
,REPLACE(CONVERT(VARCHAR,ISNULL(FWBAS,0),1),''.00'','''') as FWBAS                   
,REPLACE(CONVERT(VARCHAR,ISNULL(MWSTS,0),1),''.00'','''') as MWSTS                  
,REPLACE(CONVERT(VARCHAR,ISNULL(SRBTR,0),1),''.00'','''') as SRBTR                   
,MWSKZ                    
,EVS_CNT                  
,BLART                  
,ZTEXT                  
,POST1                  
,BSTXT                  
,CPUDT                  
,MC_BZ_CL_NM                  
,MC_NM                  
,MC_CST_ID                  
,KEYVALUE              
,BLDAT          
,SYSTEMID    
,FLAG    
, isnull(FUNDSMANAGER, '''') as FUNDSMANAGER    
, isnull(FUNDSMANAGERID, '''') as FUNDSMANAGERID     
, isnull(BUKRS,'''') as  BUKRS      
, isnull(LIFNR,'''') as  LIFNR   
, isnull(GSBER,'''') as  GSBER   
, isnull(GTEXT,'''') as  GTEXT             
 FROM WF.UV_PROCESS_INSTANCE_SLIP A   
 inner join WF.WF_FORM_SCHEMA b  
 on a.form_id = b.form_id                    
  left outer join WF.WF_DOC_NUMBER c                        
  on A.PROCESS_INSTANCE_OID = c.PROCESS_ID'                          
   + @where + '                          
    )                                
 SELECT *, COOPERATION_YN='''', BUNDLE_APPROVAL_YN=''''                          
 FROM WorkItemContact '                                 
                               
print @sql          
 exec sp_executesql @sql, N' @form_id varchar(33), @frmoney money, @tomoney money, @sv1 nvarchar(100), @sv2 nvarchar(100) '                
 , @form_id, @frmoney, @tomoney,  @sv1, @sv2                              
                                  
end   




USE [EWF]
GO
/****** Object:  StoredProcedure [WF].[USP_SlipApprovalList_Approval_Select]    Script Date: 2018-02-13 ���� 10:22:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

              
/*                  
-------------------------------------------------------------------------------------                  
-- �ۼ��� : ����[WIZEN]                
-- �ۼ��� : 2018-01-08                 
-- �ϴ��� : ��ǥ�������� ������ ����Ʈ�� �����´�.                  
-- ��  �� :                   
                  
 ������ - state = 2, view_state = 3,                 
 ������ - state = 7, view_state = 3                  
                   
-- ��  �� :   EXEC [WF].[USP_SlipApprovalList_Approval_Select] '32088',2,3,'CA',1,20,'','','','',0,'',''                
-------------------------------------------------------------------------------------                  
*/                  
ALTER proc [WF].[USP_SlipApprovalList_Approval_Select]                
@user_id nvarchar(50), -- �����ID or �μ�ID                  
@state tinyint, -- ��������                  
@view_state tinyint,                    
@folder_type varchar(2) = '',                  
@current_page int,   -- ���� ��ȸ�ϰ��� �ϴ� ������                  
@row_page int,   -- �������� ���� ����Ʈ�� ��                  
@form_id varchar(33), -- ��ǥ����(�˻�)                   
@orderby_column varchar(50), -- ���ĵ� �÷���                  
@orderby_state bit,   -- ��������            
@scdate   varchar(20), -- �˻���¥����            
@start_date nvarchar(10), -- �˻�������                  
@end_date nvarchar(10), -- �˻�������                 
@scmoney   varchar(20), -- �˻��ݾ�            
@frmoney money, -- �˻��ݾ�From            
@tomoney money, -- �˻��ݾ�To            
@sc1 varchar(30), -- �˻��ʵ�1            
@sv1 nvarchar(100), -- �˻�Text1            
@sc2 varchar(30), -- �˻��ʵ�1            
@sv2 nvarchar(100) -- �˻�Text1            
AS                  
                  
 set nocount on;                  
 set transaction isolation level read uncommitted;                    
                  
 declare @sql nvarchar(max),                       
 @where nvarchar(2000),                  
 @orderby nvarchar(2000)                
                
 -- ������ ��ϼ��� ���� ó���� �Ѵ�.                    
 declare @start_row int, @end_row int                  
 set @start_row = @row_page * (@current_page-1) + 1;                  
 set @end_row = @row_page * (@current_page);                  
                
                  
 -- ����                  
 if @orderby_column <> ''                  
 begin                  
  if UPPER(@orderby_column) = 'DOC_NAME' begin set @orderby_column = 'NAME' end                    
                    
  set @orderby = case UPPER(@orderby_column) when 'CREATE_DATE' then N'b.'+ @orderby_column                 
        when 'CURRENT_LEVEL' then ' ( CONVERT(float,SUBSTRING(CURRENT_LEVEL,0,CHARINDEX(''/'',CURRENT_LEVEL)) )  / CONVERT(float, SUBSTRING(CURRENT_LEVEL, CHARINDEX(''/'',CURRENT_LEVEL) +1, LEN(CURRENT_LEVEL) - CHARINDEX(''/'',CURRENT_LEVEL) ) ) ) '      
  
    
      
        
          
        else  @orderby_column end                  
  if @orderby_state  = 0                  
   set @orderby = @orderby + N' desc '                  
  else                  
   set @orderby = @orderby + N' asc '                  
    end                  
 else                  
  set  @orderby = N' a.CREATE_DATE desc '             
              

if(@orderby_column = 'FLAG')
begin
	if (@orderby_state  = 0)
	begin
		set @orderby = N' FLAG desc,FUNDSMANAGER desc  '         
	end
	else
	begin
		set @orderby = N' FLAG asc,FUNDSMANAGER asc  '         
	end
end

            
 -- ������� �˻�����              
 if (@form_id <> '')                
 begin                
  if(@where is null)                
  begin                
   set @where = N' where FORM_ID = @form_id ';                 
  end              
  else                 
  begin                 
   set @where =  N' and FORM_ID = @form_id '                  
  end                
 end              
 -- ������� �˻�����            
            
 --��¥Ÿ�� �˻�����( BLDAT:������ CPUDT:��ǥ�Է���, CREATE_DATE:�����         
 if (@scdate <> '' and (@start_date <> '' or @end_date <> ''))                
 begin           
  if(@where is null)             
  begin            
 set @where = N' where '            
  end            
  else            
  begin            
 set @where = @where + N' and '            
  end               
            
  if(@scdate = 'CREATE_DATE')       
  begin          
 set @scdate = N'A.CREATE_DATE'          
  end          
               
  if(@start_date <> '' and @end_date <> '')            
  begin            
 set @where = @where + @scdate + N'  between ''' + @start_date + ''' and ''' + @end_date + ''' '            
  end            
  else if(@start_date = '' and @end_date <> '')            
  begin            
 set @where = @where + @scdate + N' <= ''' + @end_date + ''' '          
  end            
  else if(@start_date <> '' and @end_date = '')            
  begin            
 set @where = @where + @scdate + N' >= ''' + @start_date + ''' '            
  end            
 end                
 --��¥Ÿ�� �˻�����               
        
 --�ݾ�Ÿ�� �˻�����            
 if (@scmoney <> '' and (@frmoney <> '' or @tomoney <> ''))                
 begin                
  if(@where is null)             
  begin            
 set @where = N' where '            
  end            
  else            
  begin            
 set @where = @where + N' and '            
  end               
               
  if(@frmoney <> '' and @tomoney <> '')            
  begin            
 set @where = @where + @scmoney + N' between @frmoney and @tomoney '            
  end            
  else if(@frmoney = '' and @tomoney <> '')            
  begin            
 set @where = @where + @scmoney + N' <= @tomoney '            
  end            
  else if(@frmoney <> '' and @tomoney = '')            
  begin            
 set @where = @where + @scmoney + N' >= @frmoney '            
  end            
 end                
 --�ݾ�Ÿ�� �˻�����            
             
 --�˻�TEXT1 ����            
if (@sc1 <> '' and @sv1 <> '')               
begin                
 if(@where is null)             
 begin                
  set @where = N' where ';                 
 end                
 else                
 begin                
  set @where = @where + N' and ';                 
 end                
            
 set @sv1 =  N'%'+ @sv1 +N'%';                   
 set @where = @where + @sc1 + N' like @sv1 '                  
end                
 --�˻�TEXT1 ����            
             
 --�˻�TEXT2 ����            
if (@sc2 <> '' and @sv2 <> '')                
begin                
 if(@where is null)             
 begin                
  set @where = N' where ';                 
 end                
 else                
 begin                
  set @where = @where + N' and ';                 
 end                
            
 set @sv2 =  N'%'+ @sv2 +N'%';                   
 set @where = @where + @sc2 + N' like @sv2 '                  
end                
--�˻�TEXT2 ����            
          
          
                     
if (@state = 7 and @folder_type = 'CR')                
begin                  
 if(@where is null)                 
  set @where = N' where '                  
 else                    
  set @where = @where + N' AND '                  
                      
 set @where = @where + N'  a.PARENT_OID is not null '                  
end                     
            
--������ ����            
if(@folder_type = 'CB') --��ǥ������(�켱)            
begin            
 if(@where is null)            
 begin            
  set @where = N' where '            
 end            
 else            
 begin            
  set @where = @where + N' and '            
 end            
            
 set @where = @where +  'EXIST_ISURGENT=''Y'' ';            
end            
else if(@folder_type = 'CA')  --��ǥ������(�Ϲ�)               
begin            
 if(@where is null)            
 begin            
  set @where = N' where '            
 end            
 else            
 begin            
  set @where = @where + N' and '            
 end            
            
set @where = @where +  'EXIST_ISURGENT=''N'' ';            
end            
          
 print @where          
            
 if @where is null                   
  set @where = N''                  
                    
 set @sql = N'                  
    With WorkItemContact As                  
    (                  
     select                   
     EXIST_ISURGENT,                  
     ATTACH_EXTENSION,                     
     EXIST_COMMENT,                     
     EXIST_REF_DOCUMENT,                  
     NAME as DOC_NAME,                  
     [SUBJECT],                  
     CREATOR,                  
     CREATOR_DEPT,                  
     EXIST_ATTACH,                  
     CREATOR_ID,                  
     PARENT_OID,                  
     FORM_ID,                  
     CURRENT_USER_NAME,                  
     CURRENT_DEPT_NAME,                  
     CURRENT_LEVEL,                     CASE a.STATE WHEN ''5'' THEN ''HOLD'' ELSE b.LOCATION END as LOCATION,          
  A.CREATE_DATE,               
 b.CREATE_DATE as RECEIVE_DATE,                 
 b.OPEN_YN,                 
 b.WORK_ITEM_OID,                 
 b.PROCESS_INSTANCE_OID,                 
 b.WKITEM_ID        
 , ROW_NUMBER() OVER ( ORDER BY '+ @orderby + N') AS RowNum        
 , COUNT(*) OVER ( ) AS [RowCount]        
 ,BUDAT        
,BELNR        
,ZTEXT0        
,BKTXT        
,REPLACE(CONVERT(VARCHAR,ISNULL(FWBAS,0),1),''.00'','''') as FWBAS         
,REPLACE(CONVERT(VARCHAR,ISNULL(MWSTS,0),1),''.00'','''') as MWSTS        
,REPLACE(CONVERT(VARCHAR,ISNULL(SRBTR,0),1),''.00'','''') as SRBTR         
,MWSKZ          
,EVS_CNT        
,BLART        
,ZTEXT        
,POST1        
,BSTXT        
,CPUDT        
,MC_BZ_CL_NM        
,MC_NM        
,MC_CST_ID                
,KEYVALUE    
,BLDAT        
,FLAG    
, isnull(FUNDSMANAGER, '''') as FUNDSMANAGER    
, isnull(FUNDSMANAGERID, '''') as FUNDSMANAGERID     
, isnull(BUKRS,'''') as  BUKRS      
, isnull(LIFNR,'''') as  LIFNR   
, isnull(GSBER,'''') as  GSBER   
, isnull(GTEXT,'''') as  GTEXT              
from WF.UV_PROCESS_INSTANCE_SLIP a                  
      inner join                   
      (                  
       select                   
       LOCATION, CREATE_DATE, OPEN_YN, OID WORK_ITEM_OID, PROCESS_INSTANCE_OID, WKITEM_ID                  
       from WF.WORK_ITEM                   
       where PARTICIPANT_ID=@user_id  AND [STATE] = @state AND  PROCESS_INSTANCE_VIEW_STATE = @view_state and DELETE_DATE is null                  
      ) b                  
      on A.OID = b.PROCESS_INSTANCE_OID '+ @where + N'                  
    )                      
    select w.* '                     
                     
 if @folder_type = 'CR'  --��ǥ������                
 begin                  
  set @sql = @sql + N', COOPERATION_YN, BUNDLE_APPROVAL_YN                
  from WorkItemContact w                  
  inner join WF.WF_FORM_SCHEMA s                   
  on w.form_id = s.form_id                   
  where RowNum between @start_row and @end_row'                
                
  set @user_id = @user_id + '_R'                
 end                  
 else                   
 begin                  
  set @sql = @sql + N', COOPERATION_YN='''', BUNDLE_APPROVAL_YN=''''                
  from WorkItemContact w where RowNum between @start_row and @end_row'                     
 end                  
         
 exec sp_executesql @sql, N'@user_id nvarchar(50), @state tinyint, @view_state tinyint, @start_row int, @end_row int, @form_id varchar(33)            
 , @frmoney money, @tomoney money, @sv1 nvarchar(100), @sv2 nvarchar(100)'            
 , @user_id, @state, @view_state, @start_row, @end_row, @form_id, @frmoney, @tomoney,  @sv1, @sv2             
                
                
 print @sql       




 USE [EWF]
GO
/****** Object:  StoredProcedure [WF].[USP_SlipApprovalList_BackRow_Select]    Script Date: 2018-02-13 ���� 10:23:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
  
  
    
      
ALTER proc [WF].[USP_SlipApprovalList_BackRow_Select]          
@user_id nvarchar(50),  -- �����ID          
@current_page int,   -- ���� ��ȸ�ϰ��� �ϴ� ������          
@row_page int,   -- �������� ���� ����Ʈ�� ��          
@form_id varchar(33), -- ��ǥ����(�˻�)         
@orderby_column varchar(50), -- �����÷�            
 @orderby_state bit,   -- ���Ĺ��              
 @scdate   varchar(20), -- �˻���¥����            
@start_date nvarchar(10), -- �˻�������                  
@end_date nvarchar(10), -- �˻�������                 
@scmoney   varchar(20), -- �˻��ݾ�            
@frmoney money, -- �˻��ݾ�From            
@tomoney money, -- �˻��ݾ�To            
@sc1 varchar(30), -- �˻��ʵ�1            
@sv1 nvarchar(100), -- �˻�Text1            
@sc2 varchar(30), -- �˻��ʵ�1            
@sv2 nvarchar(100) -- �˻�Text1            
AS          
          
/*          
-------------------------------------------------------------------------------------          
-- �ۼ��� : ����          
-- �ۼ��� : 2017.12.12        
-- ��  �� : ��ǥ �Ŀ�/�İ����� ����Ʈ�� �����´�.           
-- ��  �� :           
 EXEC WF.[USP_SlipApprovalList_BackRow_Select]   '32088', 1, 15, '', '', '', '', 0, '', ''        
-------------------------------------------------------------------------------------          
*/          
 set nocount on;          
 set transaction isolation level read uncommitted;            
          
 declare @sql nvarchar(4000), @where nvarchar(1000), @orderby nvarchar(100)          
          
 /* ������ ��ϼ��� ���� ó���� �Ѵ�. */          
 declare @start_row int, @end_row int          
 set @start_row = @row_page * (@current_page-1) + 1;          
 set @end_row = @row_page * (@current_page);          
          
   /* ���� */          
   if @orderby_column <> ''          
   begin             
  set @orderby = case UPPER(@orderby_column)       
 when 'COMPLETED_DATE' then N'b.COMPLETED_DATE'          
   when 'CREATE_DATE' then N'A.CREATE_DATE'         
   when 'DOC_NAME' then N'a.NAME'          
   when 'BACKROW_USER_NAME' then N'ABSENCE_USER_NAME'          
   when 'BACKROW_DEPT_NAME' then N'ABSENCE_DEPT_NAME'          
   when 'DOC_NAME' then N'a.NAME'          
   else  @orderby_column end          
     if @orderby_state  = 0          
  set @orderby = @orderby + N' desc '          
  else          
  set @orderby = @orderby + N' asc '          
  end          
  else          
 set  @orderby = N' b.COMPLETED_DATE desc '      
 
 
if(@orderby_column = 'FLAG')
begin
	if (@orderby_state  = 0)
	begin
		set @orderby = N' FLAG desc,FUNDSMANAGER desc  '         
	end
	else
	begin
		set @orderby = N' FLAG asc,FUNDSMANAGER asc  '         
	end
end    
          
  /* ����ڿ� ���� ������ ó���� �Ѵ�. */          
  set @where = N' where b.[USER_ID] = @user_id AND (A.[STATE] = 1 OR A.[STATE] = 7 ) AND ( b.SIGN_STATE = ''31'' OR b.SIGN_STATE = ''33'' ) '          
            
  -- �˻�� ���� ó���� �Ѵ�.          
 if (@form_id <> '')        
 begin        
  set @where = @where + N' and FORM_ID = @form_id '          
 end        
        
--��¥Ÿ�� �˻�����( BLDAT:������ CPUDT:��ǥ�Է���, CREATE_DATE:�����         
 if (@scdate <> '' and (@start_date <> '' or @end_date <> ''))                
 begin           
  if(@scdate = 'CREATE_DATE')          
  begin          
 set @scdate = N'A.CREATE_DATE'          
  end          
               
  if(@start_date <> '' and @end_date <> '')            
  begin            
 set @where = @where + N' and ' + @scdate + N'  between ''' + @start_date + ''' and ''' + @end_date + ''' '            
  end            
  else if(@start_date = '' and @end_date <> '')            
  begin            
 set @where = @where + N' and '+ @scdate + N' <= ''' + @end_date + ''' '          
  end            
  else if(@start_date <> '' and @end_date = '')            
  begin            
 set @where = @where + N' and ' + @scdate + N' >= ''' + @start_date + ''' '            
  end            
 end                
 --��¥Ÿ�� �˻�����               
        
 --�ݾ�Ÿ�� �˻�����            
 if (@scmoney <> '' and (@frmoney <> '' or @tomoney <> ''))                
 begin                
  set @where = @where + N' and '            
  if(@frmoney <> '' and @tomoney <> '')            
  begin            
 set @where = @where + @scmoney + N' between @frmoney and @tomoney '            
  end            
  else if(@frmoney = '' and @tomoney <> '')            
begin            
 set @where = @where + @scmoney + N' <= @tomoney '            
  end            
  else if(@frmoney <> '' and @tomoney = '')            
  begin            
 set @where = @where + @scmoney + N' >= @frmoney '            
  end            
 end                
 --�ݾ�Ÿ�� �˻�����            
             
 --�˻�TEXT1 ����            
if (@sc1 <> '' and @sv1 <> '')               
begin                
 set @where = @where + N' and ';                    
 set @sv1 =  N'%'+ @sv1 +N'%';                   
 set @where = @where + @sc1 + N' like @sv1 '                  
end                
 --�˻�TEXT1 ����            
             
 --�˻�TEXT2 ����            
if (@sc2 <> '' and @sv2 <> '')                
begin                
 set @where = @where + N' and ';                  
 set @sv2 =  N'%'+ @sv2 +N'%';                   
 set @where = @where + @sc2 + N' like @sv2 '                  
end                
--�˻�TEXT2 ����             
          
     set @sql = N'          
    With WorkItemContact As          
    (          
     select                
     EXIST_ISURGENT,          
     ATTACH_EXTENSION = UPPER(ATTACH_EXTENSION),          
     EXIST_COMMENT,             
     EXIST_REF_DOCUMENT,          
     [SIGN_STATE],          
     [STATE],          
     DOC_NAME = NAME,          
     [SUBJECT],          
     BACKROW_USER_NAME=ABSENCE_USER_NAME,          
     BACKROW_USER_ID=ABSENCE_USER_ID,          
     BACKROW_DEPT_NAME=ABSENCE_DEPT_NAME,        
             
     CURRENT_USER_NAME,          
     A.CREATE_DATE,          
     DOC_LEVEL,          
     EXIST_ATTACH,          
     CREATOR_ID,          
     A.PROCESS_INSTANCE_OID,          
     PARENT_OID,          
     FORM_ID,          
     CURRENT_LEVEL,          
     SIGN_OID,          
     PROCESS_KEY = SIGN_OID+''|''+SIGN_STATE,        
     ROW_NUMBER() OVER ( ORDER BY '+ @orderby + N') AS RowNum      
  , COUNT(*) OVER ( ) AS [RowCount]          
   ,BUDAT        
 ,BELNR        
 ,ZTEXT0        
 ,BKTXT        
 ,REPLACE(CONVERT(VARCHAR,ISNULL(FWBAS,0),1),''.00'','''') as FWBAS         
 ,REPLACE(CONVERT(VARCHAR,ISNULL(MWSTS,0),1),''.00'','''') as MWSTS        
 ,REPLACE(CONVERT(VARCHAR,ISNULL(SRBTR,0),1),''.00'','''') as SRBTR         
 ,MWSKZ          
 ,EVS_CNT        
 ,BLART        
 ,ZTEXT        
 ,POST1        
 ,BSTXT        
 ,CPUDT        
 ,MC_BZ_CL_NM        
 ,MC_NM        
 ,MC_CST_ID        
 ,KEYVALUE    
 ,BLDAT    
 ,b.COMPLETED_DATE          
 ,FLAG  
, isnull(FUNDSMANAGER, '''') as FUNDSMANAGER  
, isnull(FUNDSMANAGERID, '''') as FUNDSMANAGERID      
, isnull(BUKRS,'''') as  BUKRS  
, isnull(LIFNR,'''') as  LIFNR   
, isnull(GSBER,'''') as  GSBER   
, isnull(GTEXT,'''') as  GTEXT                   
     from WF.UV_PROCESS_INSTANCE_SLIP AS A        
     inner join WF.PROCESS_SIGNER AS B          
     on A.OID = B.PROCESS_INSTANCE_OID          
     '+ @where + N'                
    )              
    select *, OPEN_YN=''Y'', WORK_ITEM_OID='''', LOCATION=''''         
 from WorkItemContact          
     where RowNum between @start_row and @end_row                
   '          
             
   exec sp_executesql @sql, N'@user_id nvarchar(50), @start_date datetime, @end_date datetime, @start_row int, @end_row int, @form_id varchar(33)      
   ,@frmoney money, @tomoney money, @sv1 nvarchar(100), @sv2 nvarchar(100) '      
   , @user_id, @start_date, @end_date, @start_row, @end_row, @form_id, @frmoney, @tomoney,  @sv1, @sv2        
   print @sql          
        
 


USE [EWF]
GO
/****** Object:  StoredProcedure [WF].[USP_SlipApprovalList_Complete_Select]    Script Date: 2018-02-13 ���� 10:24:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
  
  
        
-- =============================================                  
-- Author:  ����                  
-- Create date: 2017-12-12                  
-- Description: ��ǥ�Ϸ��� ��� ��ȸ                  
/*                  
 exec WF.USP_SlipApprovalList_Approval_Select @user_id=N'32088',@state=2,@view_state=3,@folder_type=N'CA',@current_page=0,@row_page=0,@form_id='',@subject=N'',@create_dept=N'',@orderby_column='CREATE_DATE',@orderby_state=0,@start_date=N'',@end_date=N''   
             
*/                  
-- =============================================                  
ALTER PROCEDURE [WF].[USP_SlipApprovalList_Complete_Select]              
 @folder_type  varchar(2), -- ������Ÿ��                
 @user_id nvarchar(50), -- �����ID                  
 @dept_id nvarchar(50), -- �μ�ID                    
 @current_page int,   -- ��������ȣ                  
 @row_page int,   -- ����Ʈ����                   
 @form_id varchar(33), -- ��ǥ����(�˻�)                   
 @orderby_column varchar(50), -- �����÷�                  
 @orderby_state bit,   -- ���Ĺ��                    
 @scdate   varchar(20), -- �˻���¥����              
 @start_date nvarchar(10), -- �˻�������                    
 @end_date nvarchar(10), -- �˻�������                   
 @scmoney   varchar(20), -- �˻��ݾ�              
 @frmoney money, -- �˻��ݾ�From              
 @tomoney money, -- �˻��ݾ�To              
 @sc1 varchar(30), -- �˻��ʵ�1              
 @sv1 nvarchar(100), -- �˻�Text1              
 @sc2 varchar(30), -- �˻��ʵ�1              
 @sv2 nvarchar(100) -- �˻�Text1                     
AS                  
BEGIN                  
                   
 --set nocount on;                    
 --set transaction isolation level read uncommitted;                      
                    
 declare @sql nvarchar(4000),                         
 @where nvarchar(1000),                    
 @orderby nvarchar(100)                    
                    
 -- ������ ��ϼ��� ���� ó���� �Ѵ�.                      
 declare @start_row int, @end_row int                    
 set @start_row = @row_page * (@current_page-1) + 1;                    
 set @end_row = @row_page * (@current_page);                    
                    
 -- ����                    
    if @orderby_column <> ''                    
    begin                    
  if UPPER(@orderby_column) = 'DOC_NAME' begin set @orderby_column = 'NAME' end                      
  set @orderby = case UPPER(@orderby_column) when 'CREATE_DATE' then N'A.'+ @orderby_column when 'COMPLETED_DATE' then N'B.'+ @orderby_column else  @orderby_column end                    
  if @orderby_state  = 0                    
   set @orderby = @orderby + N' desc '                    
  else                    
   set @orderby = @orderby + N' asc '                    
 end                    
 else                    
  set  @orderby = N' b.COMPLETED_DATE desc '   
 
 
if(@orderby_column = 'FLAG')
begin
	if (@orderby_state  = 0)
	begin
		set @orderby = N' FLAG desc,FUNDSMANAGER desc  '         
	end
	else
	begin
		set @orderby = N' FLAG asc,FUNDSMANAGER asc  '         
	end
end                 
                      
 -- �����ID, �μ�ID�� ���� ó��                 
 if(@folder_type='CC')              
 begin              
 set @dept_id = @dept_id + N'_CC'                  
 set @where = N' WHERE b.DELETE_DATE IS NULL AND b.PARTICIPANT_ID = @dept_id '                  
 end              
 else              
 begin              
 set @user_id = @user_id + N'_CU'                  
 set @where = N' WHERE b.DELETE_DATE IS NULL AND b.PARTICIPANT_ID = @user_id '                  
 end              
              
              
               
                  
                   
 -- �˻�� ���� ó���� �Ѵ�.                    
 if (@form_id <> '')                  
 begin                  
  set @where = @where + N' and A.FORM_ID = @form_id '                    
 end                  
        
         
--��¥Ÿ�� �˻�����( BLDAT:������ CPUDT:��ǥ�Է���, CREATE_DATE:�����           
 if (@scdate <> '' and (@start_date <> '' or @end_date <> ''))                  
 begin             
  if(@scdate = 'CREATE_DATE')            
  begin            
   set @scdate = N'A.CREATE_DATE'            
  end            
  if(@scdate = 'COMPLETED_DATE')            
  begin            
   set @scdate = N'b.COMPLETED_DATE'            
  end            
        
                 
  if(@start_date <> '' and @end_date <> '')              
  begin              
 set @where = @where + N' and ' + @scdate + N'  between ''' + @start_date + ''' and ''' + @end_date + ''' '              
  end              
  else if(@start_date = '' and @end_date <> '')              
  begin              
 set @where = @where + N' and '+ @scdate + N' <= ''' + @end_date + ''' '            
  end              
  else if(@start_date <> '' and @end_date = '')              
  begin              
 set @where = @where + N' and ' + @scdate + N' >= ''' + @start_date + ''' '              
  end              
 end                  
 --��¥Ÿ�� �˻�����                 
          
 --�ݾ�Ÿ�� �˻�����              
 if (@scmoney <> '' and (@frmoney <> '' or @tomoney <> ''))                
 begin                  
  set @where = @where + N' and '              
  if(@frmoney <> '' and @tomoney <> '')              
  begin              
 set @where = @where + @scmoney + N' between @frmoney and @tomoney '              
  end              
  else if(@frmoney = '' and @tomoney <> '')              
  begin              
 set @where = @where + @scmoney + N' <= @tomoney '              
  end              
  else if(@frmoney <> '' and @tomoney = '')              
  begin              
 set @where = @where + @scmoney + N' >= @frmoney '              
  end              
 end                  
 --�ݾ�Ÿ�� �˻�����              
               
 --�˻�TEXT1 ����              
if (@sc1 <> '' and @sv1 <> '')                 
begin                  
 set @where = @where + N' and ';                      
 set @sv1 =  N'%'+ @sv1 +N'%';                     
 set @where = @where + @sc1 + N' like @sv1 '                    
end                  
 --�˻�TEXT1 ����              
               
 --�˻�TEXT2 ����              
if (@sc2 <> '' and @sv2 <> '')                  
begin                  
 set @where = @where + N' and ';                    
 set @sv2 =  N'%'+ @sv2 +N'%';                     
 set @where = @where + @sc2 + N' like @sv2 '                    
end                  
--�˻�TEXT2 ����              
           
                     
 if @where is null                      
  set @where = N''                        
                  
 set @sql = N'                    
 WITH WorkItemContact AS                  
 (                  
 SELECT                  
  EXIST_ISURGENT,                  
  UPPER(ATTACH_EXTENSION) as ATTACH_EXTENSION,                  
  EXIST_COMMENT,                  
  EXIST_REF_DOCUMENT,                  
  NAME as DOC_NAME,                  
  [SUBJECT],                  
  CREATOR,                  
  CREATOR_DEPT,                  
  EXIST_ATTACH,                  
  CREATOR_ID,                  
  PARENT_OID,                  
  a.FORM_ID,                  
  CURRENT_USER_NAME,                  
  CURRENT_DEPT_NAME,                  
  CURRENT_LEVEL,                  
  b.LOCATION,                
  a.CREATE_DATE as CREATE_DATE,        
  b.COMPLETED_DATE as COMPLETED_DATE,                  
  b.OPEN_YN,                  
  b.OID as WORK_ITEM_OID,                  
  b.PROCESS_INSTANCE_OID,                  
  b.WKITEM_ID,                  
  ROW_NUMBER() OVER ( ORDER BY '+ @orderby + N') AS RowNum,                   
  COUNT(*) OVER ( ) AS [RowCount],              
  DOC_NUMBER=DOC_NAME             
  ,BUDAT          
,BELNR          
,ZTEXT0          
,BKTXT          
,REPLACE(CONVERT(VARCHAR,ISNULL(FWBAS,0),1),''.00'','''') as FWBAS           
,REPLACE(CONVERT(VARCHAR,ISNULL(MWSTS,0),1),''.00'','''') as MWSTS          
,REPLACE(CONVERT(VARCHAR,ISNULL(SRBTR,0),1),''.00'','''') as SRBTR           
,MWSKZ            
,EVS_CNT          
,BLART          
,ZTEXT          
,POST1          
,BSTXT          
,CPUDT          
,MC_BZ_CL_NM          
,MC_NM          
,MC_CST_ID          
,KEYVALUE      
,BLDAT              
,FLAG  
, isnull(FUNDSMANAGER, '''') as FUNDSMANAGER  
, isnull(FUNDSMANAGERID, '''') as FUNDSMANAGERID   
, isnull(BUKRS,'''') as  BUKRS   
, isnull(LIFNR,'''') as  LIFNR   
, isnull(GSBER,'''') as  GSBER   
, isnull(GTEXT,'''') as  GTEXT              
 FROM WF.UV_PROCESS_INSTANCE_SLIP a                  
  INNER JOIN WF.WORK_ITEM_CMPL b ON A.OID = b.PROCESS_INSTANCE_OID                   
  left outer join WF.WF_DOC_NUMBER c                        
  on B.PROCESS_INSTANCE_OID = c.PROCESS_ID'                  
   + @where + '                  
    )                        
 SELECT *, COOPERATION_YN='''', BUNDLE_APPROVAL_YN=''''                  
 FROM WorkItemContact                   
 WHERE RowNum between @start_row and @end_row '                         
                       
 exec sp_executesql @sql, N'@user_id nvarchar(50), @dept_id nvarchar(50), @start_row int, @end_row int, @form_id varchar(33)        
  , @frmoney money, @tomoney money, @sv1 nvarchar(100), @sv2 nvarchar(100) '        
 , @user_id, @dept_id, @start_row, @end_row, @form_id, @frmoney, @tomoney,  @sv1, @sv2                      
                     
 print @sql                  
                  
END   





USE [EWF]
GO
/****** Object:  StoredProcedure [WF].[USP_SlipApprovalList_Fund_Select]    Script Date: 2018-02-13 ���� 10:40:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
      
-- =============================================              
-- Author:  �Ż���              
-- Create date: 2017-12-22              
-- Description: �ڱ��� ��� ��ȸ              
/*              
  EXEC [WF].[USP_SlipApprovalList_Fund_Select]       
 @user_id = '32088',      
 @site_code = 'SITE01',     
 @fund_state  = 'A',      
 @current_page  = 1,      
 @row_page  = 50,        
 @form_id  = '',      
 @sc1  = '',      
 @sv1  = '',      
 @sc2  = '',      
 @sv2  = '',      
 @sc3  = '',      
 @sv3  = '',      
 @scdate = '',      
 @start_date  = '',      
 @end_date   = '',        
 @scMoney = '',      
 @frMoney  = '',      
 @toMoney = '',      
 @create_dept = '',      
 @orderby_column = '',      
 @orderby_state   = ''      
 select * from Common.IM.VIEW_USER WHERE login_id = 'wslee4859'       
  
 select * from WF.PROCESS_INSTANCE WHERE OID = 'P8B4FF238812F41FFB155C2753EABA1DE'  
 select * from WF.WF_SLIP_LIST where FUNDSMANAGERID = '32088'  
*/              
-- =============================================              
ALTER PROCEDURE [WF].[USP_SlipApprovalList_Fund_Select]      
@user_id nvarchar(50), -- �ڱݴ����ID      
@site_code varchar(20),     
@fund_state char(1),      
@current_page int,   -- ���� ��ȸ�ϰ��� �ϴ� ������          
@row_page int,   -- �������� ���� ����Ʈ�� ��          
@form_id varchar(33), -- ���(�˻�)         
@sc1 varchar(30),      
@sv1 nvarchar(30),      
@sc2 varchar(30),      
@sv2 nvarchar(30),      
@sc3 varchar(30),      
@sv3 nvarchar(30),      
@scdate varchar(30),      
@start_date varchar(19), -- �˻�������          
@end_date varchar(19), -- �˻�������          
@scMoney varchar(20), -- �ݾ��÷�      
@frMoney int,      
@toMoney int,      
@create_dept nvarchar(50) = '', -- �ۼ��μ�(�˻�)      
@orderby_column varchar(50) = '', -- ���ĵ� �÷���      
@orderby_state bit   -- ��������          
      
AS          
          
 set nocount on;          
 set transaction isolation level read uncommitted;            
          
 declare @sql nvarchar(max),               
 @where nvarchar(2000) = '',          
 @orderby nvarchar(2000)        
 --@createdate_type  nvarchar(2) -- CREATEDATE ��ġ A:PROCESS_INSTANCE B: WORK_ITEM        
        
 -- ������ ��ϼ��� ���� ó���� �Ѵ�.            
 declare @start_row int, @end_row int          
 set @start_row = @row_page * (@current_page-1) + 1;          
 set @end_row = @row_page * (@current_page);          
        
         
          
 -- ����          
 if @orderby_column <> ''          
 begin          
  set @orderby_column = case @orderby_column when 'CREATE_DATE' then 'COMPLETED_DATE' else @orderby_column end      
  if @orderby_state  = 0 set @orderby = @orderby_column + N' desc '      
  else set @orderby = @orderby_column + N' asc '      
 end          
 else set  @orderby = N' COMPLETED_DATE desc '   
 
 
if(@orderby_column = 'FLAG')
begin
	if (@orderby_state  = 0)
	begin
		set @orderby = N' FLAG desc,FUNDSMANAGER desc  '         
	end
	else
	begin
		set @orderby = N' FLAG asc,FUNDSMANAGER asc  '         
	end
end 
             
 -- �˻��� ó��(���)      
 if (@form_id <> '')        
 begin         
  set @where = @where + N' and FORM_ID = @form_id '      
 end        
    
 -- SITE_CODE �� SYSTEMID ����(���� : BFSAP + userid, �ַ� : LFSAP)    
 if(@site_code = 'SITE01')    
 begin    
   set @where = @where + N' and SYSTEMID = ''BFSAP'' and FUNDSMANAGERID = @user_id '      
 end    
 else    
 begin    
    set @where = @where + N' and SYSTEMID = ''LFSAP'' '    
 end    
    
  -- �˻��� ó��(�ڱݻ��� null:���, 1:�İ�������, 7�İ�Ϸ�, 8:�İ�ݷ�)    
 if (@fund_state = '')    
 begin         
  set @where = @where + N' and FUNDSTATE IS NULL '    
 end         
 else if (@fund_state != 'A')    
 begin         
  set @where = @where + N' and FUNDSTATE = @fund_state '    
 end      
      
 -- �˻��� ó��(�˻�1)      
 if (@sc1 <> '' and @sv1 <> '')        
 begin           
  set @where = @where + N' and ' + @sc1 + ' = @sv1 '          
 end      
      
 -- �˻��� ó��(�˻�2)      
 if (@sc2 <> '' and @sv2 <> '')        
 begin           
  set @where = @where + N' and ' + @sc2 + '= @sv2 '      
 end      
            
 -- �˻��� ó��(�˻�3)      
 if (@sc3 <> '' and @sv3 <> '')        
 begin           
  set @where = @where + N' and ' + @sc3 + '= @sv3 '        
 end      
      
  -- �˻�����()      
 if (@scdate <> '' and (@start_date <> '' or @end_date <> ''))      
 begin      
  if(@start_date <> '' and @end_date = '')      
     set @where = @where + N' and ' + @scdate + ' >= @start_date '       
  else if (@start_date = '' and @end_date <> '')      
     set @where = @where + N' and ' + @scdate + ' <= @end_date '       
  else if (@start_date <> '' and @end_date <> '')      
     set @where = @where + N' and ' + @scdate + ' BETWEEN @start_date AND @end_date '       
 end      
      
   -- �ݾװ˻�      
 if (@scMoney <> '' and (@frMoney <> '' or @toMoney <> ''))      
 begin      
  if(@frMoney <> '' and @toMoney = '')      
     set @where = @where + N' and ' + @scMoney + ' >= @frMoney '       
  else if (@frMoney = '' and @toMoney <> '')      
     set @where = @where + N' and ' + @scMoney + ' <= @toMoney '       
  else if (@frMoney <> '' and @toMoney <> '')      
     set @where = @where + N' and ' + @scMoney + ' BETWEEN @frMoney AND @toMoney '       
 end      
            
 set @sql = N'          
    With WorkItemContact As          
    (          
  select       
  PROCESS_INSTANCE_OID, FORM_ID, STATE, NAME as FORM_NAME, CREATOR, CREATOR_ID, PARENT_OID, COMPLETED_DATE as CREATE_DATE, SUBJECT,      
  EXIST_ATTACH, EXIST_ISURGENT, EXIST_COMMENT, EXIST_REF_DOCUMENT, ATTACH_EXTENSION, DOC_LEVEL, DOC_NUMBER, CURRENT_USER_NAME, CREATOR_DEPT,      
  CURRENT_LEVEL, SYSTEMID, FORMALIAS, BELNR, BUDAT, BLART, BKTXT, BLTXT, BSTXT,       
  REPLACE(CONVERT(VARCHAR,ISNULL(SRBTR,0),1),''.00'','''') as SRBTR  ,      
  REPLACE(CONVERT(VARCHAR,ISNULL(FWBAS,0),1),''.00'','''') as FWBAS ,        
  REPLACE(CONVERT(VARCHAR,ISNULL(MWSTS,0),1),''.00'','''') as MWSTS  ,        
  REPLACE(CONVERT(VARCHAR,ISNULL(DSC_AFT_BIL_AM,0),1),''.00'','''') as DSC_AFT_BIL_AM  ,       
  MWSKZ, ZTEXT0, ZTEXT, POSID,      
  POST1, MC_NM, MC_BZ_CL_NM, FLAG, FUNDSMANAGERID, FUNDSMANAGER, isnull(BUKRS,'''') as  BUKRS 
  , isnull(LIFNR,'''') as  LIFNR   
  , isnull(GSBER,'''') as  GSBER   
  , isnull(GTEXT,'''') as  GTEXT 
  , ISNULL(FUNDSTATE,''0'') AS FUNDSTATE, FUND_PID, KEYVALUE, BLDAT, CPUDT, MC_CST_ID, EVS_CNT, ADD1, ADD2, ADD3, ADD4, ADD5,      
  ROW_NUMBER() OVER ( ORDER BY '+ @orderby + N') AS RowNum, COUNT(*) OVER ( ) AS [RowCount]        
  from WF.UV_PROCESS_INSTANCE_SLIP      
  WHERE FLAG=''Y'' and FORMALIAS is not null and STATE=7 '+ @where + N'      
    )              
    select * from WorkItemContact where RowNum between @start_row and @end_row '      
      
      
exec sp_executesql @sql, N'@start_row int, @end_row int, @fund_state char(1), @user_id nvarchar(50), @form_id varchar(33),  @sv1 nvarchar(30), @sv2 nvarchar(30),@sv3 nvarchar(30)    
    ,@start_date varchar(19),@end_date varchar(19),@create_dept nvarchar(50),@frMoney int, @toMoney int',      
     @start_row , @end_row , @fund_state, @user_id , @form_id,  @sv1 , @sv2 ,@sv3     
  ,@start_date ,@end_date ,@create_dept, @frMoney, @toMoney          
        
        
-- print @sql   






USE [EWF]
GO
/****** Object:  StoredProcedure [WF].[USP_SlipApprovalList_Fund_Select_ForExcel]    Script Date: 2018-02-13 ���� 10:42:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

      
-- =============================================              
-- Author:  �Ż���              
-- Create date: 2017-12-22              
-- Description: �ڱ��� ��� ��ȸ              
/*              
  EXEC [WF].[USP_SlipApprovalList_Fund_Select]       
 @user_id = '32088',      
 @site_code = 'SITE01',     
 @fund_state  = 'A',      
 @current_page  = 1,      
 @row_page  = 50,        
 @form_id  = '',      
 @sc1  = '',      
 @sv1  = '',      
 @sc2  = '',      
 @sv2  = '',      
 @sc3  = '',      
 @sv3  = '',      
 @scdate = '',      
 @start_date  = '',      
 @end_date   = '',        
 @scMoney = '',      
 @frMoney  = '',      
 @toMoney = '',      
 @create_dept = '',      
 @orderby_column = '',      
 @orderby_state   = ''      
 select * from Common.IM.VIEW_USER WHERE login_id = 'wslee4859'       
  
 select * from WF.PROCESS_INSTANCE WHERE OID = 'P8B4FF238812F41FFB155C2753EABA1DE'  
 select * from WF.WF_SLIP_LIST where FUNDSMANAGERID = '32088'  
*/              
-- =============================================              
ALTER PROCEDURE [WF].[USP_SlipApprovalList_Fund_Select_ForExcel]      
@user_id nvarchar(50), -- �ڱݴ����ID      
@site_code varchar(20),     
@fund_state char(1),            
@form_id varchar(33), -- ���(�˻�)         
@sc1 varchar(30),      
@sv1 nvarchar(30),      
@sc2 varchar(30),      
@sv2 nvarchar(30),      
@sc3 varchar(30),      
@sv3 nvarchar(30),      
@scdate varchar(30),      
@start_date varchar(19), -- �˻�������          
@end_date varchar(19), -- �˻�������          
@scMoney varchar(20), -- �ݾ��÷�      
@frMoney int,      
@toMoney int,        
@orderby_column varchar(50) = '', -- ���ĵ� �÷���      
@orderby_state bit   -- ��������          
      
AS          
          
 set nocount on;          
 set transaction isolation level read uncommitted;            
          
 declare @sql nvarchar(max),               
 @where nvarchar(2000) = '',          
 @orderby nvarchar(2000)        
         
          
 -- ����          
 if @orderby_column <> ''          
 begin          
  set @orderby_column = case @orderby_column when 'CREATE_DATE' then 'COMPLETED_DATE' else @orderby_column end      
  if @orderby_state  = 0 set @orderby = @orderby_column + N' desc '      
  else set @orderby = @orderby_column + N' asc '      
 end          
 else set  @orderby = N' COMPLETED_DATE desc '    
             
 -- �˻��� ó��(���)      
 if (@form_id <> '')        
 begin         
  set @where = @where + N' and FORM_ID = @form_id '      
 end        
    
 -- SITE_CODE �� SYSTEMID ����(���� : BFSAP + userid, �ַ� : LFSAP)    
 if(@site_code = 'SITE01')    
 begin    
   set @where = @where + N' and SYSTEMID = ''BFSAP'' and FUNDSMANAGERID = @user_id '      
 end    
 else    
 begin    
    set @where = @where + N' and SYSTEMID = ''LFSAP'' '    
 end    
    
  -- �˻��� ó��(�ڱݻ��� null:���, 1:�İ�������, 7�İ�Ϸ�, 8:�İ�ݷ�)    
 if (@fund_state = '')    
 begin         
  set @where = @where + N' and FUNDSTATE IS NULL '    
 end         
 else if (@fund_state != 'A')    
 begin         
  set @where = @where + N' and FUNDSTATE = @fund_state '    
 end      
      
 -- �˻��� ó��(�˻�1)      
 if (@sc1 <> '' and @sv1 <> '')        
 begin           
  set @where = @where + N' and ' + @sc1 + ' = @sv1 '          
 end      
      
 -- �˻��� ó��(�˻�2)      
 if (@sc2 <> '' and @sv2 <> '')        
 begin           
  set @where = @where + N' and ' + @sc2 + '= @sv2 '      
 end      
            
 -- �˻��� ó��(�˻�3)      
 if (@sc3 <> '' and @sv3 <> '')        
 begin           
  set @where = @where + N' and ' + @sc3 + '= @sv3 '        
 end      
      
  -- �˻�����()      
 if (@scdate <> '' and (@start_date <> '' or @end_date <> ''))      
 begin      
  if(@start_date <> '' and @end_date = '')      
     set @where = @where + N' and ' + @scdate + ' >= @start_date '       
  else if (@start_date = '' and @end_date <> '')      
     set @where = @where + N' and ' + @scdate + ' <= @end_date '       
  else if (@start_date <> '' and @end_date <> '')      
     set @where = @where + N' and ' + @scdate + ' BETWEEN @start_date AND @end_date '       
 end      
      
   -- �ݾװ˻�      
 if (@scMoney <> '' and (@frMoney <> '' or @toMoney <> ''))      
 begin      
  if(@frMoney <> '' and @toMoney = '')      
     set @where = @where + N' and ' + @scMoney + ' >= @frMoney '       
  else if (@frMoney = '' and @toMoney <> '')      
     set @where = @where + N' and ' + @scMoney + ' <= @toMoney '       
  else if (@frMoney <> '' and @toMoney <> '')      
     set @where = @where + N' and ' + @scMoney + ' BETWEEN @frMoney AND @toMoney '       
 end      
            
 set @sql = N'          
    With WorkItemContact As          
    (          
  select       
  PROCESS_INSTANCE_OID, FORM_ID, STATE, NAME as FORM_NAME, CREATOR, CREATOR_ID, PARENT_OID, COMPLETED_DATE as CREATE_DATE, SUBJECT,      
  EXIST_ATTACH, EXIST_ISURGENT, EXIST_COMMENT, EXIST_REF_DOCUMENT, ATTACH_EXTENSION, DOC_LEVEL, DOC_NUMBER, CURRENT_USER_NAME, CREATOR_DEPT,      
  CURRENT_LEVEL, SYSTEMID, FORMALIAS, BELNR, BUDAT, BLART, BKTXT, BLTXT, BSTXT,       
  REPLACE(CONVERT(VARCHAR,ISNULL(SRBTR,0),1),''.00'','''') as SRBTR  ,      
  REPLACE(CONVERT(VARCHAR,ISNULL(FWBAS,0),1),''.00'','''') as FWBAS ,        
  REPLACE(CONVERT(VARCHAR,ISNULL(MWSTS,0),1),''.00'','''') as MWSTS  ,        
  REPLACE(CONVERT(VARCHAR,ISNULL(DSC_AFT_BIL_AM,0),1),''.00'','''') as DSC_AFT_BIL_AM  ,       
  MWSKZ, ZTEXT0, ZTEXT, POSID,      
  POST1, MC_NM, MC_BZ_CL_NM, FLAG, FUNDSMANAGERID, FUNDSMANAGER, isnull(BUKRS,'''') as  BUKRS
  , isnull(LIFNR,'''') as  LIFNR   
  , isnull(GSBER,'''') as  GSBER   
  , isnull(GTEXT,'''') as  GTEXT 
  ,ISNULL(FUNDSTATE,''0'') AS FUNDSTATE, FUND_PID, KEYVALUE, BLDAT, CPUDT, MC_CST_ID, EVS_CNT, ADD1, ADD2, ADD3, ADD4, ADD5,      
  ROW_NUMBER() OVER ( ORDER BY '+ @orderby + N') AS RowNum, COUNT(*) OVER ( ) AS [RowCount]          
  from WF.UV_PROCESS_INSTANCE_SLIP      
  WHERE FLAG=''Y'' and FORMALIAS is not null and STATE=7 '+ @where + N'      
    )              
    select * from WorkItemContact '      
      
      
exec sp_executesql @sql, N'@fund_state char(1), @user_id nvarchar(50), @form_id varchar(33),  @sv1 nvarchar(30), @sv2 nvarchar(30),@sv3 nvarchar(30)    
    ,@start_date varchar(19),@end_date varchar(19),@@frMoney int, @toMoney int',      
     @fund_state, @user_id , @form_id,  @sv1 , @sv2 ,@sv3     
  ,@start_date ,@end_date ,@frMoney, @toMoney          
        
        
 print @sql 





USE [EWF]
GO
/****** Object:  StoredProcedure [WF].[USP_SlipApprovalList_Reject_Select]    Script Date: 2018-02-13 ���� 10:42:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
  
  
    
          
          
          
-- =============================================          
-- Author:  ����          
-- Create date: 2018-01-09    
-- Description: ��ǥ�ݷ��� ��� ��ȸ          
/*          
          
exec [WF].[USP_SlipApprovalList_Reject_Select]  @user_id=N'32088',@dept_id=N'5613',@current_page=1,@row_page=15,@form_id='',@subject=N'',@create_dept=N'',@orderby_column='CREATE_DATE',@orderby_state=0,@start_date=N'',@end_date=N''          
*/          
-- =============================================          
ALTER PROCEDURE [WF].[USP_SlipApprovalList_Reject_Select]          
 @user_id nvarchar(50), -- �����ID          
 @dept_id nvarchar(50), -- �μ�ID            
 @current_page int,   -- ��������ȣ          
 @row_page int,   -- ����Ʈ����           
 @form_id varchar(33), -- ��ǥ����(�˻�)           
 @orderby_column varchar(50), -- �����÷�          
 @orderby_state bit,   -- ���Ĺ��            
 @scdate   varchar(20), -- �˻���¥����          
@start_date nvarchar(10), -- �˻�������                
@end_date nvarchar(10), -- �˻�������               
@scmoney   varchar(20), -- �˻��ݾ�          
@frmoney money, -- �˻��ݾ�From          
@tomoney money, -- �˻��ݾ�To          
@sc1 varchar(30), -- �˻��ʵ�1          
@sv1 nvarchar(100), -- �˻�Text1          
@sc2 varchar(30), -- �˻��ʵ�1          
@sv2 nvarchar(100) -- �˻�Text1          
     
AS          
BEGIN          
           
 --set nocount on;            
 --set transaction isolation level read uncommitted;              
            
 declare @sql nvarchar(4000),                 
 @where nvarchar(1000),            
 @orderby nvarchar(100)            
            
 -- ������ ��ϼ��� ���� ó���� �Ѵ�.              
 declare @start_row int, @end_row int            
 set @start_row = @row_page * (@current_page-1) + 1;            
 set @end_row = @row_page * (@current_page);            
            
 -- ����            
    if @orderby_column <> ''            
    begin            
  if UPPER(@orderby_column) = 'DOC_NAME' begin set @orderby_column = 'NAME' end              
  set @orderby = case UPPER(@orderby_column) when 'CREATE_DATE' then N'b.'+ @orderby_column else  @orderby_column end            
  if @orderby_state  = 0            
   set @orderby = @orderby + N' desc '            
  else            
   set @orderby = @orderby + N' asc '            
 end            
 else            
  set  @orderby = N' a.CREATE_DATE desc '      
  
 
if(@orderby_column = 'FLAG')
begin
	if (@orderby_state  = 0)
	begin
		set @orderby = N' FLAG desc,FUNDSMANAGER desc  '         
	end
	else
	begin
		set @orderby = N' FLAG asc,FUNDSMANAGER asc  '         
	end
end
       
              
 -- �����ID, �μ�ID�� ���� ó��           
 set @user_id = @user_id  + N'_CJ'          
 -- �μ� �ּ�          
 set @where = N' WHERE b.DELETE_DATE IS NULL AND b.PARTICIPANT_ID = @user_id '          
   
          
 -- ������� �˻�����            
 if (@form_id <> '')              
 begin              
  set @where = @where + N' and FORM_ID = @form_id '           
 end            
 -- ������� �˻�����         
      
--��¥Ÿ�� �˻�����( BLDAT:������ CPUDT:��ǥ�Է���, CREATE_DATE:�����       
 if (@scdate <> '' and (@start_date <> '' or @end_date <> ''))              
 begin         
  if(@scdate = 'CREATE_DATE')        
  begin        
 set @scdate = N'A.CREATE_DATE'        
  end        
             
  if(@start_date <> '' and @end_date <> '')          
  begin          
 set @where = @where + N' and ' + @scdate + N'  between ''' + @start_date + ''' and ''' + @end_date + ''' '          
  end          
  else if(@start_date = '' and @end_date <> '')          
  begin          
 set @where = @where + N' and '+ @scdate + N' <= ''' + @end_date + ''' '        
  end          
  else if(@start_date <> '' and @end_date = '')          
  begin          
 set @where = @where + N' and ' + @scdate + N' >= ''' + @start_date + ''' '          
  end          
 end              
 --��¥Ÿ�� �˻�����             
      
 --�ݾ�Ÿ�� �˻�����          
 if (@scmoney <> '' and (@frmoney <> '' or @tomoney <> ''))              
 begin              
  set @where = @where + N' and '          
  if(@frmoney <> '' and @tomoney <> '')          
  begin          
 set @where = @where + @scmoney + N' between @frmoney and @tomoney '          
  end          
  else if(@frmoney = '' and @tomoney <> '')          
  begin          
 set @where = @where + @scmoney + N' <= @tomoney '          
  end          
  else if(@frmoney <> '' and @tomoney = '')          
  begin          
 set @where = @where + @scmoney + N' >= @frmoney '          
  end          
 end              
 --�ݾ�Ÿ�� �˻�����          
     
 --�˻�TEXT1 ����          
if (@sc1 <> '' and @sv1 <> '')             
begin              
 set @where = @where + N' and ';                  
 set @sv1 =  N'%'+ @sv1 +N'%';                 
 set @where = @where + @sc1 + N' like @sv1 '                
end              
 --�˻�TEXT1 ����          
           
 --�˻�TEXT2 ����          
if (@sc2 <> '' and @sv2 <> '')              
begin              
 set @where = @where + N' and ';                
 set @sv2 =  N'%'+ @sv2 +N'%';                 
 set @where = @where + @sc2 + N' like @sv2 '                
end              
--�˻�TEXT2 ����          
    
          
 set @sql = N'            
 WITH WorkItemContact AS          
 (          
 SELECT          
  EXIST_ISURGENT,          
  UPPER(ATTACH_EXTENSION) as ATTACH_EXTENSION,          
  EXIST_COMMENT,          
  EXIST_REF_DOCUMENT,          
  NAME as DOC_NAME,          
  [SUBJECT],          
  CREATOR,          
  CREATOR_DEPT,          
  EXIST_ATTACH,          
  CREATOR_ID,          
  PARENT_OID,          
  FORM_ID,          
  CURRENT_USER_NAME,          
  CURRENT_DEPT_NAME,          
  CURRENT_LEVEL,          
  b.LOCATION,          
  b.COMPLETED_DATE as CREATE_DATE,          
  b.OPEN_YN,          
  b.OID as WORK_ITEM_OID,          
  b.PROCESS_INSTANCE_OID,          
  b.WKITEM_ID,          
  ROW_NUMBER() OVER ( ORDER BY '+ @orderby + N') AS RowNum,           
  COUNT(*) OVER ( ) AS [RowCount]          
  ,BUDAT      
,BELNR      
,ZTEXT0      
,BKTXT      
,REPLACE(CONVERT(VARCHAR,ISNULL(FWBAS,0),1),''.00'','''') as FWBAS       
,REPLACE(CONVERT(VARCHAR,ISNULL(MWSTS,0),1),''.00'','''') as MWSTS      
,REPLACE(CONVERT(VARCHAR,ISNULL(SRBTR,0),1),''.00'','''') as SRBTR       
,MWSKZ        
,EVS_CNT      
,BLART      
,ZTEXT      
,POST1      
,BSTXT      
,CPUDT      
,MC_BZ_CL_NM      
,MC_NM      
,MC_CST_ID      
,KEYVALUE    
,BLDAT          
,FLAG  
, isnull(FUNDSMANAGER, '''') as FUNDSMANAGER  
, isnull(FUNDSMANAGERID, '''') as FUNDSMANAGERID   
, isnull(BUKRS,'''') as  BUKRS   
, isnull(LIFNR,'''') as  LIFNR   
, isnull(GSBER,'''') as  GSBER   
, isnull(GTEXT,'''') as  GTEXT 
 FROM WF.UV_PROCESS_INSTANCE_SLIP a          
  INNER JOIN WF.WORK_ITEM_CMPL b ON A.OID = b.PROCESS_INSTANCE_OID '          
   + @where + '          
    )                
 SELECT w.*, COOPERATION_YN, BUNDLE_APPROVAL_YN          
 FROM WorkItemContact w            
 inner join WF.WF_FORM_SCHEMA s             
 on w.form_id = s.form_id             
 WHERE RowNum between @start_row and @end_row '                 
               
 exec sp_executesql @sql, N'@user_id nvarchar(50), @dept_id nvarchar(50), @start_row int, @end_row int, @form_id varchar(33)    
 , @frmoney money, @tomoney money, @sv1 nvarchar(100), @sv2 nvarchar(100)'     
 , @user_id, @dept_id, @start_row, @end_row, @form_id, @frmoney, @tomoney,  @sv1, @sv2               
             
 print @sql          
          
END          
          
          
          
          



