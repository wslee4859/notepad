-- ��Ż���� �˾� ����

select * from [BD].[BoardBase] where articleID = '6284'

begin tran 
update [BD].[BoardBase]
set IsPopup = 'Y', IsApproval = '1'
where articleID = '6284'
commit