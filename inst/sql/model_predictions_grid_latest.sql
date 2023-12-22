insert into model_predictions_grid_latest
select
  model_id,
  date_time, 
  x,
  y,
  value
from
  model_predictions_grid final
where (model_id, date_time_forecast) in (
 select model_id, max(date_time_forecast) as date_time_forecast from model_predictions_grid 
 where model_id in (select model_id from models_final where domain = 'spatial') 
 group by model_id
)
and date_time > now() - interval 1 day;
