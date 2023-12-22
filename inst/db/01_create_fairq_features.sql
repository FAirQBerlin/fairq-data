-- fairq_features

create database if not exists fairq_features;

-- fairq_features.buildings definition

CREATE TABLE fairq_features.buildings
(

    `id` Int32,

    `x` Int32,

    `y` Int32,

    `density` Float64,

    `height` Float64
)
ENGINE = ReplacingMergeTree
ORDER BY id
SETTINGS index_granularity = 8192;

-- fairq_features.cams_old_rescaled definition

CREATE TABLE fairq_features.cams_old_rescaled
(

    `date_time` DateTime('Europe/Berlin') COMMENT 'target hour of the forecast',

    `date_forecast` DateTime('Europe/Berlin') COMMENT 'date when the forecast was made',

    `lat` Float32 COMMENT 'latitude',

    `lon` Float32 COMMENT 'longitude',

    `no2` Float32 COMMENT 'Nitrogen dioxide - rescaled and interpolated (linear)',

    `pm25` Float32 COMMENT 'Particulate matter < 2.5 µm (PM2.5) - rescaled',

    `pm10` Float32 COMMENT 'Particulate matter < 10 µm (PM10) - rescaled',

    `lat_int` Int32 COMMENT 'latitude integer (factor 100000)',

    `lon_int` Int32 COMMENT 'longitude integer (factor 100000)'
)
ENGINE = ReplacingMergeTree
PRIMARY KEY (date_time,
 date_forecast,
 lat,
 lon)
ORDER BY (date_time,
 date_forecast,
 lat,
 lon)
SETTINGS index_granularity = 8192
COMMENT 'CAMS data from the "old" API (CAMS global) with rescaled values';

-- fairq_features.coord_mapping_emissions_stadt definition

CREATE TABLE fairq_features.coord_mapping_emissions_stadt
(

    `stadt_x` Int32 COMMENT 'mapping stadt grid x coordinate',

    `stadt_y` Int32 COMMENT 'mapping stadt grid y coordinate',

    `emissions_x` Int32 COMMENT 'mapping emissions x coordinate',

    `emissions_y` Int32 COMMENT 'mapping emissions y coordinate',

    `idnr_1km` Int64 COMMENT 'id emissions'
)
ENGINE = ReplacingMergeTree
ORDER BY (stadt_x,
 stadt_y)
SETTINGS index_granularity = 8192
COMMENT 'Code to fill this table can be found at https://github.com/INWT/fairq-features-stadtstruktur/blob/main/inst/db/schema.sql';

-- fairq_features.coord_mapping_stadt_cams definition

CREATE TABLE fairq_features.coord_mapping_stadt_cams
(

    `cams_x` Int32 COMMENT 'mapping cams x coordinate',

    `cams_y` Int32 COMMENT 'mapping cams y coordinate',

    `stadt_x` Int32 COMMENT 'mapping stadtstruktur x coordinate',

    `stadt_y` Int32 COMMENT 'mapping stadtstruktur y coordinate'
)
ENGINE = ReplacingMergeTree
ORDER BY (stadt_x,
 stadt_y)
SETTINGS index_granularity = 8192
COMMENT 'Code to fill this table: https://github.com/INWT/fairq-model/blob/main/inst/db/schema.sql';

-- fairq_features.coord_mapping_stadt_det definition

CREATE TABLE fairq_features.coord_mapping_stadt_det
(

    `mq_name` String,

    `det_x` Int32 COMMENT 'mapping traffic detectors x coordinate',

    `det_y` Int32 COMMENT 'mapping traffic detectors y coordinate',

    `stadt_x` Int32 COMMENT 'mapping stadtstruktur x coordinate',

    `stadt_y` Int32 COMMENT 'mapping stadtstruktur y coordinate'
)
ENGINE = ReplacingMergeTree
ORDER BY mq_name
SETTINGS index_granularity = 8192
COMMENT 'Code to fill this table: https://github.com/INWT/fairq-model-traffic-detectors/blob/main/inst/db/schema.sql';

-- fairq_features.coord_mapping_stadt_dwd definition

CREATE TABLE fairq_features.coord_mapping_stadt_dwd
(

    `stadt_x` Int32 COMMENT 'mapping stadtstruktur x coordinate',

    `stadt_y` Int32 COMMENT 'mapping stadtstruktur y coordinate',

    `dwd_x` Int32 COMMENT 'mapping dwd x coordinate',

    `dwd_y` Int32 COMMENT 'mapping dwd y coordinate'
)
ENGINE = ReplacingMergeTree
ORDER BY (stadt_x,
 stadt_y)
SETTINGS index_granularity = 8192
COMMENT 'code to fill this table can be found in https://github.com/INWT/fairq-model-traffic-detectors/blob/main/inst/db/schema.sql';

-- fairq_features.coord_mapping_stadt_station definition

CREATE TABLE fairq_features.coord_mapping_stadt_station
(

    `station_id` String,

    `station_x` Int32 COMMENT 'mapping traffic detectors x coordinate',

    `station_y` Int32 COMMENT 'mapping traffic detectors y coordinate',

    `stadt_x` Int32 COMMENT 'mapping stadtstruktur x coordinate',

    `stadt_y` Int32 COMMENT 'mapping stadtstruktur y coordinate'
)
ENGINE = ReplacingMergeTree
ORDER BY station_id
SETTINGS index_granularity = 8192
COMMENT 'Code to fill this table can be found at https://github.com/INWT/fairq-gap-filling/blob/main/inst/db/schema.sql';

-- fairq_features.coord_mapping_stations_cams definition

CREATE TABLE fairq_features.coord_mapping_stations_cams
(

    `station_id` String COMMENT 'station id',

    `cams_x` Int32 COMMENT 'x coord of cams',

    `cams_y` Int32 COMMENT 'y coord of cams',

    `station_x` Int32 COMMENT 'x coord messstation',

    `station_y` Int32 COMMENT 'y coord messstation'
)
ENGINE = ReplacingMergeTree
ORDER BY station_id
SETTINGS index_granularity = 8192
COMMENT 'code to fill table https://github.com/INWT/fairq-gap-filling/blob/main/inst/db/schema.sql';

-- fairq_features.coord_stadt_all definition

CREATE TABLE fairq_features.coord_stadt_all
(

    `x` Int32,

    `y` Int32
)
ENGINE = ReplacingMergeTree
ORDER BY (x,
 y)
SETTINGS index_granularity = 8192
COMMENT 'Code to fill this table can be found at https://github.com/INWT/fairq-gap-filling/blob/main/inst/db/schema.sql';

-- fairq_features.dwd_observations_filled definition

CREATE TABLE fairq_features.dwd_observations_filled
(

    `date_time` DateTime COMMENT 'time of measurement',

    `x` Int32 COMMENT 'mapping of latitude',

    `y` Int32 COMMENT 'mapping of longitude',

    `wind_direction` Nullable(UInt16) DEFAULT NULL COMMENT 'wind direction',

    `wind_speed` Nullable(Float64) DEFAULT NULL COMMENT 'wind speed',

    `precipitation` Nullable(Float64) DEFAULT NULL COMMENT 'precipitation',

    `temperature` Nullable(Float64) DEFAULT NULL COMMENT 'temperature',

    `cloud_cover` Nullable(UInt8) DEFAULT NULL COMMENT 'cloud cover',

    `pressure_msl` Nullable(Float64) DEFAULT NULL COMMENT 'air pressure',

    `sunshine` Nullable(UInt8) DEFAULT NULL COMMENT 'sunshine',

    `wind_direction_filled` Nullable(UInt16) DEFAULT NULL COMMENT 'wind direction',

    `wind_speed_filled` Nullable(Float64) DEFAULT NULL COMMENT 'wind speed',

    `precipitation_filled` Nullable(Float64) DEFAULT NULL COMMENT 'precipitation',

    `temperature_filled` Nullable(Float64) DEFAULT NULL COMMENT 'temperature',

    `cloud_cover_filled` Nullable(UInt8) DEFAULT NULL COMMENT 'cloud cover',

    `pressure_msl_filled` Nullable(Float64) DEFAULT NULL COMMENT 'air pressure',

    `sunshine_filled` Nullable(UInt8) DEFAULT NULL COMMENT 'sunshine'
)
ENGINE = ReplacingMergeTree
ORDER BY (x,
 y,
 date_time)
SETTINGS index_granularity = 8192;

-- fairq_features.holidays definition

CREATE TABLE fairq_features.holidays
(

    `date_time` DateTime('Europe/Berlin') COMMENT 'target hour of the forecast',

    `type_school_holiday` Nullable(String) COMMENT 'type of school holiday,
 when NULL normal working day',

    `is_public_holiday` UInt8 COMMENT 'is the target hour / day a public holiday'
)
ENGINE = ReplacingMergeTree
PRIMARY KEY date_time
ORDER BY date_time
SETTINGS index_granularity = 8192;

-- fairq_features.land_use definition

CREATE TABLE fairq_features.land_use
(

    `id` Int32,

    `x` Int32,

    `y` Int32,

    `gewaesser` Float64,

    `grauflaeche` Float64,

    `gruenflaeche` Float64,

    `infrastruktur` Float64,

    `mischnutzung` Float64,

    `wald` Float64,

    `wohnnutzung` Float64
)
ENGINE = ReplacingMergeTree
ORDER BY id
SETTINGS index_granularity = 8192;

-- fairq_features.mapping_reprojection definition

CREATE TABLE fairq_features.mapping_reprojection
(

    `lat_int` Int32,

    `lon_int` Int32,

    `x` Int32,

    `y` Int32
)
ENGINE = ReplacingMergeTree
ORDER BY (lat_int,
 lon_int)
SETTINGS index_granularity = 8192;

-- fairq_features.mapping_stations_dwd definition

CREATE TABLE fairq_features.mapping_stations_dwd
(

    `station_id` String,

    `dwd_x` Int32,

    `dwd_y` Int32,

    `station_x` Int32,

    `station_y` Int32
)
ENGINE = ReplacingMergeTree
ORDER BY station_id
SETTINGS index_granularity = 8192;

-- fairq_features.messstationen_filled definition

CREATE TABLE fairq_features.messstationen_filled
(

    `date_time` DateTime('Europe/Berlin'),

    `station_id` String,

    `x` Int32 COMMENT 'mapping of latitude',

    `y` Int32 COMMENT 'mapping of longitude',

    `station_type` Nullable(String) COMMENT 'type of measuring station',

    `pm10` Nullable(Int16) COMMENT 'Feinstaub (PM10) in Mikrogramm pro Kubikmeter',

    `pm25` Nullable(Int16) COMMENT 'Feinstaub (PM2,
 5) in Mikrogramm pro Kubikmeter',

    `no2` Nullable(Int16) COMMENT 'Stickstoffdioxid in Mikrogramm pro Kubikmeter',

    `pm10_filled` Nullable(Int16) COMMENT 'Feinstaub (PM10) in Mikrogramm pro Kubikmeter,
 gap filled',

    `pm25_filled` Nullable(Int16) COMMENT 'Feinstaub (PM2,
5) in Mikrogramm pro Kubikmeter,
 gap filled',

    `no2_filled` Nullable(Int16) COMMENT 'Stickstoffdioxid in Mikrogramm pro Kubikmeter,
 gap filled'
)
ENGINE = ReplacingMergeTree
ORDER BY (station_id,
 date_time)
SETTINGS index_granularity = 8192;

-- fairq_features.streets definition

CREATE TABLE fairq_features.streets
(

    `id` Int32,

    `x` Int32,

    `y` Int32,

    `strassenklasse_0` Float64,

    `strassenklasse_I` Float64,

    `strassenklasse_II` Float64,

    `strassenklasse_III` Float64,

    `strassenklasse_IV` Float64,

    `strassenklasse_V` Float64
)
ENGINE = ReplacingMergeTree
ORDER BY id
SETTINGS index_granularity = 8192;

-- fairq_features.traffic_intensity definition

CREATE TABLE fairq_features.traffic_intensity
(

    `id` Int32,

    `x` Int32,

    `y` Int32,

    `traffic_intensity_kfz` Float64,

    `traffic_intensity_lkw` Float64
)
ENGINE = ReplacingMergeTree
ORDER BY id
SETTINGS index_granularity = 8192;

-- fairq_features.traffic_model_predictions_2019 definition

CREATE TABLE fairq_features.traffic_model_predictions_2019
(

    `model_id` UInt16 COMMENT 'unique model id; applies to only one pollutant',

    `date_time` DateTime COMMENT 'timestamp the prediction was made for',

    `x` UInt32 COMMENT 'x coordinate of prediction',

    `y` UInt32 COMMENT 'x coordinate of prediction',

    `value` UInt16 COMMENT 'value of the prediction'
)
ENGINE = ReplacingMergeTree
ORDER BY (model_id,
 date_time,
 x,
 y)
SETTINGS index_granularity = 8192
COMMENT 'contains traffic predictions over the whole grid for 2019 (used to compute rescaling factors based on traffic volume)';

-- fairq_features.traffic_model_predictions_grid definition

CREATE TABLE fairq_features.traffic_model_predictions_grid
(

    `model_id` UInt16 COMMENT 'unique model id; applies to only one pollutant',

    `date_time` DateTime COMMENT 'timestamp the prediction was made for',

    `x` UInt32 COMMENT 'x coordinate of prediction',

    `y` UInt32 COMMENT 'x coordinate of prediction',

    `value` UInt16 COMMENT 'value of the prediction'
)
ENGINE = ReplacingMergeTree
ORDER BY (model_id,
 date_time,
 x,
 y)
SETTINGS index_granularity = 8192
COMMENT 'contains traffic predictions for the future over whole grid (used as input for pollution model to make predictions over whole grid)';

-- fairq_features.traffic_model_predictions_stations definition

CREATE TABLE fairq_features.traffic_model_predictions_stations
(

    `model_id` UInt16 COMMENT 'unique model id; applies to only one pollutant',

    `date_time` DateTime COMMENT 'timestamp the prediction was made for',

    `x` UInt32 COMMENT 'x coordinate of prediction',

    `y` UInt32 COMMENT 'x coordinate of prediction',

    `value` UInt16 COMMENT 'value of the prediction'
)
ENGINE = ReplacingMergeTree
ORDER BY (model_id,
 date_time,
 x,
 y)
SETTINGS index_granularity = 8192
COMMENT 'traffic predictions in the grid cells containing measuring stations for the whole time period (used to train pollutant model)';

-- fairq_features.traffic_model_scaling definition

CREATE TABLE fairq_features.traffic_model_scaling
(

    `x` UInt32 COMMENT 'x coordinate of prediction',

    `y` UInt32 COMMENT 'y coordinate of prediction',

    `kfz_per_24h` Float64 COMMENT 'number of kfz per day from Verkehrsmengenkarte (traffic_volume)',

    `kfz_per_24h_pred` Float64 COMMENT 'average number of kfz per day from traffic model predictions',

    `scaling` Float64 COMMENT 'kfz_per_24h / kfz_per_24h_pred,
 kept the range of [0.2,
 5.0] and zeros are allowed'
)
ENGINE = ReplacingMergeTree
ORDER BY (x,
 y)
SETTINGS index_granularity = 8192
COMMENT 'code to fill this table can be found at https://github.com/INWT/fairq-model-traffic-detectors/blob/main/inst/db/schema.sql';

-- fairq_features.traffic_volume definition

CREATE TABLE fairq_features.traffic_volume
(

    `id` Int32,

    `x` Int32,

    `y` Int32,

    `kfz_per_24h` Int32
)
ENGINE = ReplacingMergeTree
ORDER BY id
SETTINGS index_granularity = 8192;

-- fairq_features.trees definition

CREATE TABLE fairq_features.trees
(

    `id` Int32,

    `x` Int32,

    `y` Int32,

    `count` Float64,

    `age` Nullable(Float64),

    `height` Nullable(Float64)
)
ENGINE = ReplacingMergeTree
ORDER BY id
SETTINGS index_granularity = 8192;

-- fairq_features.updated_table definition

CREATE TABLE fairq_features.updated_table
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


CREATE TABLE fairq_features.coords_grid_batches
(
    `id` Int32,
    `x` Int32,
    `y` Int32,
    `batch` Int32
)
ENGINE = ReplacingMergeTree
ORDER BY (id, x, y);


CREATE TABLE fairq_features.coords_grid_sim_batches
(
    `x` Int32,
    `y` Int32,
    `element_nr` String,
    `strassenname` String,
    `batch` UInt8
)
ENGINE = ReplacingMergeTree
ORDER BY (x, y);


-- fairq_features.coord_stadt_lor
CREATE TABLE fairq_features.coord_mapping_stadt_lor
(
    `PLR_ID` String COMMENT 'id of LOR Planungsraum - 8 digits',
    `stadt_x` Int32 COMMENT 'mapping stadt grid x coordinate',
    `stadt_y` Int32 COMMENT 'mapping stadt grid y coordinate'
)
ENGINE = ReplacingMergeTree()
ORDER BY (PLR_ID, stadt_x, stadt_y);

-- fairq_features.coord_stadt_streets
CREATE TABLE fairq_features.coord_mapping_stadt_streets
(
    `element_nr` String COMMENT 'id of street section of Detailnetz Gesamt',
    `geometry` String COMMENT 'coordinates of street section as LINESTRING geojson format in EPSG:25833',
    `stadt_x` Int32 COMMENT 'mapping stadt grid x coordinate',
    `stadt_y` Int32 COMMENT 'mapping stadt grid y coordinate'
)
ENGINE = ReplacingMergeTree()
ORDER BY (element_nr, stadt_x, stadt_y);

-- fairq_features.coord_stadt_berlin
CREATE TABLE fairq_features.coord_stadt_berlin
(
    `id` Int32,
    `x` Int32,
    `y` Int32
)
ENGINE = ReplacingMergeTree()
ORDER BY id;


CREATE TABLE fairq_features.cams_all_latest_filled
(
    `date_time` DateTime('Europe/Berlin'),
    `lat_int` Int32,
    `lon_int` Int32,
    `no2` Nullable(Float32),
    `pm25` Nullable(Float32),
    `pm10` Nullable(Float32),
    `no2_filled` Float32,
    `pm25_filled` Float32,
    `pm10_filled` Float32
)
ENGINE = ReplacingMergeTree
ORDER BY (lat_int, lon_int, date_time);


CREATE TABLE fairq_features.statdstruktur_features
(
    `x` Int32,
    `y` Int32,
    `grauflaeche` Float64,
    `gewaesser` Float64,
    `gruenflaeche` Float64,
    `infrastruktur` Float64,
    `mischnutzung` Float64,
    `wald` Float64,
    `wohnnutzung` Float64,
    `density` Float64,
    `traffic_intensity_kfz` Float64,
    `nox_h_15` Float64,
    `nox_i_15` Float64,
    `nox_v_gn15` Float64,
    `pm10_i_15` Float64
)
ENGINE = ReplacingMergeTree
ORDER BY (x, y);

-- fairq_features.traffic_models_final definition

CREATE TABLE fairq_features.traffic_models_final
(

    `depvar` String COMMENT 'q_kfz or v_kfz',

    `model_id` UInt16 COMMENT 'unique model id; applies to only one depvar'
)
ENGINE = ReplacingMergeTree
ORDER BY (depvar);

-- fairq_features.mapping_reprojection definition
CREATE TABLE fairq_features.coord_mapping_stadt_reprojection
(
    `id` Int32,
    `x` Int32,
    `y` Int32,
    `lon_int` Int32,
    `lat_int` Int32
)
ENGINE = ReplacingMergeTree()
ORDER BY (id);

-- fairq_features.coord_mapping_stadt_passive definition

CREATE TABLE fairq_features.coord_mapping_stadt_passive
(
    `id` String,
    `stadt_x` Int32,
    `stadt_y` Int32
)
ENGINE = ReplacingMergeTree
ORDER BY id;

-- fairq_features.traffic_model_predictions_passive_samplers definition

CREATE TABLE fairq_features.traffic_model_predictions_passive_samplers
(
    `model_id` UInt16 COMMENT 'unique model id; applies to only one pollutant',
    `date_time` DateTime COMMENT 'timestamp the prediction was made for',
    `x` UInt32 COMMENT 'x coordinate of prediction',
    `y` UInt32 COMMENT 'y coordinate of prediction',
    `value` Float64 COMMENT 'value of the prediction'
)
ENGINE = ReplacingMergeTree
ORDER BY (model_id,
 date_time,
 x,
 y)
SETTINGS index_granularity = 8192
COMMENT 'contains traffic predictions in cells with passive samplers for the whole year 2022';

CREATE TABLE fairq_features.stations_for_predictions
(
    `station_id` String,
    `id` String,
    `is_active` Bool
)
ENGINE = ReplacingMergeTree
ORDER BY station_id
SETTINGS index_granularity = 8192
Comment 'table controlling whether the station is_active, only active stations are used for fairq-model predictions and the current gap-filling. For training all stations are used.';


CREATE TABLE fairq_features.scaling_kfz_station
(
    `kkfz_per_24h` Int Comment '1000 kfz_per_24h, number of kfz per 24h in thousands, rounded to integer',
    `scaling_stadtrand` Float64 Comment 'Scaling factor between 0 and 1, defining how much the kkfz value is a "stadtrand station" with 0 kfz'
)
ENGINE = ReplacingMergeTree
ORDER BY kkfz_per_24h
COMMENT 'Table to map the kfz per 24h to a scaling factor, used to calculate weighted averages of station pollution data';

