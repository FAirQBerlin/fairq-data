insert into preds_grid_filled_with_null
select 
 	stcm.model_id,
 	stcm.date_time,
 	stcm.x,
  stcm.y,
 	stcm.id,
 	value
from 
	selected_times_coords_ids stcm
left join 
 	(select model_id, date_time, x, y, value from model_predictions_grid_latest final) mpgl
on (stcm.model_id = mpgl.model_id and stcm.date_time = mpgl.date_time and toUInt32(stcm.x) = mpgl.x and toUInt32(stcm.y) = mpgl.y)
SETTINGS join_use_nulls = 1, max_threads = 4, max_insert_threads = 4;
