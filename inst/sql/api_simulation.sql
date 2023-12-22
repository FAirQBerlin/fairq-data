insert into api_simulation 
with grid_sim_agg as (
  select
    model_id,           
    element_nr,
    toDate(date_time - interval 1 minute, 'Europe/Berlin') `date`,
    kfz_pct,
    avg(value) AS value
  from 
    preds_grid_sim_filled_with_null final
  where date_time > (select toStartOfDay(max(date_time_forecast)) from model_predictions_grid_sim)
  and model_id in (select model_id from models_final where domain = 'spatial')
  group by
    model_id,
    `date`,
    element_nr,
    kfz_pct
  order by
    model_id,
    element_nr asc,
    kfz_pct asc,
    `date` asc
),
grid_sim_long as (
  select
    model_id,
    element_nr,
    kfz_pct,
    min(`date`) AS first_pred_date_time,
    max(`date`) AS last_pred_date_time,
    groupArray(COALESCE(round(value, 1), -999)) AS value
  from 
    grid_sim_agg
  group by
    model_id,
    element_nr,
    kfz_pct
)
select
  grid_sim_long.element_nr element_nr,
  max(mpg.date_time_forecast) date_time_forecast,
  min(first_pred_date_time) AS first_pred_date_time,
  max(last_pred_date_time) AS last_pred_date_time,
  anyIf(value, (model_id, kfz_pct) = ((select model_id from models_final where pollutant = 'no2' and `domain` = 'spatial'), 0)) AS no2_0,
  anyIf(value, (model_id, kfz_pct) = ((select model_id from models_final where pollutant = 'no2' and `domain` = 'spatial'), 10)) AS no2_10,
  anyIf(value, (model_id, kfz_pct) = ((select model_id from models_final where pollutant = 'no2' and `domain` = 'spatial'), 20)) AS no2_20,
  anyIf(value, (model_id, kfz_pct) = ((select model_id from models_final where pollutant = 'no2' and `domain` = 'spatial'), 30)) AS no2_30,
  anyIf(value, (model_id, kfz_pct) = ((select model_id from models_final where pollutant = 'no2' and `domain` = 'spatial'), 40)) AS no2_40,
  anyIf(value, (model_id, kfz_pct) = ((select model_id from models_final where pollutant = 'no2' and `domain` = 'spatial'), 50)) AS no2_50,
  anyIf(value, (model_id, kfz_pct) = ((select model_id from models_final where pollutant = 'no2' and `domain` = 'spatial'), 60)) AS no2_60,
  anyIf(value, (model_id, kfz_pct) = ((select model_id from models_final where pollutant = 'no2' and `domain` = 'spatial'), 70)) AS no2_70,
  anyIf(value, (model_id, kfz_pct) = ((select model_id from models_final where pollutant = 'no2' and `domain` = 'spatial'), 80)) AS no2_80,
  anyIf(value, (model_id, kfz_pct) = ((select model_id from models_final where pollutant = 'no2' and `domain` = 'spatial'), 90)) AS no2_90,
  anyIf(value, (model_id, kfz_pct) = ((select model_id from models_final where pollutant = 'no2' and `domain` = 'spatial'), 100)) AS no2_100,
  anyIf(value, (model_id, kfz_pct) = ((select model_id from models_final where pollutant = 'pm10' and `domain` = 'spatial'), 0)) AS pm10_0,
  anyIf(value, (model_id, kfz_pct) = ((select model_id from models_final where pollutant = 'pm10' and `domain` = 'spatial'), 10)) AS pm10_10,
  anyIf(value, (model_id, kfz_pct) = ((select model_id from models_final where pollutant = 'pm10' and `domain` = 'spatial'), 20)) AS pm10_20,
  anyIf(value, (model_id, kfz_pct) = ((select model_id from models_final where pollutant = 'pm10' and `domain` = 'spatial'), 30)) AS pm10_30,
  anyIf(value, (model_id, kfz_pct) = ((select model_id from models_final where pollutant = 'pm10' and `domain` = 'spatial'), 40)) AS pm10_40,
  anyIf(value, (model_id, kfz_pct) = ((select model_id from models_final where pollutant = 'pm10' and `domain` = 'spatial'), 50)) AS pm10_50,
  anyIf(value, (model_id, kfz_pct) = ((select model_id from models_final where pollutant = 'pm10' and `domain` = 'spatial'), 60)) AS pm10_60,
  anyIf(value, (model_id, kfz_pct) = ((select model_id from models_final where pollutant = 'pm10' and `domain` = 'spatial'), 70)) AS pm10_70,
  anyIf(value, (model_id, kfz_pct) = ((select model_id from models_final where pollutant = 'pm10' and `domain` = 'spatial'), 80)) AS pm10_80,
  anyIf(value, (model_id, kfz_pct) = ((select model_id from models_final where pollutant = 'pm10' and `domain` = 'spatial'), 90)) AS pm10_90,
  anyIf(value, (model_id, kfz_pct) = ((select model_id from models_final where pollutant = 'pm10' and `domain` = 'spatial'), 100)) AS pm10_100,
  anyIf(value, (model_id, kfz_pct) = ((select model_id from models_final where pollutant = 'pm25' and `domain` = 'spatial'), 0)) AS pm25_0,
  anyIf(value, (model_id, kfz_pct) = ((select model_id from models_final where pollutant = 'pm25' and `domain` = 'spatial'), 10)) AS pm25_10,
  anyIf(value, (model_id, kfz_pct) = ((select model_id from models_final where pollutant = 'pm25' and `domain` = 'spatial'), 20)) AS pm25_20,
  anyIf(value, (model_id, kfz_pct) = ((select model_id from models_final where pollutant = 'pm25' and `domain` = 'spatial'), 30)) AS pm25_30,
  anyIf(value, (model_id, kfz_pct) = ((select model_id from models_final where pollutant = 'pm25' and `domain` = 'spatial'), 40)) AS pm25_40,
  anyIf(value, (model_id, kfz_pct) = ((select model_id from models_final where pollutant = 'pm25' and `domain` = 'spatial'), 50)) AS pm25_50,
  anyIf(value, (model_id, kfz_pct) = ((select model_id from models_final where pollutant = 'pm25' and `domain` = 'spatial'), 60)) AS pm25_60,
  anyIf(value, (model_id, kfz_pct) = ((select model_id from models_final where pollutant = 'pm25' and `domain` = 'spatial'), 70)) AS pm25_70,
  anyIf(value, (model_id, kfz_pct) = ((select model_id from models_final where pollutant = 'pm25' and `domain` = 'spatial'), 80)) AS pm25_80,
  anyIf(value, (model_id, kfz_pct) = ((select model_id from models_final where pollutant = 'pm25' and `domain` = 'spatial'), 90)) AS pm25_90,
  anyIf(value, (model_id, kfz_pct) = ((select model_id from models_final where pollutant = 'pm25' and `domain` = 'spatial'), 100)) AS pm25_100,
  max(geometry) as geometry
from 
  grid_sim_long
cross join 
  (select max(date_time_forecast) as date_time_forecast from model_predictions_grid_sim) mpg 
left join 
  fairq_{{ mode }}features.coord_mapping_stadt_streets cmss on(grid_sim_long.element_nr=cmss.element_nr)
group by 
  grid_sim_long.element_nr
SETTINGS max_threads = 4, max_insert_threads = 4;
