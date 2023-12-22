insert into selected_times_coords_ids
SELECT
    date_time,
    coords_berlin.x AS x,
    coords_berlin.y AS y,
    coords_berlin.id AS id,
    model_ids.model_id AS model_id
FROM  fairq_{{ mode }}features.date_time
CROSS JOIN
(
    SELECT
        id,
        x,
        y
    FROM fairq_{{ mode }}features.coord_stadt_berlin
) AS coords_berlin
CROSS JOIN
(
    SELECT model_id
    FROM models_final
    WHERE domain = 'spatial'
) AS model_ids
WHERE (date_time >= (
    SELECT max(date_time_forecast)
    FROM model_predictions_grid
)) AND (date_time <= (
    SELECT max(date_time) AS max_date_time
    FROM model_predictions_grid
));
