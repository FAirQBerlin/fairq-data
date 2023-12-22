CREATE VIEW fairq_prod_features.cams_all
(

    `date_time` DateTime('Europe/Berlin'),

    `date_forecast` DateTime('Europe/Berlin'),

    `no2` Float32,

    `pm25` Float32,

    `pm10` Float32,

    `lat_int` Int32,

    `lon_int` Int32
) AS
SELECT
    toDateTime(date_time,
 'Europe/Berlin') AS date_time,

    toDateTime(date_forecast,
 'Europe/Berlin') AS date_forecast,

    multiIf(no2 < 0,
 0.,
 no2) AS no2,

    multiIf(pm25 < 0,
 0.,
 pm25) AS pm25,

    multiIf(pm10 < 0,
 0.,
 pm10) AS pm10,

    cmc.cams_lat_int AS lat_int,

    cmc.cams_lon_int AS lon_int
FROM fairq_prod_features.cams_old_rescaled AS cor
LEFT JOIN fairq_prod_features.coord_mapping_cams AS cmc ON (cmc.cams_old_lat_int = cor.lat_int) AND (cmc.cams_old_lon_int = cor.lon_int)
UNION ALL
SELECT
    toDateTime(date_time,
 'Europe/Berlin') AS date_time,

    toDateTime(date_forecast,
 'Europe/Berlin') AS date_forecast,

    no2,

    pm25,

    pm10,

    lat_int,

    lon_int
FROM fairq_raw.cams_processed;

-- fairq_prod_features.coord_mapping_cams source

CREATE VIEW fairq_prod_features.coord_mapping_cams
(

    `cams_lat_int` Int32,

    `cams_lon_int` Int32,

    `cams_old_lat_int` Decimal(18,
 8),

    `cams_old_lon_int` Decimal(18,
 8)
) AS
SELECT
    cp_lat_int AS cams_lat_int,

    cp_lon_int AS cams_lon_int,

    toDecimal64(argMin((cop_lat_int,
 cop_lon_int),
 dist).1,
 8) AS cams_old_lat_int,

    toDecimal64(argMin((cop_lat_int,
 cop_lon_int),
 dist).2,
 8) AS cams_old_lon_int
FROM
(
    SELECT
        cp.lat_int AS cp_lat_int,

        cp.lon_int AS cp_lon_int,

        cop.lat_int AS cop_lat_int,

        cop.lon_int AS cop_lon_int,

        greatCircleDistance(cp.lat,
 cp.lon,
 cop.lat,
 cop.lon) AS dist
    FROM
    (
        SELECT
            lat,

            lon,

            lat_int,

            lon_int
        FROM fairq_raw.cams_processed
        LIMIT 1 BY
            lat,

            lon
    ) AS cp
    CROSS JOIN
    (
        SELECT
            lat,

            lon,

            lat_int,

            lon_int
        FROM fairq_raw.cams_old_processed
        LIMIT 1 BY
            lat,

            lon
    ) AS cop
)
GROUP BY
    cp_lat_int,

    cp_lon_int;
   
-- fairq_prod_features.coord_mapping_dwd_det source

CREATE VIEW fairq_prod_features.coord_mapping_dwd_det
(

    `mq_name` String,

    `dwd_x` Int32,

    `dwd_y` Int32,

    `det_x` Int32,

    `det_y` Int32
) AS
WITH
    coords_det AS
    (
        SELECT DISTINCT
            mq_short_name AS mq_name,

            x,

            y,

            lat_int / 100000 AS lat,

            lon_int / 100000 AS lon
        FROM fairq_raw.traffic_det_cross_sections_processed
        INNER JOIN fairq_prod_features.mapping_reprojection USING (lat_int,
 lon_int)
    ),

    coords_dwd AS
    (
        SELECT DISTINCT
            x,

            y,

            lat_int / 100000 AS lat,

            lon_int / 100000 AS lon
        FROM fairq_prod_features.dwd_observations_filled
        INNER JOIN fairq_prod_features.mapping_reprojection USING (x,
 y)
    ),

    dists AS
    (
        SELECT
            mq_name,

            coords_det.x AS det_x,

            coords_det.y AS det_y,

            coords_dwd.x,

            coords_dwd.y,

            geoDistance(coords_dwd.lon,
 coords_dwd.lat,
 coords_det.lon,
 coords_det.lat) AS dist
        FROM coords_det
        CROSS JOIN coords_dwd
    )
SELECT
    mq_name,

    argMin((coords_dwd.x,
 coords_dwd.y),
 dist).1 AS dwd_x,

    argMin((coords_dwd.x,
 coords_dwd.y),
 dist).2 AS dwd_y,

    det_x,

    det_y
FROM dists
GROUP BY
    mq_name,

    det_x,

    det_y;
   
   -- fairq_prod_features.date_time source

CREATE VIEW fairq_prod_features.date_time
(

    `date_time` DateTime('Europe/Berlin'),

    `type_school_holiday` Nullable(String),

    `is_public_holiday` UInt8,

    `doy_scaled` Float64
) AS
WITH days_per_year AS
    (
        SELECT
            toYear(date_time) AS Year,

            max(toDayOfYear(date_time)) AS ndays
        FROM fairq_prod_features.features_date_time
        GROUP BY toYear(date_time)
    )
SELECT
    date_time,

    multiIf(type_school_holiday IS NULL,
 'no_holiday',
 type_school_holiday) AS type_school_holiday,

    is_public_holiday,

    toDayOfYear(date_time) / ndays AS doy_scaled
FROM fairq_prod_features.features_date_time
INNER JOIN days_per_year ON toYear(date_time) = Year;


-- fairq_prod_features.emissions source

CREATE VIEW fairq_prod_features.emissions
(

    `x` Int32,

    `y` Int32,

    `nox_h_15` Float64,

    `nox_i_15` Float64,

    `nox_v_gn15` Float64,

    `nox_v_hn15` Float64,

    `nox_v_nn15` Float64,

    `nox_ge_15` Float64,

    `pm10_h_15` Float64,

    `pm10_i_15` Float64,

    `pm10_vgn15` Float64,

    `pm10_vhn15` Float64,

    `pm10_vnn15` Float64,

    `pm10_ge_15` Float64,

    `pm2_5_h_15` Float64,

    `pm2_5_i_15` Float64,

    `pm25_vgn15` Float64,

    `pm25_vhn15` Float64,

    `pm25_vnn15` Float64,

    `pm25_ge15` Int32
) AS
SELECT
    stadt_x AS x,

    stadt_y AS y,

    nox_h_15,

    nox_i_15,

    nox_v_gn15,

    nox_v_hn15,

    nox_v_nn15,

    nox_ge_15,

    pm10_h_15,

    pm10_i_15,

    pm10_vgn15,

    pm10_vhn15,

    pm10_vnn15,

    pm10_ge_15,

    pm2_5_h_15,

    pm2_5_i_15,

    pm25_vgn15,

    pm25_vhn15,

    pm25_vnn15,

    pm25_ge15
FROM fairq_prod_features.coord_mapping_emissions_stadt
LEFT JOIN fairq_raw.stadtstruktur_emissions USING (idnr_1km);

-- fairq_prod_features.features_date_time source

CREATE VIEW fairq_prod_features.features_date_time
(

    `date_time` DateTime('Europe/Berlin') COMMENT 'target hour of the forecast',

    `type_school_holiday` Nullable(String) COMMENT 'type of school holiday,
 when NULL normal working day',

    `is_public_holiday` UInt8 COMMENT 'is the target hour / day a public holiday',

    `doy_scaled` Float32 COMMENT 'Day of the Year,
 scaled between 0 and 1'
) AS
WITH days_per_year AS
    (
        SELECT
            toYear(date_time) AS Year,

            max(toDayOfYear(date_time)) AS ndays
        FROM fairq_prod_features.holidays
        GROUP BY toYear(date_time)
    )
SELECT
    date_time,

    multiIf(type_school_holiday IS NULL,
 'no_holiday',
 type_school_holiday) AS type_school_holiday,

    is_public_holiday,

    toDayOfYear(date_time) / ndays AS doy_scaled
FROM fairq_prod_features.holidays
INNER JOIN days_per_year ON toYear(date_time) = Year;

-- fairq_prod_features.latest_cams source

CREATE VIEW fairq_prod_features.latest_cams
(

    `date_time` DateTime('Europe/Berlin') COMMENT 'target hour of the forecast',

    `x` Int32 COMMENT 'mapping of latitude',

    `y` Int32 COMMENT 'mapping of longitude',

    `no2` Float32 COMMENT 'Nitrogen dioxide',

    `pm25` Float32 COMMENT 'Particulate matter < 2.5 µm (PM2.5)',

    `pm10` Float32 COMMENT 'Particulate matter < 10 µm (PM10)'
) AS(
WITH
    latest_forecast AS
    (
        SELECT
            lat_int,

            lon_int,

            date_time,

            max(date_forecast) AS date_forecast
        FROM fairq_prod_features.cams_all
        GROUP BY
            lat_int,

            lon_int,

            date_time
    ),

    latest_cams AS
    (
        SELECT *
        FROM fairq_prod_features.cams_all
        INNER JOIN latest_forecast USING (lat_int,
 lon_int,
 date_time,
 date_forecast)
    )
SELECT
    date_time,

    x,

    y,

    no2,

    pm25,

    pm10
FROM latest_cams
INNER JOIN fairq_prod_features.mapping_reprojection USING (lat_int,
 lon_int)
ORDER BY
    date_time ASC,

    x ASC,

    y ASC)
COMMENT 'code to create this view can be found at https://github.com/INWT/fairq-gap-filling/inst/db/schema.sql';




-- fairq_prod_features.traffic_det source

CREATE VIEW fairq_prod_features.traffic_det
(

    `mq_name` String,

    `date_time` DateTime('Europe/Berlin'),

    `x` Int32,

    `y` Int32,

    `q_kfz_mq_hr` Int16,

    `v_kfz_mq_hr` Float32,

    `q_pkw_mq_hr` Int16,

    `v_pkw_mq_hr` Float32,

    `q_lkw_mq_hr` Int16,

    `v_lkw_mq_hr` Float32
) AS(
SELECT
    mq_name,

    toTimezone((tag + toIntervalHour(stunde)) - 3600,
 'Europe/Berlin') AS date_time,

    x,

    y,

    q_kfz_mq_hr,

    v_kfz_mq_hr,

    q_pkw_mq_hr,

    v_pkw_mq_hr,

    q_lkw_mq_hr,

    v_lkw_mq_hr
FROM fairq_raw.traffic_det_observations AS tdo
INNER JOIN fairq_raw.traffic_det_cross_sections_processed AS tdcsp ON tdo.mq_name = tdcsp.mq_short_name
INNER JOIN fairq_prod_features.mapping_reprojection AS mr ON (tdcsp.lat_int = mr.lat_int) AND (tdcsp.lon_int = mr.lon_int))
COMMENT 'code to create this view can be found at https://github.com/INWT/fairq-gap-filling/inst/db/schema.sql';


CREATE TABLE fairq_prod_features.cams_all_latest_filled
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
