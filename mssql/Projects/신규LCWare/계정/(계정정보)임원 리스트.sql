

����,ȸ��,�λ���,����,�󹫺�A,M2(������),M2(����),M1(����),S2(����),S1(����),�Ѱ�ȸ��,��,M2,M1,S2,S1,�󹫺�B,�ڹ�,��,��ȸ��


select * from [IM].[VIEW_USER] 
where (position_name in ( '����','ȸ��','�λ���','����','�󹫺�A','�󹫺�B','��','�Ѱ�ȸ��','�ڹ�','��','��ȸ��','��ǥ�̻�')
	OR classpos_name in ('�ӿ�','����','��','����','ȸ��','�λ���','����','�󹫺�A','�󹫺�B','��','�Ѱ�ȸ��','�ڹ�','��','��ȸ��','��ǥ�̻�'))
	AND login_id is not null
	order by domain_code desc , user_name 


	AND position_name is not null

	select * from [IM].[VIEW_USER] 
where user_name  ='������'
