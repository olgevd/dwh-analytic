with date_c as (select
		distinct (fix_dttm::date) as dt
	from auto_fixation
	where date_trunc('year', fix_dttm) = date_trunc('year', current_date)),
	
	camera as (select 
		distinct camera_id as camera_id
	from auto_fixation),
	
	working_camera as (select 
		distinct camera_id as camera_id, 
		fix_dttm::date as dt
	from auto_fixation),
	
	camera_combinations as (select 
		d.dt as dt, 
		c.camera_id as camera_id
  	from date_c as d 
  	cross join camera as c),
	
	not_working as (select
		сc.date as dt, 
		сc.camera_id as camera_id
    from camera_combinations as cc
    left join working_camera as wc on cc.date = wc.dt and cc.camera_id = wc.camera_id
    where wc.camera_id is null)
	
select 
	*
from not_working
order by dt, camera_id
