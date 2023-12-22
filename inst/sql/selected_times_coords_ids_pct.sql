insert into selected_times_coords_ids_pct
SELECT
    date_time,
    model_ids.model_id AS model_id,
    coords_streets_sim.x AS x,
    coords_streets_sim.y AS y,
    coords_streets_sim.element_nr AS element_nr,
    pct.kfz_pct as kfz_pct
FROM  fairq_{{ mode }}features.date_time
CROSS JOIN
(
    SELECT
        element_nr,
        x,
        y
    FROM  fairq_{{ mode }}features.coords_grid_sim_batches
) AS coords_streets_sim
CROSS JOIN
(
    SELECT model_id
    FROM models_final
    WHERE domain = 'spatial'
) AS model_ids
CROSS JOIN
(
  select distinct kfz_pct from model_predictions_grid_sim_latest
) AS pct
WHERE (date_time >= (
    SELECT max(date_time_forecast)
    FROM model_predictions_grid_sim
)) AND (date_time <= (
    SELECT max(date_time) AS max_date_time
    FROM model_predictions_grid_sim
))
