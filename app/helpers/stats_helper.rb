module StatsHelper

	def seconds_to_words(seconds)
		distance_of_time_in_words Time.at(0).utc, Time.at(seconds).utc
	end

	def seconds_to_units(secs)
		mm, ss = secs.divmod(60)
		hh, mm = mm.divmod(60)
		[hh, mm, ss].map { |n| n < 10 ? "0#{n}" : n }.join(':')
	end

	def seconds_to_score(seconds)
		seconds / 60
	end

	def info_box(title, &block)
		render 'info_box', title: title, block: block
	end

	def user_active?(user)
		@active_users.include? user
	end

	def time_for_group(group)
		users_in_group = @users.select { |u| u.groups.include? group}
		users_in_group.map { |u| u.total_time }.sum
	end

	def get_sorted_groups_with_time()
		Hash[User::ALLOWED_GROUPS.map { |g| [g, (time_for_group g.to_s)] } ]
		.sort_by{ |_k, v| v}.reverse
	end
end
