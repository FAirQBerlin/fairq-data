insert into pred_stations_filled_with_null
select 
 	stsi.model_id,
 	stsi.date_time,
 	stsi.station_id,
 	value
from 
 selected_times_stations_ids stsi
left join 
 	(select model_id, date_time, station_id, value from model_predictions_stations_latest final) mpsl
on (stsi.model_id = mpsl.model_id and stsi.date_time = mpsl.date_time and stsi.station_id = mpsl.station_id)
SETTINGS join_use_nulls = 1;
