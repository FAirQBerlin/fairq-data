INSERT INTO FUNCTION
   s3('{{ paste(aws_bucket, filename, sep = "/") }}', 
      '{{ aws_key }}', 
      '{{ aws_secret }}', 
      'CSVWithNames') 
with model_predictions_grid_latest as (
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
)
select 
 x,
 y,
 round(avgIf(value, toDayOfWeek(date_time) <= 4), 0) * 24 as q_kfz_DTVw,
 round(avgIf(value, toDayOfWeek(date_time) == 5), 0) * 24 as q_kfz_DTV_friday,
 round(avgIf(value, toDayOfWeek(date_time) >= 6), 0) * 24 as q_kfz_DTV_weekend,
 round(avg(value), 0) * 24 as q_kfz_DTV
from 
model_predictions_grid_latest
group by x, y 
SETTINGS s3_truncate_on_insert=true;
