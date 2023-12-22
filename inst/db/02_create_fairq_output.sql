
-- fairq_output

create database if not exists fairq_output;

-- fairq_output.model_description definition

CREATE TABLE fairq_output.model_description
(
    `model_id` UInt16 COMMENT 'unique model id; applies to only one pollutant',
    `date_time_training_execution` DateTime COMMENT 'when the model was developed',
    `pollutant` String COMMENT 'no2,\n pm10 or pm 2.5',
    `model_name` String COMMENT 'A short description for the model,\n does not have to be unique; e.g. to see if it\'s a leave-one-station-out-CV model',
    `description` String COMMENT 'all relevant model parameters in json format',
    `model_object` String COMMENT 'xgboost model object in json format',
    `description_residuals` Nullable(String) COMMENT 'short description of the residuals model, if any',
    `model_object_residuals` Nullable(String) COMMENT 'model object of the residuals model, if any'
)
ENGINE = ReplacingMergeTree
ORDER BY model_id;

-- fairq_output.model_description_old definition

CREATE TABLE fairq_output.model_description_old
(

    `model_id` UInt16 COMMENT 'unique model id; applies to only one pollutant',

    `date_time_training_execution` DateTime COMMENT 'when the model was developed',

    `pollutant` String COMMENT 'no2,
 pm10 or pm 2.5',

    `model_name` String COMMENT 'A short description for the model,
 does not have to be unique; e.g. to see if it\'s a leave-one-station-out-CV model',

    `description` String COMMENT 'all relevant model parameters in json format',

    `model_object` String COMMENT 'xgboost model object in json format'
)
ENGINE = ReplacingMergeTree
ORDER BY model_id
SETTINGS index_granularity = 8192;

-- fairq_output.model_predictions_grid definition

CREATE TABLE fairq_output.model_predictions_grid
(

    `model_id` UInt16 COMMENT 'unique model id; applies to only one pollutant',

    `date_time_forecast` DateTime('Europe/Berlin') COMMENT 'timestamp when the prection was made',

    `date_time` DateTime('Europe/Berlin') COMMENT 'timestamp the prediction was made for',

    `x` UInt32 COMMENT 'x coordinate of prediction',

    `y` UInt32 COMMENT 'y coordinate of prediction',

    `value` Float64 COMMENT 'value of the prediction'
)
ENGINE = ReplacingMergeTree
ORDER BY (model_id,
 date_time_forecast,
 date_time,
 x,
 y)
SETTINGS index_granularity = 8192;

ALTER TABLE fairq_output.model_predictions_grid
    MODIFY TTL date_time + INTERVAL 1 MONTH DELETE;
    
ALTER TABLE fairq_output.model_predictions_grid
modify column value Decimal(4,1);

-- fairq_output.model_predictions_spatial_cv definition

CREATE TABLE fairq_output.model_predictions_spatial_cv
(

    `model_id` UInt16 COMMENT 'unique model id; applies to only one pollutant',

    `date_time` DateTime COMMENT 'timestamp the prediction was made for',

    `station_id` String COMMENT 'id of measuring station',

    `value` Float64 COMMENT 'value of the prediction'
)
ENGINE = ReplacingMergeTree
ORDER BY (model_id,
 date_time,
 station_id)
SETTINGS index_granularity = 8192;

-- fairq_output.model_predictions_stations definition

CREATE TABLE fairq_output.model_predictions_stations
(
    `model_id` UInt16 COMMENT 'unique model id; applies to only one pollutant',
    `date_time_forecast` DateTime('Europe/Berlin') COMMENT 'timestamp when the prection was made',
    `date_time` DateTime('Europe/Berlin') COMMENT 'timestamp the prediction was made for',
    `station_id` String COMMENT 'id of measuring station',
    `value` Float64 COMMENT 'value of the prediction'
)
ENGINE = ReplacingMergeTree
ORDER BY (model_id, date_time_forecast, date_time, station_id);

-- fairq_output.model_predictions_temporal definition

CREATE TABLE fairq_output.model_predictions_temporal
(

    `model_id` UInt16 COMMENT 'unique model id; applies to only one pollutant',

    `date_time_forecast` DateTime('Europe/Berlin') COMMENT 'timestamp when the prection was made',

    `date_time` DateTime('Europe/Berlin') COMMENT 'timestamp the prediction was made for',

    `station_id` String COMMENT 'id of measuring station',

    `value` Float64 COMMENT 'value of the prediction'
)
ENGINE = ReplacingMergeTree
ORDER BY (model_id,
 date_time_forecast,
 date_time,
 station_id)
SETTINGS index_granularity = 8192;

-- fairq_output.model_predictions_temporal_cv definition

CREATE TABLE fairq_output.model_predictions_temporal_cv
(

    `model_id` UInt16 COMMENT 'unique model id; applies to only one pollutant',

    `date_time_forecast` DateTime COMMENT 'timestamp when the prection was made',

    `date_time` DateTime COMMENT 'timestamp the prediction was made for',

    `station_id` String COMMENT 'id of measuring station',

    `value` Float64 COMMENT 'value of the prediction'
)
ENGINE = ReplacingMergeTree
ORDER BY (model_id,
 date_time_forecast,
 date_time,
 station_id)
SETTINGS index_granularity = 8192;

-- fairq_output.models_final definition

CREATE TABLE fairq_output.models_final
(

    `pollutant` String COMMENT 'no2,
 pm10 or pm 2.5',

    `domain` String COMMENT 'spatial or temporal',

    `model_id` UInt16 COMMENT 'unique model id; applies to only one pollutant'
)
ENGINE = ReplacingMergeTree
ORDER BY (pollutant,
 domain)
SETTINGS index_granularity = 8192;

-- fairq_output.traffic_model_description definition

CREATE TABLE fairq_output.traffic_model_description
(

    `model_id` UInt16 COMMENT 'unique model id',

    `date_time` DateTime('Europe/Berlin') COMMENT 'when the model was developed',

    `model_name` String COMMENT 'model name containing timestamp,
\n pollutant etc.',

    `depvar` String,

    `description` String COMMENT 'all relevant model parameters in json format'
)
ENGINE = ReplacingMergeTree
ORDER BY model_id
SETTINGS index_granularity = 8192
COMMENT 'model ids of the traffic model';

-- fairq_output.traffic_model_predictions_temporal_cv definition

CREATE TABLE fairq_output.traffic_model_predictions_temporal_cv
(

    `model_id` UInt16 COMMENT 'unique model id; applies to only one pollutant',

    `date_time` DateTime('Europe/Berlin') COMMENT 'timestamp when the prection was made',

    `x` UInt32 COMMENT 'x coordinate of prediction',

    `y` UInt32 COMMENT 'x coordinate of prediction',

    `value` Float64 COMMENT 'value of the prediction'
)
ENGINE = ReplacingMergeTree
ORDER BY (model_id,
 date_time,
 x,
 y)
SETTINGS index_granularity = 8192
COMMENT 'traffic predictions for the future at detectors (used to evaluate model)';

-- fairq_output.updated_table definition

CREATE TABLE fairq_output.updated_table
(

    `table` String COMMENT 'the tablename that was updated',

    `n_rows` Nullable(Int32) DEFAULT NULL,

    `date_time` DateTime('Europe/Berlin') DEFAULT now(),

    `query` Nullable(String) DEFAULT NULL
)
ENGINE = ReplacingMergeTree
ORDER BY (table,
 date_time)
SETTINGS index_granularity = 8192;

create table fairq_output.api_grid 
(
    `x` Int32,
    `y` Int32,
    `id` Int,
    `date_time_forecast` DateTime('Europe/Berlin'),
    `first_pred_date_time` DateTime('Europe/Berlin'),
    `last_pred_date_time` DateTime('Europe/Berlin'),
    `no2` Array(Float64),
    `pm10` Array(Float64),
    `pm25` Array(Float64)
   )
  Engine = ReplacingMergeTree order by (x, y, id) ;

CREATE TABLE fairq_output.preds_grid_filled_with_null
(
    `model_id` UInt16,
    `date_time` DateTime('Europe/Berlin'),
    `x` Int32,
    `y` Int32,
    `id` Int32,
    `value` Nullable(Float64)
)
ENGINE = ReplacingMergeTree
ORDER BY (model_id, date_time, x, y, id);


CREATE TABLE fairq_output.model_predictions_grid_latest
(
    `model_id` UInt16,
    `date_time` DateTime,
    `x` UInt32,
    `y` UInt32,
    `value` Float64
)
ENGINE = ReplacingMergeTree
order by (model_id, date_time, x, y);


create table fairq_output.api_streets
(
    `element_nr` String,
    `date_time_forecast` DateTime('Europe/Berlin'),
    `first_pred_date_time` DateTime('Europe/Berlin'),
    `last_pred_date_time` DateTime('Europe/Berlin'),
    `no2` Array(Float64),
    `pm10` Array(Float64),
    `pm25` Array(Float64),
    `geometry` String
    ) Engine = ReplacingMergeTree order by element_nr;

CREATE TABLE fairq_output.model_predictions_stations_latest
(
    `model_id` UInt16 COMMENT 'unique model id; applies to only one pollutant',
    `station_id` String COMMENT 'id of measuring station',
    `date_time` DateTime('Europe/Berlin') COMMENT 'timestamp the prediction was made for',
    `value` Float64 COMMENT 'value of the prediction'
)
ENGINE = ReplacingMergeTree
ORDER BY (model_id, station_id, date_time);


CREATE TABLE fairq_output.pred_stations_filled_with_null
(
    `model_id` UInt16,
    `date_time` DateTime('Europe/Berlin'),
    `station_id` String,
    `value` Nullable(Float64)
)
ENGINE = ReplacingMergeTree
ORDER BY (model_id, date_time, station_id)
SETTINGS index_granularity = 8192;

CREATE TABLE fairq_output.api_stations
(
    `station_id` String,
    `x` Int32,
    `y` Int32,
    `date_time_forecast` DateTime('Europe/Berlin'),
    `first_pred_date_time` DateTime('Europe/Berlin'),
    `last_pred_date_time` DateTime('Europe/Berlin'),
    `no2` Array(Float64),
    `pm10` Array(Float64),
    `pm25` Array(Float64)
)
ENGINE = ReplacingMergeTree
ORDER BY (station_id, x, y)
SETTINGS index_granularity = 8192;

CREATE TABLE fairq_output.model_predictions_thresholds
(
    `model_id` UInt16 COMMENT 'unique model id; applies to only one pollutant',
    `date_time_forecast` DateTime('Europe/Berlin') COMMENT 'timestamp when the prection was made',
    `date` Date COMMENT 'day the prediction was made for',
    `station_id` String COMMENT 'id of measuring station',
    `pollutant_limit` Float64 COMMENT 'underlying limit for the pollutant, e.g., as recommended by WHO',
    `tweak_value` Float64 COMMENT 'value that was added to the predictions to optimize classification as above/below limit',
    `pct_kfz_100` Float64 COMMENT 'prediction for 100% vehicles, i.e., no traffic reduction',
    `pct_kfz_90` Nullable(Float64) COMMENT 'prediction for 90% vehicles, i.e., 10% traffic reduction',
    `pct_kfz_80` Nullable(Float64) COMMENT 'prediction for 80% vehicles, i.e., 20% traffic reduction',
    `pct_kfz_70` Nullable(Float64) COMMENT 'prediction for 70% vehicles, i.e., 30% traffic reduction',
    `pct_kfz_60` Nullable(Float64) COMMENT 'prediction for 60% vehicles, i.e., 40% traffic reduction',
    `pct_kfz_50` Nullable(Float64) COMMENT 'prediction for 50% vehicles, i.e., 50% traffic reduction',
    `pct_kfz_40` Nullable(Float64) COMMENT 'prediction for 40% vehicles, i.e., 60% traffic reduction',
    `pct_kfz_30` Nullable(Float64) COMMENT 'prediction for 30% vehicles, i.e., 70% traffic reduction',
    `pct_kfz_20` Nullable(Float64) COMMENT 'prediction for 20% vehicles, i.e., 80% traffic reduction',
    `pct_kfz_10` Nullable(Float64) COMMENT 'prediction for 10% vehicles, i.e., 90% traffic reduction',
    `pct_kfz_0` Nullable(Float64) COMMENT 'prediction for 0% vehicles, i.e., 100% traffic reduction'
)
ENGINE = ReplacingMergeTree
ORDER BY (model_id, date_time_forecast, date, station_id)
SETTINGS index_granularity = 8192
COMMENT 'Predictions of pollutants given a specific traffic reduction. All predictions are daily averages.\nPredictions for a reduced traffic amount are only made if the daily average is above the pollutant limit.';


CREATE TABLE fairq_output.api_simulation
(
    `element_nr` String,
    `date_time_forecast` DateTime('Europe/Berlin'),
    `first_pred_date_time` Date,
    `last_pred_date_time` Date,
    `no2_0` Array(Float64),
    `no2_10` Array(Float64),
    `no2_20` Array(Float64),
    `no2_30` Array(Float64),
    `no2_40` Array(Float64),
    `no2_50` Array(Float64),
    `no2_60` Array(Float64),
    `no2_70` Array(Float64),
    `no2_80` Array(Float64),
    `no2_90` Array(Float64),
    `no2_100` Array(Float64),
    `pm10_0` Array(Float64),
    `pm10_10` Array(Float64),
    `pm10_20` Array(Float64),
    `pm10_30` Array(Float64),
    `pm10_40` Array(Float64),
    `pm10_50` Array(Float64),
    `pm10_60` Array(Float64),
    `pm10_70` Array(Float64),
    `pm10_80` Array(Float64),
    `pm10_90` Array(Float64),
    `pm10_100` Array(Float64),
    `pm25_0` Array(Float64),
    `pm25_10` Array(Float64),
    `pm25_20` Array(Float64),
    `pm25_30` Array(Float64),
    `pm25_40` Array(Float64),
    `pm25_50` Array(Float64),
    `pm25_60` Array(Float64),
    `pm25_70` Array(Float64),
    `pm25_80` Array(Float64),
    `pm25_90` Array(Float64),
    `pm25_100` Array(Float64),
    `geometry` String
)
ENGINE = ReplacingMergeTree
ORDER BY element_nr;

-- fairq_output.model_predictions_temporal_tweak_values definition
CREATE TABLE fairq_output.model_predictions_temporal_tweak_values
(
    `model_id` UInt16 COMMENT 'unique model id; applies to only one pollutant',
    `date_time_forecast` DateTime('Europe/Berlin') COMMENT 'timestamp when the prection was made',
    `date_time` DateTime('Europe/Berlin') COMMENT 'timestamp the prediction was made for',
    `station_id` String COMMENT 'id of measuring station',
    `value` Float64 COMMENT 'value of the prediction'
)
ENGINE = ReplacingMergeTree
ORDER BY (model_id,
 date_time_forecast,
 date_time,
 station_id)
SETTINGS index_granularity = 8192
COMMENT 'historical model predictions at stations to compute tweak values for limit value analysis';

-- fairq_output.model_predictions_passive_samplers definition

CREATE TABLE fairq_output.model_predictions_passive_samplers
(
    `model_id` UInt16 COMMENT 'unique model id; applies to only one pollutant',
    `date_time_forecast` DateTime('Europe/Berlin') COMMENT 'timestamp when the prection was made',
    `date_time` DateTime('Europe/Berlin') COMMENT 'timestamp the prediction was made for',
    `x` UInt32 COMMENT 'x coordinate of prediction',
    `y` UInt32 COMMENT 'y coordinate of prediction',
    `value` Float64 COMMENT 'value of the prediction'
)
ENGINE = ReplacingMergeTree
ORDER BY (model_id,
 date_time_forecast,
 date_time,
x,
y)
SETTINGS index_granularity = 8192
COMMENT 'contains pollution predictions in cells with passive samplers for the whole year 2022';

-- fairq_output.cap_values definition

CREATE TABLE fairq_output.cap_values
(
    `pollutant` String COMMENT 'Specifies the pollutant',
    `cap_value_outlier` Int16 COMMENT 'cap values (99.9 percentiles), used to remove outliers before modelling and for goodness of fit dashboards',
    `cap_value_training` Int16 COMMENT 'cap values (99.7 percentiles), used to remove very large values from training data'
)
ENGINE = ReplacingMergeTree
ORDER BY pollutant
SETTINGS index_granularity = 8192;

-- api_lor 
CREATE TABLE fairq_output.api_lor
(
    `PLR_ID` String,
    `date_time_forecast` DateTime('Europe/Berlin'),
    `first_pred_date_time` Date,
    `last_pred_date_time` Date,
    `no2` Array(Float64),
    `pm10` Array(Float64),
    `pm25` Array(Float64),
    `geometry` String
)
ENGINE = ReplacingMergeTree
ORDER BY PLR_ID;


-- model predictions grid history
CREATE TABLE fairq_output.model_predictions_grid_history 
(
    `model_id` UInt16 CODEC(Delta, ZSTD),
    `date_time_forecast` DateTime('Europe/Berlin') CODEC(DoubleDelta, ZSTD),
    `date_time` DateTime('Europe/Berlin') CODEC(DoubleDelta, ZSTD),
    `x` UInt32 CODEC(DoubleDelta, ZSTD),
    `y` UInt32 CODEC(DoubleDelta, ZSTD),
    `value` UInt16 CODEC(Delta, ZSTD)
)
ENGINE = ReplacingMergeTree
ORDER BY (model_id, date_time_forecast, date_time, x, y);

ALTER TABLE fairq_output.model_predictions_grid_history
    MODIFY TTL date_time + INTERVAL 12 MONTH DELETE;

CREATE TABLE fairq_output.model_predictions_stations_lags
(
    `model_id` UInt16 COMMENT 'unique model id; applies to only one pollutant',
    `date_time_forecast` DateTime('Europe/Berlin') COMMENT 'timestamp when the prection was made',
    `date_time` DateTime('Europe/Berlin') COMMENT 'timestamp the prediction was made for',
    `station_id` String COMMENT 'id of measuring station',
    `value` Float64 COMMENT 'value of the prediction'
)
ENGINE = ReplacingMergeTree
ORDER BY (model_id, date_time, station_id)
SETTINGS index_granularity = 8192
COMMENT 'table for historical predictions at stations with a recent model, used as average for grid-predictions';

CREATE TABLE fairq_output.selected_times_coords_ids
(
    `date_time` DateTime('Europe/Berlin'),
    `x` Int32,
    `y` Int32,
    `id` Int32,
    `model_id` UInt16
)
ENGINE = ReplacingMergeTree
ORDER BY (date_time, x, y, id, model_id);

CREATE TABLE fairq_output.preds_grid_sim_filled_with_null
(
    `model_id` UInt16 COMMENT 'unique model id; applies to only one pollutant',
    `date_time` DateTime('Europe/Berlin') COMMENT 'timestamp when the prection was made',
    `x` Int32 COMMENT 'grid x coordinate',
    `y` Int32 COMMENT 'grid y coordinate',
    `element_nr` String COMMENT 'element nr of the street',
    `kfz_pct` UInt8 COMMENT 'percentage of traffic of the prediction, 100 = no reduction, 0 = no traffic',
    `value` Nullable(Decimal(4, 1)) COMMENT 'air pollution value of the prediction'
)
ENGINE = ReplacingMergeTree
ORDER BY (model_id, date_time, x, y, kfz_pct);


CREATE TABLE fairq_output.model_predictions_grid_sim
(
    `model_id` UInt16 COMMENT 'unique model id; applies to only one pollutant',
    `date_time_forecast` DateTime('Europe/Berlin') COMMENT 'timestamp when the prection was made',
    `date_time` DateTime('Europe/Berlin') COMMENT 'timestamp the prediction was made for',
    `x` UInt32 COMMENT 'x coordinate of prediction',
    `y` UInt32 COMMENT 'y coordinate of prediction',
    `kfz_pct` UInt8 COMMENT 'percentage of kfz adjustment',
    `value` Decimal(4, 1) COMMENT 'value of the prediction'
)
ENGINE = ReplacingMergeTree
ORDER BY (model_id, date_time_forecast, date_time, x, y, kfz_pct);


CREATE TABLE fairq_output.model_predictions_grid_sim_latest
(
    `model_id` UInt16 COMMENT 'unique model id; applies to only one pollutant',
    `date_time` DateTime('Europe/Berlin') COMMENT 'timestamp the prediction was made for',
    `x` UInt32 COMMENT 'x coordinate of prediction',
    `y` UInt32 COMMENT 'y coordinate of prediction',
    `kfz_pct` UInt8 COMMENT 'kfz percentage of the simulation',
    `value` Decimal(4, 1) COMMENT 'pollution value of the prediction'
)
ENGINE = ReplacingMergeTree
ORDER BY (model_id, date_time, x, y, kfz_pct);

CREATE TABLE fairq_output.selected_times_coords_ids_pct
(
    `date_time` DateTime('Europe/Berlin'),
    `model_id` UInt16,
    `x` Int32,
    `y` Int32,
    `element_nr` String,
    `kfz_pct` UInt8
)
ENGINE = ReplacingMergeTree
ORDER BY (date_time, model_id, x, y, element_nr, kfz_pct);
