INSERT INTO FUNCTION
   s3('{{ paste(aws_bucket, filename, sep = "/") }}', 
      '{{ aws_key }}', 
      '{{ aws_secret }}', 
      'CSVWithNames') 
with model_predictions_grid_latest as (
  select 
  x,
  y,
  model_id,
  value
  from model_predictions_grid_history -- history
  where date_time > now() - interval 1 year 
  and date_time < now()
  and (model_id, date_time, date_time_forecast) in (
  -- use latest date_time_forecast for each date_time
    select model_id, date_time, max(date_time_forecast) as date_time_forecast from model_predictions_grid_history -- history
    group by model_id, date_time 
)
 and model_id in (select model_id from model_description where model_name = 'full_data_spatial')
)
select 
 x,
 y,
 round(avgIf(value, pollutant == 'no2'), 0) as no2,
 round(avgIf(value, pollutant == 'pm10'), 0) as pm10,
 round(avgIf(value, pollutant == 'pm25'), 0) as `pm2.5`
from 
model_predictions_grid_latest
left join
model_description using(model_id)
group by x, y
SETTINGS s3_truncate_on_insert=true;
