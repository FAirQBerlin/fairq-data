insert into api_streets (*)
with sel_coord_mapping_stadt_streets as (
  select
    element_nr, 
    geometry, 
    stadt_x, 
    stadt_y
  from
    fairq_{{ mode }}features.coord_mapping_stadt_streets
  where element_nr in (select element_nr from fairq_raw.stadtstruktur_network_streets where strassenklasse1 in ('0', 'I', 'II', 'III', 'IV'))
),
streets_agg as (
  select
    model_id,           
    element_nr,
    date_time,
    avg(value) AS value,
    max(geometry) AS geometry
  from 
    preds_grid_filled_with_null final
  inner join 
    sel_coord_mapping_stadt_streets on (x = stadt_x) and (y = stadt_y)
  where date_time >= (select max(date_time_forecast) from model_predictions_grid)
  and model_id in (select model_id from models_final where domain = 'spatial')
  group by
    model_id,
    date_time,
    element_nr
  order by
    model_id,
    element_nr asc,
    date_time asc
),
streets_long as (
  select
    model_id,
    element_nr,
    min(date_time) as date_time_forecast,
    min(date_time) AS first_pred_date_time,
    max(date_time) AS last_pred_date_time,
    groupArray(COALESCE(round(value, 1), -999)) AS value,
    max(geometry) AS geometry
  from 
    streets_agg
  group by
    model_id,
    element_nr
)
select
  element_nr,
  min(date_time_forecast) as date_time_forecast,
  min(first_pred_date_time) AS first_pred_date_time,
  max(last_pred_date_time) AS last_pred_date_time,
  anyIf(value, model_id = (select model_id from models_final where pollutant = 'no2' and `domain` = 'spatial')) AS no2,
  anyIf(value, model_id = (select model_id from models_final where pollutant = 'pm10' and `domain` = 'spatial')) AS pm10,
  anyIf(value, model_id = (select model_id from models_final where pollutant = 'pm25' and `domain` = 'spatial')) AS pm25,
  max(geometry) AS geometry
from 
  streets_long
group by 
  element_nr
SETTINGS max_threads = 4, max_insert_threads = 4;
