Select	*
			From	dbo.TB_Group g
					Join	dbo.TB_Group_User gu
						On	gu.GroupID = g.GroupID
						and	gu.UserID = '140758'
			Where	(
						EXISTS (select	1	from	tb_except_user	where	userid = g.GroupID	and	UserGroup = 'JJ')
						or
						EXISTS (select	1	from	tb_except_user	where	userid = g.GroupID  and UserGroup = 'DL')											
						or
						EXISTS (select	1	from	tb_except_user	where	userid = gu.UserID  and UserGroup = 'UU')

												
					)

