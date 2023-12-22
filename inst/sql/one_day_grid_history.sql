select 
  model_id, x, y, date_time_forecast, date_time, value
from 
  model_predictions_grid
where 
  date_time >= '{{ date }}' and date_time < date_add(DAY, 1, toDate('{{ date }}'));
