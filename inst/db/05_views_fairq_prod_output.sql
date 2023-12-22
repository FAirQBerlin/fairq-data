-- selected_times_stations_ids
CREATE VIEW fairq_prod_output.selected_times_stations_ids
(
    `date_time` DateTime('Europe/Berlin'),
    `station_id` String,
    `model_id` UInt16
) AS
SELECT
  date_time,
  station_id,
  model_id
FROM 
  fairq_prod_features.date_time
cross join 
  (select distinct model_id from fairq_prod_output.model_predictions_stations_latest) mpsl
cross join 
  (select distinct station_id from fairq_prod_output.model_predictions_stations_latest) mpslid
WHERE date_time >= (SELECT max(date_time_forecast) FROM fairq_prod_output.model_predictions_temporal) 
AND date_time <= (SELECT max(date_time) AS max_date_time FROM fairq_prod_output.model_predictions_temporal);

-- model_predictions_grid_mv
CREATE MATERIALIZED VIEW fairq_prod_output.model_predictions_grid_mv 
TO fairq_prod_output.model_predictions_grid_history
AS
SELECT
    model_id,
    date_time_forecast,
    date_time,
    x,
    y,
    toUInt16(round(value)) AS value
FROM fairq_prod_output.model_predictions_grid;
