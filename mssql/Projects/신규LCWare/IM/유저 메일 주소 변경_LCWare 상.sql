-- �ű� LCWare DB

select * from Common.IM.VIEW_USER where user_name = 'Ȳġ��'
--jjoosi@lotteliquor.com

select domain_name, user_name, login_id, email from Common.IM.VIEW_USER where login_id = 'photosg' 



begin tran
update Common.IM.VIEW_USER 
set email = 'photosg@lotteliquor.com' 
where login_id = 'photosg'
--commit




begin tran
update Common.IM.VIEW_PLURAL 
set email = 'photosg@lotteliquor.com' 
where login_id = 'photosg'

--commit




-- ����ȣ 
select * from Common.IM.VIEW_USER where user_name = 'Ȳ����'

begin tran
update Common.IM.VIEW_USER 
set mobile = '010-4039-7833' 
where user_code = '22222'
--commit




begin tran
update Common.IM.VIEW_PLURAL 
set mobile = '010-4039-7833' 
where user_code = '22222'

--commit