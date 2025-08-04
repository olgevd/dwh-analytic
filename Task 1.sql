with auto_num as (select
    camera_id,
    count(distinct(auto_num)) as uniq_auto
  from auto_fixation 
  where substring(auto_num, 6, 2) like '24' or 
    substring(auto_num, 6, 2) like '84' or
    substring(auto_num, 6, 2) like '88' or 
    substring(auto_num, 6, 3) like '124'),

  district as (select
    c.camera_id as camera_id,
    c.district_nm,
    an.uniq_auto as uniq_auto,
    an.camera_id
  from camera as c
  join auto_num as an on an.camera_id = c.camera_id
  where c.district_nm = 'Донской'
  ),
  
  speed as (
  select 
    d.camera_id,
    d.uniq_aito as uniq_auto,
    af.camera_id,
    af.fix_speed as fix_speed,
    c.allowed_speed
  from auto_fixation as af
  join camera as c on c.camera_id = af.camera_id
  join district as d on d.camera_id = af.camera_id
  where af.fix_speed > c.allowed_speed)



select
  d.uniq_auto as count_distinct,
  round((s.uniq_auto/d.uniq_auto)*100, 2) as perc_speeding,
  avg(s.fix_speed) as avg_speed
from district as d
join speed as s on s.camera_id = d.camera_id
where d.date >= date_trunc('month', current_date - interval '1' month) and d.date < date_trunc('month', current_date)