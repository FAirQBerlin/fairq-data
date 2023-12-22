INSERT INTO FUNCTION
   s3('{{ paste(aws_bucket, filename, sep = "/") }}', 
      '{{ aws_key }}', 
      '{{ aws_secret }}', 
      'CSVWithNames') 
with street_coordinates as (
  select
    element_nr, 
    stadt_x, 
    stadt_y
  from
    fairq_{{ mode }}features.coord_mapping_stadt_streets
  where element_nr in (select element_nr from fairq_raw.stadtstruktur_network_streets where strassenklasse1 in ('0', 'I', 'II', 'III', 'IV'))
),
model_predictions_grid_latest as (
  select 
    x,
    y,
    date_time,
    toNullable(scaling * value) as value
  from 
    fairq_{{ mode }}features.traffic_model_predictions_grid 
  inner join
    fairq_{{ mode }}features.traffic_model_scaling using(x, y) 
  where date_time > now() - interval 1 year 
  and date_time < now()
  and (date_time, model_id) in (
  -- use latest model_id for each date_time
	select date_time, max(model_id) from fairq_{{ mode }}features.traffic_model_predictions_grid 
	where model_id in (select model_id from traffic_model_description where depvar = 'q_kfz')
	group by date_time
  )
  and (x, y) in (select stadt_x, stadt_y from street_coordinates)
)
select 
 element_nr,
 round(avgIf(value, toDayOfWeek(date_time) <= 4), 0) * 24 as q_kfz_DTVw,
 round(avgIf(value, toDayOfWeek(date_time) == 5), 0) * 24 as q_kfz_DTV_friday,
 round(avgIf(value, toDayOfWeek(date_time) >= 6), 0) * 24 as q_kfz_DTV_weekend,
 round(avg(value), 0) * 24 as q_kfz_DTV
from 
model_predictions_grid_latest
left join 
street_coordinates on (x = stadt_x and y = stadt_y)
group by element_nr 
order by element_nr
SETTINGS s3_truncate_on_insert=true;
