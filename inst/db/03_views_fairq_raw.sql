CREATE MATERIALIZED VIEW fairq_raw.dwd_forecasts_mv TO fairq_raw.dwd_forecasts_processed
(
    `date_time` DateTime('Europe/Berlin') COMMENT 'target hour of the forecast',
    `x` Int32,
    `y` Int32,
    `wind_direction` Nullable(UInt16) DEFAULT NULL COMMENT 'wind direction',
    `wind_speed` Nullable(Float64) DEFAULT NULL COMMENT 'wind speed',
    `precipitation` Nullable(Float64) DEFAULT NULL COMMENT 'precipitation',
    `temperature` Nullable(Float64) DEFAULT NULL COMMENT 'temperature',
    `relative_humidity` Nullable(UInt8) DEFAULT NULL COMMENT 'relative humidity',
    `cloud_cover` Nullable(UInt8) DEFAULT NULL COMMENT 'cloud cover',
    `pressure_msl` Nullable(Float64) DEFAULT NULL COMMENT 'air pressure',
    `sunshine` Nullable(UInt8) DEFAULT NULL COMMENT 'sunshine'
) as (
with dwd_int_coords as (
SELECT
    date_time,
    lat,
    lon,
    wind_direction,
    wind_speed,
    precipitation,
    temperature,
    relative_humidity,
    cloud_cover,
    pressure_msl,
    sunshine,
    toInt32(round(lat * 100000)) AS lat_int,
    toInt32(round(lon * 100000)) AS lon_int
FROM fairq_raw.dwd_forecasts
)
SELECT
    date_time,
    x,
    y,
    wind_direction,
    wind_speed,
    precipitation,
    temperature,
    relative_humidity,
    cloud_cover,
    pressure_msl,
    sunshine
FROM dwd_int_coords AS dfp
INNER JOIN fairq_features.mapping_reprojection using(lat_int, lon_int)
)
Comment 'maps dwd forecasts to their x, y coordinates. Note, that only the latest import into fairq_raw.dwd_forecasts is transferred via mv. This usually corresponds to the latest date_time_forecast.';
