INSERT INTO fairq_output.cap_values (pollutant, cap_value_outlier, cap_value_training)
VALUES ('no2', 119, 109);
INSERT INTO fairq_output.cap_values (pollutant, cap_value_outlier, cap_value_training)
VALUES ('pm10', 112, 84);
INSERT INTO fairq_output.cap_values (pollutant, cap_value_outlier, cap_value_training)
VALUES ('pm25', 66, 57);

-- initialize mv to grid_history
insert into fairq_output.model_predictions_grid_history
select 
  model_id,
  date_time_forecast,
  date_time,
  x,
  y,
  toUInt16(round(value)) value
from 
fairq_output.model_predictions_grid;
