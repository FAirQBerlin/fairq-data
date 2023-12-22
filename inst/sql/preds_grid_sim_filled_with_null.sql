insert into preds_grid_sim_filled_with_null
select 
 	stcmp.model_id,
 	stcmp.date_time,
 	stcmp.x,
  stcmp.y,
  stcmp.element_nr,
 	stcmp.kfz_pct,
 	value
from 
	(select date_time, model_id, x, y, kfz_pct, element_nr from selected_times_coords_ids_pct final) stcmp
left join 
 	(select model_id, date_time, x, y, kfz_pct, value from model_predictions_grid_sim_latest final) mpgl
on (stcmp.model_id = mpgl.model_id and stcmp.date_time = mpgl.date_time and 
    toUInt32(stcmp.x) = mpgl.x and toUInt32(stcmp.y) = mpgl.y and stcmp.kfz_pct = mpgl.kfz_pct)
SETTINGS join_use_nulls = 1, max_threads = 4, max_insert_threads = 4;
