with dead_end as (select
		camera_id,
		auto_num as count
	from auto_fixation
	where camera_id = '1' and direction = '1'),
	
	out_dead_end as (select
		camera_id,
		auto_num,
		date_trunc('week', fix_dttm)::date as week
	from auto_fixation
	where camera_id = '1' and direction = '0'
	group by fix_dttm),
	
	week_count as (select 
		auto_num, 
		count(*) as exit_count, 
		count(distinct week) as week_count
    from out_dead_end
    group by auto_num),

	avg as (select
        auto_num,
        1.0 * exit_count / nullif(week_count, 0) as avg_per_week
    from week_count),

	less_3 as (select 
		auto_num 
	from avg WHERE avg_per_week < 3)

select
    (select count(*) from less_3)::float /
    nullif((select count(distinct auto_num) from dead_end), 0) * 100 as percent