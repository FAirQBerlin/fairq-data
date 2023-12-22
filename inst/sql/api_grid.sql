insert into api_grid (*)
with preds_filled_with_null_ordered_final as (
select 
model_id, date_time, x, y, id, value
from 
  preds_grid_filled_with_null final
where date_time >= (select max(date_time_forecast) from model_predictions_grid)
and model_id in (select model_id from models_final where domain = 'spatial')
order by id, date_time asc, model_id
),
latest_predictions_long as 
(
select
  x,
  y,
  model_id,
  id, 
  min(date_time) as date_time_forecast, 
  min(date_time) as first_pred_date_time,
  max(date_time) as last_pred_date_time,
  groupArray(COALESCE(round(value, 1), -999)) as value
from preds_filled_with_null_ordered_final
group by
  x,
  y,
  model_id,
  id
 )
select 
  x,
  y,
  id,
  date_time_forecast,
  first_pred_date_time,
  last_pred_date_time,
  anyIf(value, model_id = (select model_id from models_final where pollutant = 'no2' and `domain` = 'spatial')) as no2, 
  anyIf(value, model_id = (select model_id from models_final where pollutant = 'pm10' and `domain` = 'spatial')) as pm10, 
  anyIf(value, model_id = (select model_id from models_final where pollutant = 'pm25' and `domain` = 'spatial')) AS pm25
from latest_predictions_long
group by
 	x,
 	y,
 	id,
 	date_time_forecast,
 	first_pred_date_time,
 	last_pred_date_time
SETTINGS max_threads = 4, max_insert_threads = 4;
