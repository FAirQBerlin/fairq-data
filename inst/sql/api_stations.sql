insert into api_stations (*)
with preds_filled_with_null_ordered_final as (
select 
model_id, date_time, station_id, value
from 
  pred_stations_filled_with_null final
where date_time >= (select max(date_time_forecast) from model_predictions_temporal)
and model_id in (select model_id from models_final where domain = 'temporal')
order by station_id, date_time asc, model_id
),
latest_predictions_long as 
(
select
  station_id, 
  model_id,
  min(date_time) as date_time_forecast, 
  min(date_time) as first_pred_date_time,
  max(date_time) as last_pred_date_time,
  groupArray(COALESCE(round(value, 1), -999)) as value
from preds_filled_with_null_ordered_final
group by
  station_id, 
  model_id
 )
select 
  station_id,
  station_x AS x,
  station_y AS y,
  date_time_forecast,
  first_pred_date_time,
  last_pred_date_time,
  anyIf(value, model_id = (select model_id from models_final where pollutant = 'no2' and `domain` = 'temporal')) as no2, 
  anyIf(value, model_id = (select model_id from models_final where pollutant = 'pm10' and `domain` = 'temporal')) as pm10, 
  anyIf(value, model_id = (select model_id from models_final where pollutant = 'pm25' and `domain` = 'temporal')) AS pm25
from 
  latest_predictions_long
inner join 
  fairq_{{ mode }}features.coord_mapping_stadt_station using(station_id)
group by
  station_id, 
  x,
  y,
 	date_time_forecast,
 	first_pred_date_time,
 	last_pred_date_time;
