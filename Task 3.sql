with dead_end as (select
		camera_id,
		count(auto_num) as count,
		fix_dttm::date as day
	from auto_fixation
	where camera_id = 1 and direction = 1
	group by day, camera_id),
	
	avg_count as (select
		avg(count) as avg_count
	from dead_end)
	

select
	de.day
from dead_end as de 
cross join avg_count as ac 
where de.count/ac.avg_count >= 2
group by de.day
