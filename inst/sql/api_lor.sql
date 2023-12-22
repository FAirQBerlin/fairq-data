insert into api_lor (*)
with sel_coord_mapping_stadt_lor as (
  select
    PLR_ID, 
    stadt_x, 
    stadt_y
  from
    fairq_{{ mode }}features.coord_mapping_stadt_lor
),
lor_agg as (
  select
    model_id,           
    PLR_ID,
    toDate(date_time - interval 1 minute, 'Europe/Berlin') `date`,
    avg(value) AS value
  from 
    preds_grid_filled_with_null final
  inner join 
    sel_coord_mapping_stadt_lor on (x = stadt_x) and (y = stadt_y)
  where date_time > (select toStartOfDay(max(date_time_forecast)) from model_predictions_grid)
  and date_time < (select max(date_time) from model_predictions_grid)
  and model_id in (select model_id from models_final where domain = 'spatial')
  group by
    model_id,
    `date`,
    PLR_ID
  order by
    model_id,
    PLR_ID asc,
    `date` asc
),
lor_long as (
  select
    model_id,
    PLR_ID,
    -- min(date_time) as date_time_forecast,
    min(`date`) AS first_pred_date,
    max(`date`) AS last_pred_date,
    groupArray(COALESCE(round(value, 1), -999)) AS value
  from 
    lor_agg
  group by
    model_id,
    PLR_ID
)
select
  lor_long.PLR_ID AS PLR_ID,
  min(date_time_forecast) as date_time_forecast,
  min(first_pred_date) AS first_pred_date,
  max(last_pred_date) AS last_pred_date,
  anyIf(value, model_id = (select model_id from models_final where pollutant = 'no2' and `domain` = 'spatial')) AS no2,
  anyIf(value, model_id = (select model_id from models_final where pollutant = 'pm10' and `domain` = 'spatial')) AS pm10,
  anyIf(value, model_id = (select model_id from models_final where pollutant = 'pm25' and `domain` = 'spatial')) AS pm25,
  max(geometry) AS geometry
from 
  lor_long
left join 
  fairq_raw.stadtstruktur_berlin_lor sbl on lor_long.PLR_ID = sbl.PLR_ID
cross join 
  (select max(date_time_forecast) date_time_forecast from model_predictions_grid) mpg 
group by 
  PLR_ID
order by PLR_ID
SETTINGS max_threads = 4, max_insert_threads = 4;

