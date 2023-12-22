-- fairq_raw
create database if not exists fairq_raw;

-- fairq_raw.cams definition

CREATE TABLE fairq_raw.cams
(

    `date_time` DateTime('UTC') COMMENT 'target hour of the forecast',

    `date_forecast` DateTime COMMENT 'date when the forecast was made',

    `lat` Float32 COMMENT 'latitude',

    `lon` Float32 COMMENT 'longitude',

    `no2` Float32 COMMENT 'Nitrogen dioxide',

    `pm25` Float32 COMMENT 'Particulate matter < 2.5 µm (PM2.5)',

    `pm10` Float32 COMMENT 'Particulate matter < 10 µm (PM10)'
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
SETTINGS index_granularity = 8192;

-- fairq_raw.cams_old definition

CREATE TABLE fairq_raw.cams_old
(

    `date_time` DateTime('UTC') COMMENT 'target hour of the forecast',

    `date_forecast` DateTime COMMENT 'date when the forecast was made',

    `lat` Float32 COMMENT 'latitude',

    `lon` Float32 COMMENT 'longitude',

    `no2` Nullable(Float32) DEFAULT NULL COMMENT 'Nitrogen dioxide',

    `pm25` Float32 COMMENT 'Particulate matter < 2.5 µm (PM2.5)',

    `pm10` Float32 COMMENT 'Particulate matter < 10 µm (PM10)'
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
COMMENT 'CAMS data from the "old" API (CAMS global)';

-- fairq_raw.cams_old_processed definition

CREATE TABLE fairq_raw.cams_old_processed
(

    `date_time` DateTime('UTC') COMMENT 'target hour of the forecast',

    `date_forecast` DateTime COMMENT 'date when the forecast was made',

    `lat` Float32 COMMENT 'latitude',

    `lon` Float32 COMMENT 'longitude',

    `no2` Nullable(Float32) DEFAULT NULL COMMENT 'Nitrogen dioxide',

    `pm25` Float32 COMMENT 'Particulate matter < 2.5 µm (PM2.5)',

    `pm10` Float32 COMMENT 'Particulate matter < 10 µm (PM10)',

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
COMMENT 'CAMS data from the "old" API (CAMS global)';

-- fairq_raw.cams_processed definition

CREATE TABLE fairq_raw.cams_processed
(

    `date_time` DateTime('UTC') COMMENT 'target hour of the forecast',

    `date_forecast` DateTime COMMENT 'date when the forecast was made',

    `lat` Float32 COMMENT 'latitude',

    `lon` Float32 COMMENT 'longitude',

    `no2` Float32 COMMENT 'Nitrogen dioxide',

    `pm25` Float32 COMMENT 'Particulate matter < 2.5 µm (PM2.5)',

    `pm10` Float32 COMMENT 'Particulate matter < 10 µm (PM10)',

    `lat_int` Int32 COMMENT 'latitude integer (factor 100000)',

    `lon_int` Int32 COMMENT 'longitude integer (factor 100000)'
)
ENGINE = ReplacingMergeTree
ORDER BY (date_time,
 date_forecast,
 lat,
 lon)
SETTINGS index_granularity = 8192;

-- fairq_raw.dwd_forecasts definition

CREATE TABLE fairq_raw.dwd_forecasts
(

    `date_time_forecast` DateTime('UTC') COMMENT 'time when the forecast was made',

    `date_time` DateTime('UTC') COMMENT 'target hour of the forecast',

    `lat` Float32 COMMENT 'latitude in decimal degrees',

    `lon` Float32 COMMENT 'longitude in decimal degrees',

    `wind_direction` Nullable(Int32) DEFAULT NULL COMMENT 'wind direction',

    `wind_speed` Nullable(Float64) DEFAULT NULL COMMENT 'wind speed',

    `precipitation` Nullable(Float64) DEFAULT NULL COMMENT 'precipitation',

    `temperature` Nullable(Float64) DEFAULT NULL COMMENT 'temperature',

    `relative_humidity` Nullable(Int32) DEFAULT NULL COMMENT 'relative humidity',

    `cloud_cover` Nullable(Int32) DEFAULT NULL COMMENT 'cloud cover',

    `pressure_msl` Nullable(Float64) DEFAULT NULL COMMENT 'air pressure',

    `sunshine` Nullable(Int32) DEFAULT NULL COMMENT 'sunshine'
)
ENGINE = ReplacingMergeTree
ORDER BY (date_time_forecast,
 date_time,
 lat,
 lon)
SETTINGS index_granularity = 8192;


-- fairq_raw.dwd_observations definition

CREATE TABLE fairq_raw.dwd_observations
(

    `date_time` DateTime('UTC') COMMENT 'time of measurement',

    `lat` Float32 COMMENT 'latitude in decimal degrees',

    `lon` Float32 COMMENT 'longitude in decimal degrees',

    `wind_direction` Nullable(Int32) DEFAULT NULL COMMENT 'wind direction',

    `wind_speed` Nullable(Float64) DEFAULT NULL COMMENT 'wind speed',

    `precipitation` Nullable(Float64) DEFAULT NULL COMMENT 'precipitation',

    `temperature` Nullable(Float64) DEFAULT NULL COMMENT 'temperature',

    `relative_humidity` Nullable(Int32) DEFAULT NULL COMMENT 'relative humidity',

    `cloud_cover` Nullable(Int32) DEFAULT NULL COMMENT 'cloud cover',

    `pressure_msl` Nullable(Float64) DEFAULT NULL COMMENT 'air pressure',

    `sunshine` Nullable(Int32) DEFAULT NULL COMMENT 'sunshine'
)
ENGINE = ReplacingMergeTree
ORDER BY (date_time,
 lat,
 lon)
SETTINGS index_granularity = 8192;

-- fairq_raw.dwd_observations_processed definition

CREATE TABLE fairq_raw.dwd_observations_processed
(

    `date_time` DateTime COMMENT 'time of measurement',

    `lat` Float32 COMMENT 'latitude in decimal degrees',

    `lon` Float32 COMMENT 'longitude in decimal degrees',

    `wind_direction` Nullable(UInt16) DEFAULT NULL COMMENT 'wind direction',

    `wind_speed` Nullable(Float64) DEFAULT NULL COMMENT 'wind speed',

    `precipitation` Nullable(Float64) DEFAULT NULL COMMENT 'precipitation',

    `temperature` Nullable(Float64) DEFAULT NULL COMMENT 'temperature',

    `relative_humidity` Nullable(UInt8) DEFAULT NULL COMMENT 'relative humidity',

    `cloud_cover` Nullable(UInt8) DEFAULT NULL COMMENT 'cloud cover',

    `pressure_msl` Nullable(Float64) DEFAULT NULL COMMENT 'air pressure',

    `sunshine` Nullable(UInt8) DEFAULT NULL COMMENT 'sunshine',

    `lat_int` Int32 COMMENT 'latitude integer (factor 100000)',

    `lon_int` Int32 COMMENT 'longitude integer (factor 100000)'
)
ENGINE = ReplacingMergeTree
ORDER BY (date_time,
 lat,
 lon)
SETTINGS index_granularity = 8192;

-- fairq_raw.kba_kfz_bestand_nach_typ definition

CREATE TABLE fairq_raw.kba_kfz_bestand_nach_typ
(

    `year` UInt16 COMMENT 'Jahr der Erhebung (Stand zum 1. Januar des Jahres X)',

    `kennziffer` String COMMENT 'Statistische Kennziffer und Zulassungsbezirk',

    `krad_insgesamt` UInt32 COMMENT 'Anzahl Krafträder insgesamt',

    `krad_zweiraedrig` UInt32 COMMENT 'Anzahl zweirädrige Krafträder',

    `krad_dreiraedrig` UInt32 COMMENT 'Anzahl dreirädrige Krafträder',

    `krad_vierraedrig` UInt32 COMMENT 'Anzahl vierrädrige Krafträder',

    `krad_weibliche_halter` UInt32 COMMENT 'Anzahl weiblicher Halterinnen von Krafträdern',

    `pkw_insgesamt` UInt32 COMMENT 'Anzahl PKW insgesamt',

    `pkw_hubr_bis_1399` UInt32 COMMENT 'Anzahl PKW mit Hubraum bis 1339 cm3',

    `pkw_hubr_1400_bis_1999` UInt32 COMMENT 'Anzahl PKW mit Hubraum von 1400 bis 1999 cm3',

    `pkw_hubr_2000_und_mehr` UInt32 COMMENT 'Anzahl PKW mit Hubraum von 2000 und mehr cm3',

    `pkw_hubr_unbekannt` UInt32 COMMENT 'Anzahl PKW mit Hubraum unbekannt',

    `pkw_offener_aufbau` UInt32 COMMENT 'Anzahl PKW mit offenem Aufbau',

    `pkw_allrad` UInt32 COMMENT 'Anzahl PKW mit Allrad-Antrieb',

    `pkw_wohnmobil` UInt32 COMMENT 'Anzahl Wohnmobile unter PKW',

    `pkw_einsatzfhz` UInt32 COMMENT 'Anzahl Krankenwagen,
 Notarzt- und Einsatzfahrzeuge unter PKW',

    `pkw_gewerbe` UInt32 COMMENT 'Anzahl gewerblicher Halter der PKW',

    `pkw_weibliche_halter` UInt32 COMMENT 'Anzahl weiblicher Halterinnen der PKW',

    `pkw_dichte_je_tsd_einwohner` UInt32 COMMENT 'PKW-Dichte je 1000 Einwohner',

    `kraftomnibusse` UInt32 COMMENT 'Anzahl Kraftomnibusse',

    `lkw_insgesamt` UInt32 COMMENT 'Anzahl LKW insgesamt',

    `lkw_masse_bis_2800kg` UInt32 COMMENT 'Anzahl LKW mit zulässiger Gesamtmasse bis 2800 kg',

    `lkw_masse_2801_bis_3500kg` UInt32 COMMENT 'Anzahl LKW mit zulässiger Gesamtmasse von 2800 bis 3500 kg',

    `lkw_masse_3501_bis_5000kg` UInt32 COMMENT 'Anzahl LKW mit zulässiger Gesamtmasse von 3501 bis 5000 kg',

    `lkw_masse_5001_bis_7500kg` UInt32 COMMENT 'Anzahl LKW mit zulässiger Gesamtmasse von 5001 bis 7500 kg',

    `lkw_masse_7501_bis_12000kg` UInt32 COMMENT 'Anzahl LKW mit zulässiger Gesamtmasse von 7501 bis 12000 kg',

    `lkw_masse_12001_bis_200000kg` UInt32 COMMENT 'Anzahl LKW mit zulässiger Gesamtmasse von 12001 bis 20000 kg',

    `lkw_masse_20001_und_mehr_kg` UInt32 COMMENT 'Anzahl LKW mit zulässiger Gesamtmasse von mehr als 20000 kg',

    `lkw_masse_unbekannt` UInt32 COMMENT 'Anzahl LKW mit unbekannter Masse',

    `lok_insgesamt` UInt32 COMMENT 'Anzahl Zugmaschinen insgesamt',

    `lok_sattelzug` UInt32 COMMENT 'Anzahl Sattelzugmaschinen unter Zugmaschinen',

    `lok_landforstwirtschaft` UInt32 COMMENT 'Anzahl land-/forstwirtschaftlicher Zugmaschinen',

    `lok_leicht_landforstwirtschaft` UInt32 COMMENT 'Anzahl leichter land-/forstwirtschaftlicher Zugmaschinen darunter',

    `kfz_sonstige` UInt32 COMMENT 'Anzahl sonstiger KFZ',

    `nutzfhz_gesamt` UInt32 COMMENT 'Anzahl Nutzfahrzeuge insgesamt',

    `kfz_insgesamt` UInt32 COMMENT 'Anzahl KFZ insgesamt',

    `kfz_dichte_je_tsd_einwohner` UInt32 COMMENT 'KFZ-Dichte je 1000 Einwohner',

    `kfz_anhaenger` UInt32 COMMENT 'Anzahl Kraftfahrzeuganhänger'
)
ENGINE = ReplacingMergeTree
ORDER BY year
SETTINGS index_granularity = 8192;

-- fairq_raw.kba_pkw_bestand_nach_emission definition

CREATE TABLE fairq_raw.kba_pkw_bestand_nach_emission
(

    `year` UInt32 COMMENT 'Jahr der Erhebung (Stand zum 1. Januar des Jahres X)',

    `kennziffer` String COMMENT 'Statistische Kennziffer und Zulassungsbezirk',

    `pkw_insgesamt` UInt32 COMMENT 'Anzahl PKW insgesamt',

    `pkw_ks_benzin` UInt32 COMMENT 'Anzahl PKW mit Kraftstoffart Benzin',

    `pkw_ks_diesel` UInt32 COMMENT 'Anzahl PKW mit Kraftstoffart Diesel',

    `pkw_ks_gas` UInt32 COMMENT 'Anzahl PKW mit Kraftstoffart Gas (einschließlich bivalent',

    `pkw_ks_hybrid_gesamt` UInt32 COMMENT 'Anzahl PKW mit Kraftstoffart Hybrid (gesamt)',

    `pkw_ks_hybrid_plugin_darunter` UInt32 COMMENT 'Anzahl PKW mit Kraftstoffart Hybrid mit Plugin (darunter)',

    `pkw_ks_elektro` UInt32 COMMENT 'Anzahl PKW mit Kraftstoffart Elektro',

    `pkw_ks_sonstige` UInt32 COMMENT 'Anzahl PKW mit sonstiger Kraftstoffart',

    `pkw_em_euro1` UInt32 COMMENT 'Anzahl PKW mit Emissionsgruppe Euro 1',

    `pkw_em_euro2` UInt32 COMMENT 'Anzahl PKW mit Emissionsgruppe Euro 2',

    `pkw_em_euro3` UInt32 COMMENT 'Anzahl PKW mit Emissionsgruppe Euro 3',

    `pkw_em_euro4` UInt32 COMMENT 'Anzahl PKW mit Emissionsgruppe Euro 4',

    `pkw_em_euro5` UInt32 COMMENT 'Anzahl PKW mit Emissionsgruppe Euro 5',

    `pkw_em_euro6` UInt32 COMMENT 'Anzahl PKW mit Emissionsgruppe Euro 6',

    `pkw_em_euro6d` UInt32 COMMENT 'Anzahl PKW mit Emissionsgruppe Euro 6d (darunter)',

    `pkw_em_euro6d_temp` UInt32 COMMENT 'Anzahl PKW mit Emissionsgruppe Euro 6d-temp (darunter)',

    `pkw_em_sonstige` UInt32 COMMENT 'Anzahl PKW mit sonstiger Emissionsgruppe',

    `pkw_em_schadstoffreduziert_insgesamt` UInt32 COMMENT 'Anzahl PKW mit Schadstoffreduzierung insgesamt',

    `pkw_em_euro1_darunter_diesel` UInt32 COMMENT 'Anzahl Diesel-PKW mit Emissionsgruppe Euro 1',

    `pkw_em_euro2_darunter_diesel` UInt32 COMMENT 'Anzahl Diesel-PKW mit Emissionsgruppe Euro 2',

    `pkw_em_euro3_darunter_diesel` UInt32 COMMENT 'Anzahl Diesel-PKW mit Emissionsgruppe Euro 3',

    `pkw_em_euro4_darunter_diesel` UInt32 COMMENT 'Anzahl Diesel-PKW mit Emissionsgruppe Euro 4',

    `pkw_em_euro5_darunter_diesel` UInt32 COMMENT 'Anzahl Diesel-PKW mit Emissionsgruppe Euro 5',

    `pkw_em_euro6_darunter_diesel` UInt32 COMMENT 'Anzahl Diesel-PKW mit Emissionsgruppe Euro 6',

    `pkw_em_euro6d_darunter_diesel` UInt32 COMMENT 'Anzahl Diesel-PKW mit Emissionsgruppe Euro 6d (darunter)',

    `pkw_em_euro6d_temp_darunter_diesel` UInt32 COMMENT 'Anzahl Diesel-PKW mit Emissionsgruppe Euro 6d-temp (darunter)',

    `pkw_em_sonstige_darunter_diesel` UInt32 COMMENT 'Anzahl Diesel-PKW mit sonstiger Emissionsgruppe',

    `pkw_em_schadstoffreduziert_darunter_diesel_insgesamt` UInt32 COMMENT 'Anzahl Diesel-PKW mit Schadstoffreduzierung'
)
ENGINE = ReplacingMergeTree
ORDER BY year
SETTINGS index_granularity = 8192;

-- fairq_raw.mapping_messstationen_traffic_det definition

CREATE TABLE fairq_raw.mapping_messstationen_traffic_det
(

    `station_id` String COMMENT 'ID of measuring station',

    `mq_name` String COMMENT 'short name of cross section (Messquerschnitt)'
)
ENGINE = ReplacingMergeTree
ORDER BY mq_name
SETTINGS index_granularity = 8192
COMMENT 'mapping between measuring stations and traffic detectors; only available for some stations of type Verkehr';

-- fairq_raw.mapping_stations_dwd definition

CREATE TABLE fairq_raw.mapping_stations_dwd
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

-- fairq_raw.messstationen definition

CREATE TABLE fairq_raw.messstationen
(

    `station_id` String,

    `station_name` String,

    `station_url` String
)
ENGINE = ReplacingMergeTree
ORDER BY station_id
SETTINGS index_granularity = 8192;

-- fairq_raw.messstationen_daten definition

CREATE TABLE fairq_raw.messstationen_daten
(

    `station_id` String,

    `timestamp` DateTime('Europe/Berlin'),

    `feinstaub_pm10` Nullable(Int16) COMMENT 'Feinstaub (PM10) in Mikrogramm pro Kubikmeter',

    `feinstaub_pm2_5` Nullable(Int16) COMMENT 'Feinstaub (PM2,
5) in Mikrogramm pro Kubikmeter',

    `stickstoffdioxid` Nullable(Int16) COMMENT 'Stickstoffdioxid in Mikrogramm pro Kubikmeter',

    `stickstoffmonoxid` Nullable(Int16) COMMENT 'Stickstoffmonoxid in Mikrogramm pro Kubikmeter',

    `stickoxide` Nullable(Int16) COMMENT 'Stickoxide in Mikrogramm pro Kubikmeter',

    `ozon` Nullable(Int16) COMMENT 'Ozon in Mikrogramm pro Kubikmeter',

    `benzol` Nullable(Float64) COMMENT 'Benzol in Mikrogramm pro Kubikmeter',

    `toluol` Nullable(Float64) COMMENT 'Toluol in Mikrogramm pro Kubikmeter',

    `kohlenmonoxid` Nullable(Float64) COMMENT 'Kohlenmonoxid in Milligramm pro Kubikmeter',

    `schwefeldioxid` Nullable(Int16) COMMENT 'Schwefeldioxid in Mikrogramm pro Kubikmeter'
)
ENGINE = ReplacingMergeTree
ORDER BY (station_id,
 timestamp)
SETTINGS index_granularity = 8192;

-- fairq_raw.ref_coordinate_systems definition

CREATE TABLE fairq_raw.ref_coordinate_systems
(

    `table_name` String,

    `coordinate_reference_system` String,

    `EPSG` Int32,

    `proj.4` String
)
ENGINE = ReplacingMergeTree
PRIMARY KEY table_name
ORDER BY table_name
SETTINGS index_granularity = 8192;

-- fairq_raw.stadtstruktur_berlin_bezirke definition

CREATE TABLE fairq_raw.stadtstruktur_berlin_bezirke
(

    `gml_id` String COMMENT 'fisbroker id',

    `GEM` Int32 COMMENT 'Bezirk id (equivalent to BEZ in LOR system)',

    `NAMGEM` String COMMENT 'Bezirk name',

    `NAMLAN` String COMMENT 'Bundesland name',

    `LAN` Int32 COMMENT 'Bundesland id',

    `NAME` Int32 COMMENT 'LOR key id',

    `geometry` String COMMENT 'geodata geometries'
)
ENGINE = ReplacingMergeTree
ORDER BY gml_id
SETTINGS index_granularity = 8192;

-- fairq_raw.stadtstruktur_berlin_lor definition

CREATE TABLE fairq_raw.stadtstruktur_berlin_lor
(

    `gml_id` String COMMENT 'fisbroker id',

    `PLR_ID` String COMMENT 'Planungsraum id (low level)',

    `PLR_NAME` String COMMENT 'Planungsraum name (low level)',

    `BZR_ID` String COMMENT 'Bezirksregion id (mid level)',

    `BZR_NAME` String COMMENT 'Bezirksregion name (mid level)',

    `PGR_ID` String COMMENT 'Prognoseraum id (high level)',

    `PGR_NAME` String COMMENT 'Prognoseraum name (high level)',

    `BEZ` String COMMENT 'Bezirk id (equivalent to GEM in Bezirk system)',

    `FINHALT` Float64 COMMENT 'area in square metres',

    `STAND` String COMMENT 'last updated by authorities',

    `geometry` String COMMENT 'geodata geometries'
)
ENGINE = ReplacingMergeTree
ORDER BY gml_id
SETTINGS index_granularity = 8192;

-- fairq_raw.stadtstruktur_buildings_density definition

CREATE TABLE fairq_raw.stadtstruktur_buildings_density
(

    `gml_id` String,

    `schl5` Float64,

    `flalle` Float64,

    `gfz_19_2` Float64,

    `grz_19_2` Float64,

    `grz_19_4` Float64,

    `woz_name` Nullable(String),

    `typklar` String,

    `grz_name` Nullable(String),

    `geometry` String
)
ENGINE = ReplacingMergeTree
ORDER BY gml_id
SETTINGS index_granularity = 8192;

-- fairq_raw.stadtstruktur_buildings_height definition

CREATE TABLE fairq_raw.stadtstruktur_buildings_height
(

    `gml_id` String,

    `role_txt` Nullable(String),

    `hoehe` Float64,

    `dachart` Nullable(Int32),

    `dachart_txt` Nullable(String),

    `geschosse` Nullable(Int32),

    `quellebodenhoehe` Nullable(Int32),

    `quellebodenhoehe_txt` Nullable(String),

    `quelledachhoehe` Int32,

    `quelledachhoehe_txt` Nullable(String),

    `quellelage` Nullable(Int32),

    `quellelage_txt` Nullable(String),

    `grundrissaktualitaet` Nullable(String),

    `gemeinde_txt` Nullable(String),

    `strasse` Nullable(String),

    `hnr` Nullable(String),

    `name` Nullable(String),

    `geometry` String
)
ENGINE = ReplacingMergeTree
ORDER BY gml_id
SETTINGS index_granularity = 8192;

-- fairq_raw.stadtstruktur_emissions definition

CREATE TABLE fairq_raw.stadtstruktur_emissions
(

    `gml_id` String,

    `idnr_1km` Int32,

    `x_max` Int32,

    `x_min` Int32,

    `y_max` Int32,

    `y_min` Int32,

    `area` Int32,

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

    `pm25_ge15` Int32,

    `geometry` String
)
ENGINE = ReplacingMergeTree
ORDER BY gml_id
SETTINGS index_granularity = 8192;

-- fairq_raw.stadtstruktur_land_use definition

CREATE TABLE fairq_raw.stadtstruktur_land_use
(

    `gml_id` String,

    `schl5` Float64,

    `bez` Int32,

    `bezirk` String,

    `woz` Nullable(Int32),

    `woz_name` Nullable(String),

    `ststrnr` Nullable(Int32),

    `ststrname` String,

    `typ` Int32,

    `typklar` String,

    `nutz` Int32,

    `nutzung` String,

    `nutz_bauvor` Int32,

    `nutzung_bauvor` String,

    `flalle` Float64,

    `grz` Nullable(Int32),

    `grz_name` Nullable(String),

    `geometry` String
)
ENGINE = ReplacingMergeTree
ORDER BY gml_id
SETTINGS index_granularity = 8192;

-- fairq_raw.stadtstruktur_measuring_stations definition

CREATE TABLE fairq_raw.stadtstruktur_measuring_stations
(

    `gml_id` String COMMENT 'fisbroker id',

    `id` String COMMENT 'measuring station id',

    `link` String COMMENT 'url to measuring station details website ',

    `messnetz` String COMMENT 'type of measuring network',

    `stand` String COMMENT 'in use / out of order',

    `stattyp` String COMMENT 'type of measuring station',

    `plz` Int32 COMMENT 'address/location of measuring station',

    `adresse` String COMMENT 'address/location of measuring station',

    `lon` Float64 COMMENT 'longitude',

    `lat` Float64 COMMENT 'latitude',

    `geometry` String COMMENT 'geodata geometries'
)
ENGINE = ReplacingMergeTree
ORDER BY gml_id
SETTINGS index_granularity = 8192;

-- fairq_raw.stadtstruktur_measuring_stations_processed definition

CREATE TABLE fairq_raw.stadtstruktur_measuring_stations_processed
(

    `gml_id` String COMMENT 'fisbroker id',

    `id` String COMMENT 'measuring station id',

    `link` String COMMENT 'url to measuring station details website ',

    `messnetz` String COMMENT 'type of measuring network',

    `stand` String COMMENT 'in use / out of order',

    `stattyp` String COMMENT 'type of measuring station',

    `plz` Int32 COMMENT 'address/location of measuring station',

    `adresse` String COMMENT 'address/location of measuring station',

    `lon` Float64 COMMENT 'longitude',

    `lat` Float64 COMMENT 'latitude',

    `geometry` String COMMENT 'geodata geometries',

    `lat_int` Int32 COMMENT 'latitude integer (factor 100000)',

    `lon_int` Int32 COMMENT 'longitude integer (factor 100000)'
)
ENGINE = ReplacingMergeTree
ORDER BY gml_id
SETTINGS index_granularity = 8192;

-- fairq_raw.stadtstruktur_network_edifice definition

CREATE TABLE fairq_raw.stadtstruktur_network_edifice
(

    `gml_id` String,

    `bauwerksart` String,

    `bauwerksname` String,

    `okstra_id` String,

    `bauwerksnummer` String,

    `sib_bauwerksnummer` String,

    `geometry` String
)
ENGINE = ReplacingMergeTree
ORDER BY gml_id
SETTINGS index_granularity = 8192;

-- fairq_raw.stadtstruktur_network_nodes definition

CREATE TABLE fairq_raw.stadtstruktur_network_nodes
(

    `gml_id` String,

    `verkehrsebene` Int32,

    `okstra_id` String,

    `lon` Float64,

    `lat` Float64,

    `geometry` String
)
ENGINE = ReplacingMergeTree
ORDER BY gml_id
SETTINGS index_granularity = 8192;

-- fairq_raw.stadtstruktur_network_streets definition

CREATE TABLE fairq_raw.stadtstruktur_network_streets
(

    `gml_id` String,

    `element_nr` String,

    `strassenschluessel` Int32,

    `strassenname` String,

    `strassenklasse1` String,

    `strassenklasse` String,

    `strassenklasse2` String,

    `verkehrsrichtung` String,

    `bezirk` Nullable(String),

    `stadtteil` Nullable(String),

    `verkehrsebene` Int32,

    `beginnt_bei_vp` Int32,

    `endet_bei_vp` Int32,

    `laenge` Float64,

    `gueltig_von` String,

    `okstra_id` String,

    `str_bez` Nullable(String),

    `geometry` String
)
ENGINE = ReplacingMergeTree
ORDER BY gml_id
SETTINGS index_granularity = 8192;

-- fairq_raw.stadtstruktur_traffic definition

CREATE TABLE fairq_raw.stadtstruktur_traffic
(

    `gml_id` String,

    `link_id` String,

    `elem_nr` String,

    `vnp` Int32,

    `nnp` Int32,

    `vst` Int32,

    `bst` Int32,

    `vricht` String,

    `ebene` Int32,

    `str_typ` String,

    `strklasse1` String,

    `strklasse` String,

    `strklasse2` String,

    `str_name` String,

    `bezirk` Nullable(String),

    `stadtteil` Nullable(String),

    `dtvw_kfz` Int32,

    `dtvw_lkw` Int32,

    `geometry` String
)
ENGINE = ReplacingMergeTree
ORDER BY gml_id
SETTINGS index_granularity = 8192;

-- fairq_raw.stadtstruktur_trees_park definition

CREATE TABLE fairq_raw.stadtstruktur_trees_park
(

    `gml_id` String,

    `baumid` String,

    `standortnr` Nullable(String),

    `kennzeich` Nullable(String),

    `namenr` Nullable(String),

    `art_dtsch` Nullable(String),

    `art_bot` Nullable(String),

    `gattung_deutsch` Nullable(String),

    `gattung` Nullable(String),

    `pflanzjahr` Nullable(Int32),

    `standalter` Nullable(Float64),

    `stammumfg` Nullable(Int32),

    `bezirk` String,

    `eigentuemer` String,

    `kronedurch` Nullable(Float64),

    `baumhoehe` Nullable(Float64),

    `lon` Float64,

    `lat` Float64,

    `geometry` String
)
ENGINE = ReplacingMergeTree
ORDER BY gml_id
SETTINGS index_granularity = 8192;

-- fairq_raw.stadtstruktur_trees_street definition

CREATE TABLE fairq_raw.stadtstruktur_trees_street
(

    `gml_id` String,

    `baumid` String,

    `standortnr` Nullable(String),

    `kennzeich` String,

    `namenr` String,

    `art_dtsch` Nullable(String),

    `art_bot` Nullable(String),

    `gattung_deutsch` Nullable(String),

    `gattung` Nullable(String),

    `strname` Nullable(String),

    `hausnr` Nullable(String),

    `pflanzjahr` Nullable(Int32),

    `standalter` Nullable(Float64),

    `stammumfg` Nullable(Int32),

    `baumhoehe` Nullable(Float64),

    `bezirk` String,

    `eigentuemer` String,

    `zusatz` Nullable(String),

    `kronedurch` Nullable(Float64),

    `lon` Float64,

    `lat` Float64,

    `geometry` String
)
ENGINE = ReplacingMergeTree
ORDER BY gml_id
SETTINGS index_granularity = 8192;

-- fairq_raw.traffic_det_cross_sections definition

CREATE TABLE fairq_raw.traffic_det_cross_sections
(

    `mq_short_name` String COMMENT 'short name of cross section (Messquerschnitt)',

    `position` String COMMENT 'name of street',

    `pos_detail` Nullable(String) COMMENT 'description of street section',

    `richtung` String,

    `lon` Float32 COMMENT 'longitude (WGS 84)',

    `lat` Float32 COMMENT 'latitude (WGS 84)',

    `mq_id15` UInt64 COMMENT '15 digits ID of the cross section (Messquerschnitt)'
)
ENGINE = ReplacingMergeTree
ORDER BY mq_id15
SETTINGS index_granularity = 8192;

-- fairq_raw.traffic_det_cross_sections_processed definition

CREATE TABLE fairq_raw.traffic_det_cross_sections_processed
(

    `mq_short_name` String COMMENT 'short name of cross section (Messquerschnitt)',

    `position` String COMMENT 'name of street',

    `pos_detail` Nullable(String) COMMENT 'description of street section',

    `richtung` String,

    `lon` Float32 COMMENT 'longitude',

    `lat` Float32 COMMENT 'latitude',

    `mq_id15` UInt64 COMMENT '15 digits ID of the cross section (Messquerschnitt)',

    `lat_int` Int32 COMMENT 'latitude integer (factor 100000)',

    `lon_int` Int32 COMMENT 'longitude integer (factor 100000)'
)
ENGINE = ReplacingMergeTree
ORDER BY mq_id15
SETTINGS index_granularity = 8192;

-- fairq_raw.traffic_det_observations definition

CREATE TABLE fairq_raw.traffic_det_observations
(

    `mq_name` String COMMENT 'short name of cross section (Messquerschnitt)',

    `tag` Date COMMENT 'day of measurement',

    `stunde` UInt8 COMMENT 'hour of measurement (0 to 24) in Europe/Berlin time,
 i.e.,
 CET resp. CEST',

    `qualitaet` Float32 COMMENT 'proportion of flawless measurement intervals in this hour; 1 means 100%',

    `q_kfz_mq_hr` Int16 COMMENT 'total number of vehicles in this hour',

    `v_kfz_mq_hr` Float32 COMMENT 'mean velocity [km/h] of all vehicles in this hour',

    `q_pkw_mq_hr` Int16 COMMENT 'number of cars in this hour',

    `v_pkw_mq_hr` Float32 COMMENT 'mean velocity [km/h] of cars in this hour',

    `q_lkw_mq_hr` Int16 COMMENT 'number of cars in this hour',

    `v_lkw_mq_hr` Float32 COMMENT 'mean velocity [km/h] of trucks in this hour'
)
ENGINE = ReplacingMergeTree
ORDER BY (mq_name,
 tag,
 stunde)
SETTINGS index_granularity = 8192;

-- fairq_raw.updated_table definition

CREATE TABLE fairq_raw.updated_table
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

-- fairq_raw.cams_mv source

CREATE MATERIALIZED VIEW fairq_raw.cams_mv TO fairq_raw.cams_processed
(

    `date_time` DateTime('UTC'),

    `date_forecast` DateTime,

    `lat` Float32,

    `lon` Float32,

    `no2` Float32,

    `pm25` Float32,

    `pm10` Float32,

    `lat_int` Int32,

    `lon_int` Int32
) AS
SELECT
    date_time,

    date_forecast,

    lat,

    lon,

    no2,

    pm25,

    pm10,

    toInt32(round(lat * 100000)) AS lat_int,

    toInt32(round(lon * 100000)) AS lon_int
FROM fairq_raw.cams
ORDER BY (date_time,
 date_forecast,
 lat,
 lon) ASC;

-- fairq_raw.cams_old_mv source

CREATE MATERIALIZED VIEW fairq_raw.cams_old_mv TO fairq_raw.cams_old_processed
(

    `date_time` DateTime('UTC'),

    `date_forecast` DateTime,

    `lat` Float32,

    `lon` Float32,

    `no2` Nullable(Float32),

    `pm25` Float32,

    `pm10` Float32,

    `lat_int` Int32,

    `lon_int` Int32
) AS
SELECT
    date_time,

    date_forecast,

    lat,

    lon,

    no2,

    pm25,

    pm10,

    toInt32(round(lat * 100000)) AS lat_int,

    toInt32(round(lon * 100000)) AS lon_int
FROM fairq_raw.cams_old
ORDER BY (date_time,
 date_forecast,
 lat,
 lon) ASC;


-- fairq_raw.dwd_observations_mv source

CREATE MATERIALIZED VIEW fairq_raw.dwd_observations_mv TO fairq_raw.dwd_observations_processed
(

    `date_time` DateTime('UTC'),

    `lat` Float32,

    `lon` Float32,

    `wind_direction` Nullable(Int32),

    `wind_speed` Nullable(Float64),

    `precipitation` Nullable(Float64),

    `temperature` Nullable(Float64),

    `relative_humidity` Nullable(Int32),

    `cloud_cover` Nullable(Int32),

    `pressure_msl` Nullable(Float64),

    `sunshine` Nullable(Int32),

    `lat_int` Int32,

    `lon_int` Int32
) AS
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
FROM fairq_raw.dwd_observations
ORDER BY (date_time,
 lat,
 lon) ASC;

-- fairq_raw.mapping_dwd_stations source

CREATE VIEW fairq_raw.mapping_dwd_stations
(

    `id` String,

    `date_time` DateTime,

    `dwd_lat` Decimal(18,
 8),

    `dwd_lon` Decimal(18,
 8),

    `wind_direction` Nullable(Float64),

    `precipitation` Nullable(Float64),

    `temperature` Nullable(Float64),

    `relative_humidity` Nullable(Float64),

    `cloud_cover` Nullable(Float64),

    `pressure_msl` Nullable(Float64)
) AS
SELECT
    mds.id,

    do.*
FROM
(
    SELECT
        date_time,

        toDecimal64(lat,
 8) AS dwd_lat,

        toDecimal64(lon,
 8) AS dwd_lon,

        wind_direction,

        precipitation,

        temperature,

        relative_humidity,

        cloud_cover,

        pressure_msl
    FROM fairq_raw.dwd_observations
) AS do
LEFT JOIN
(
    SELECT
        id,

        toDecimal64(argMin((lat,
 lon),
 dist).1,
 8) AS dwd_lat,

        toDecimal64(argMin((lat,
 lon),
 dist).2,
 8) AS dwd_lon
    FROM
    (
        SELECT
            lat,

            lon,

            sms.id,

            sms.lat,

            sms.lon,

            greatCircleDistance(lat,
 lon,
 sms.lat,
 sms.lon) AS dist
        FROM
        (
            SELECT
                lat,

                lon
            FROM fairq_raw.dwd_observations
            LIMIT 1 BY
                lat,

                lon
        ) AS do
        CROSS JOIN
        (
            SELECT
                id,

                lat,

                lon
            FROM fairq_raw.stadtstruktur_measuring_stations
            WHERE (messnetz = 'BLUME') AND (stand = 'aktuell')
        ) AS sms
    )
    GROUP BY id
) AS mds ON (do.dwd_lat = mds.dwd_lat) AND (do.dwd_lon = mds.dwd_lon)
WHERE id != '';

-- fairq_raw.stadtstruktur_measuring_stations_mv source

CREATE MATERIALIZED VIEW fairq_raw.stadtstruktur_measuring_stations_mv TO fairq_raw.stadtstruktur_measuring_stations_processed
(

    `gml_id` String,

    `id` String,

    `link` String,

    `messnetz` String,

    `stand` String,

    `stattyp` String,

    `plz` Int32,

    `adresse` String,

    `lon` Float64,

    `lat` Float64,

    `geometry` String,

    `lat_int` Int32,

    `lon_int` Int32
) AS
SELECT
    gml_id,

    id,

    link,

    messnetz,

    stand,

    stattyp,

    plz,

    adresse,

    lon,

    lat,

    geometry,

    toInt32(round(lat * 100000)) AS lat_int,

    toInt32(round(lon * 100000)) AS lon_int
FROM fairq_raw.stadtstruktur_measuring_stations
ORDER BY gml_id ASC;

-- fairq_raw.traffic_det_cross_sections_mv source

CREATE MATERIALIZED VIEW fairq_raw.traffic_det_cross_sections_mv TO fairq_raw.traffic_det_cross_sections_processed
(

    `mq_short_name` String,

    `position` String,

    `pos_detail` Nullable(String),

    `richtung` String,

    `lon` Float32,

    `lat` Float32,

    `mq_id15` UInt64,

    `lat_int` Int32,

    `lon_int` Int32
) AS
SELECT
    mq_short_name,

    position,

    pos_detail,

    richtung,

    lon,

    lat,

    mq_id15,

    toInt32(round(lat * 100000)) AS lat_int,

    toInt32(round(lon * 100000)) AS lon_int
FROM fairq_raw.traffic_det_cross_sections
ORDER BY mq_id15 ASC;

-- fairq_raw.dwd_forecasts source

CREATE table fairq_raw.dwd_forecasts_processed
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
) Engine = ReplacingMergeTree order by (date_time, x, y);


