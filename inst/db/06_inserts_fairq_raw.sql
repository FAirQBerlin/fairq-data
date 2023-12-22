-- initialize materialized view
insert into fairq_raw.dwd_forecasts_processed
with dwd_int_coords as (
SELECT
    date_time_forecast,
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
),
latest_forecast_dates as (
  select
    date_time,
    lat_int,
    lon_int,
    max(date_time_forecast) as date_time_forecast
  from dwd_int_coords
  group by date_time, lat_int, lon_int
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
where (date_time, lat_int, lon_int, date_time_forecast) in (select date_time, lat_int, lon_int, date_time_forecast from latest_forecast_dates);


-- initial insert into destination (MV only triggered by inserts into base table stadtstruktur_measuring_stations)
INSERT INTO fairq_raw.stadtstruktur_measuring_stations_processed
SELECT
 	`gml_id`,
	`id`,
	`link`,
	`messnetz`,
	`stand`,
	`stattyp`,
	`plz`,
	`adresse`,
	`lon`,
	`lat`,
	`geometry`,
	toInt32(round(`lat` * 100000)) as lat_int,
	toInt32(round(`lon` * 100000)) as lon_int
FROM fairq_raw.stadtstruktur_measuring_stations
ORDER BY gml_id;


-- initial insert into destination (MV only triggered by inserts into base table traffic_det_cross_sections)

INSERT INTO fairq_raw.traffic_det_cross_sections_processed 
SELECT
    `mq_short_name`,
    `position`,
    `pos_detail`,
    `richtung`,
    `lon`,
    `lat`,
    `mq_id15`,
	  toInt32(round(`lat` * 100000)) as lat_int,
	  toInt32(round(`lon` * 100000)) as lon_int
FROM fairq_raw.traffic_det_cross_sections
ORDER BY mq_id15;


-- initial insert into destination (MV only triggered by inserts into base table dwd_observations)

INSERT INTO fairq_raw.dwd_observations_processed 
SELECT
  	`date_time`,
	`lat`,
	`lon`,
	`wind_direction`,
	`wind_speed`,
	`precipitation`,
	`temperature`,
	`relative_humidity`,
	`cloud_cover`,
	`pressure_msl`,
	`sunshine`,
	toInt32(round(`lat` * 100000)) as lat_int,
	toInt32(round(`lon` * 100000)) as lon_int
FROM fairq_raw.dwd_observations
ORDER BY (date_time,
 lat,
 lon);
 
 
 
-- initial insert into destination (MV only triggered by inserts into base table cams)
INSERT INTO fairq_raw.cams_processed 
SELECT
  	`date_time`,
   	`date_forecast`,
	`lat`,
	`lon`,
	`no2`,
	`pm25`,
	`pm10`,
	toInt32(round(`lat` * 100000)) as lat_int,
	toInt32(round(`lon` * 100000)) as lon_int
FROM fairq_raw.cams
ORDER BY (date_time,
date_forecast,
 lat,
 lon);


 -- initial insert into destination (MV only triggered by inserts into base table cams_old)
INSERT INTO fairq_raw.cams_old_processed 
SELECT
  	date_time,
   	date_forecast,
	lat,
	lon,
	no2,
	pm25,
	pm10,
	toInt32(round(lat * 100000)) as lat_int,
	toInt32(round(lon * 100000)) as lon_int
FROM fairq_raw.cams_old
ORDER BY (date_time,
date_forecast,
 lat,
 lon);
