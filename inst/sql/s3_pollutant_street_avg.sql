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
    pollutant,
    value 
  from 
    model_predictions_grid_history
  left join
    model_description using(model_id)
  where date_time > now() - interval 1 year 
  and date_time < now()
  and (model_id, date_time, date_time_forecast) in (
  -- use latest date_time_forecast for each date_time
      select model_id, date_time, max(date_time_forecast) as date_time_forecast from model_predictions_grid_history
      group by model_id, date_time 
  )
  and (x, y) in (select stadt_x, stadt_y from street_coordinates)
  and model_id in (select model_id from model_description where model_name = 'full_data_spatial')
)
select 
  element_nr,
  round(avgIf(value, pollutant == 'no2'), 0) as no2,
  round(avgIf(value, pollutant == 'pm10'), 0) as pm10,
  round(avgIf(value, pollutant == 'pm25'), 0) as `pm2.5`
from 
  model_predictions_grid_latest
left join 
  street_coordinates on (x = stadt_x and y = stadt_y)
group by element_nr
order by element_nr
SETTINGS s3_truncate_on_insert=true;
