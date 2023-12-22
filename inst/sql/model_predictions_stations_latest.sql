insert into model_predictions_stations_latest
select
  model_id,
  station_id,
  date_time,
  value
from
  model_predictions_temporal -- muss noch modellseitig auf stations umgestellt werden
where (model_id, station_id, date_time_forecast) in (
 select model_id, station_id, max(date_time_forecast) as date_time_forecast from model_predictions_temporal 
 where model_id in (select model_id from models_final where domain = 'temporal') 
 group by model_id, station_id
)
and date_time > now() - interval 1 day;
