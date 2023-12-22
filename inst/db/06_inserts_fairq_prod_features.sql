-- insert into  fairq_prod_features.statdstruktur_features
insert into fairq_prod_features.statdstruktur_features (*)
select 
  berlin.x as x,
  berlin.y as y,
  land.grauflaeche as grauflaeche,
  land.gewaesser as gewaesser,
  land.gruenflaeche as gruenflaeche,
  land.infrastruktur as infrastruktur,
  land.mischnutzung as mischnutzung,
  land.wald as wald,
  land.wohnnutzung as wohnnutzung,
  buildings.density as density,
  tint.traffic_intensity_kfz as traffic_intensity_kfz,
  emi.nox_h_15 as nox_h_15,
  emi.nox_i_15 as nox_i_15,
  emi.nox_v_gn15 as nox_v_gn15,
  emi.pm10_i_15 as pm10_i_15
from
  fairq_prod_features.coord_stadt_berlin as berlin
left join
  fairq_prod_features.land_use AS land
  on (berlin.x = land.x) and (berlin.y = land.y)
left join
  fairq_prod_features.emissions AS emi
  ON (land.x = emi.x) AND (land.y  = emi.y)
left join
  fairq_prod_features.traffic_volume AS traffic_vol
  ON (land.x = traffic_vol.x) AND (land.y  = traffic_vol.y)
left join
  fairq_prod_features.traffic_intensity AS tint
  ON (land.x = tint.x) AND (land.y  = tint.y)
left join
  fairq_prod_features.buildings
  ON (land.x = buildings.x) AND (land.y  = buildings.y);


insert into fairq_prod_features.coords_grid_batches (*)
with rn as (
select
  id,
  x,
  y,
  (row_number() over()) row -- get row numbers
from
  fairq_prod_features.coord_stadt_berlin
)
select
  id,
  x,
  y,
  -- each 3007 rownumbers are one batch.
  -- the number makes the batches as equally sized as possible, still fitting in memory.
  ceil(row / 6013)::int as batch
from
  rn;
  
insert into fairq_prod_features.coords_grid_sim_batches (*)
select 
  stadt_x x, 
  stadt_y y, 
  element_nr, 
  strassenname, 1 as batch  
from 
  fairq_prod_features.coord_mapping_stadt_streets
inner join
  fairq_raw.stadtstruktur_network_streets using(element_nr)
where 
element_nr in ('38550024_38550010.02', '45510028_45520013.01');
  
insert into fairq_prod_features.stations_for_predictions (station_id, id, is_active)
values ('010', 'MC 010', true), ('014', 'MC 014', false), ('018', 'MC 018', true), ('027', 'MC 027', true), ('032', 'MC 032_u', true), ('042', 'MC 042', true), ('077', 'MC 077', true), ('085', 'MC 085', true), ('115', 'MC 115', true), ('117', 'MC 117', true), ('124', 'MC 124', true), ('143', 'MC 143', true), ('145', 'MC 145', true), ('171', 'MC 171', true), ('174', 'MC 174', true), ('190', 'MC 190', true), ('220', 'MC 220', false), ('221', 'MC 221', true), ('282', 'MC 282', true);


insert into fairq_prod_features.scaling_kfz_station
with kkfz as (
select 
  distinct round(kfz_per_24h / 1000) kkfz_per_24h
from 
  fairq_prod_features.traffic_model_scaling
order by kkfz_per_24h
)
select 
  kkfz_per_24h, 
  1 - round(sigmoid(log(kkfz_per_24h * kkfz_per_24h + 0.01) - 4.05), 2) scaling_stadtrand 
from 
  kkfz;


insert into fairq_prod_features.mapping_stations_dwd
with coords_dwd as (
select distinct 
 x, 
 y,
 lat_int / 100000 as lat,
 lon_int / 100000 as lon
from 
 fairq_prod_features.dwd_observations_filled
inner join 
 fairq_prod_features.mapping_reprojection using(x, y)
 ),
coords_stations as (
select distinct 
 station_id, 
 x, 
 y,
 lat_int / 100000 as lat,
 lon_int / 100000 as lon
from 
 fairq_prod_features.messstationen_filled
inner join 
 fairq_prod_features.mapping_reprojection using(x, y)
),
dists as (
select 
 x,
 y,
 station_id,
 coords_stations.x,
 coords_stations.y,
 geoDistance(coords_dwd.lon, coords_dwd.lat, coords_stations.lon, coords_stations.lat) AS dist 
from 
 coords_dwd
CROSS JOIN 
 coords_stations
)
select 
 station_id,
 argMin((x, y), dist).1 as dwd_x,
 argMin((x, y), dist).2 as dwd_y,
 coords_stations.x as station_x,
 coords_stations.y as station_y
from 
 dists
group by station_id, coords_stations.x, coords_stations.y;

insert into fairq_prod_features.coord_stadt_all
select distinct x, y from fairq_prod_features.streets;

insert into fairq_prod_features.coord_mapping_stadt_station
with coords_station as (
select distinct
 station_id, 
 x, 
 y
from
 fairq_prod_features.messstationen_filled
),
 dists as (
 select
   station_id,
   coords_station.x as station_x,
   coords_station.y as station_y,
   coord_stadt_all.x,
   coord_stadt_all.y,
   L2Distance((coords_station.x, coords_station.y), (coord_stadt_all.x, coord_stadt_all.y)) AS dist
from
 coords_station
CROSS JOIN
 fairq_prod_features.coord_stadt_all
 )
select
 station_id,
 station_x,
 station_y,
 argMin((coord_stadt_all.x, coord_stadt_all.y), dist).1 as stadt_x,
 argMin((coord_stadt_all.x, coord_stadt_all.y), dist).2 as stadt_y
from
 dists
group by station_id, station_x, station_y;


insert into fairq_prod_features.coord_mapping_stadt_station (*) 
values ('014', 383544, 5819878, 383575, 5819875);

insert into  fairq_prod_features.coord_mapping_stations_cams
with coords_cams as (
select distinct 
 x, 
 y
from 
 fairq_prod_features.latest_cams
 ),
coords_stations as (
select distinct 
 station_id, 
 x, 
 y
from 
 fairq_prod_features.messstationen_filled
inner join 
 fairq_prod_features.mapping_reprojection using(x, y)
),
dists as (
select 
 x,
 y,
 station_id,
 coords_stations.x,
 coords_stations.y,
 L2Distance((coords_cams.x, coords_cams.y), (coords_stations.x, coords_stations.y)) AS dist 
from 
 coords_cams
CROSS JOIN 
 coords_stations
)
select 
 station_id,
 argMin((x, y), dist).1 as cams_x,
 argMin((x, y), dist).2 as cams_y,
 coords_stations.x as station_x,
 coords_stations.y as station_y
from 
 dists
group by station_id, coords_stations.x, coords_stations.y;

insert into fairq_prod_features.coord_mapping_stadt_det
with coords_det as (
select distinct
    `mq_short_name` as mq_name,
	x,
	y
from
	fairq_raw.traffic_det_cross_sections_processed
inner join
  fairq_prod_features.mapping_reprojection using(lat_int, lon_int)
),
 dists as (
 select
   mq_name,
   coords_det.x as det_x,
   coords_det.y as det_y,
   coords_stadt.x,
   coords_stadt.y,
   L2Distance((coords_det.x, coords_det.y), (coords_stadt.x, coords_stadt.y)) AS dist
from
 coords_det
CROSS JOIN
 fairq_prod_features.coord_stadt_all coords_stadt
 )
select
 mq_name,
 det_x,
 det_y,
 argMin((coords_stadt.x, coords_stadt.y), dist).1 as stadt_x,
 argMin((coords_stadt.x, coords_stadt.y), dist).2 as stadt_y
from
 dists
group by mq_name,det_x, det_y;

insert into fairq_prod_features.coord_mapping_stadt_det
values ('TE057', 396657, 5817803, 396625, 5817775), ('TE112', 389797, 5811447, 389775, 5811475);

insert into fairq_prod_features.coord_mapping_stadt_det
values ('TE184', 391431, 5819100, 391425, 5819075), ('TE248', 402099, 5824263, 402125, 5824275);

insert into fairq_prod_features.coord_mapping_stadt_det
values ('TE261', 385808, 5819552, 385825, 5819525), ('TE077', 389777, 5818951, 389775, 5818925);

insert into fairq_prod_features.coord_mapping_stadt_det
values ('TE078', 389776, 5818956, 389775, 5818925), ('TE323', 385405, 5818699, 385425, 5818725);

insert into fairq_prod_features.coord_mapping_stadt_det
values ('TE152', 385848, 5823249, 385875, 5823275), ('TE476', 390876, 5817453, 390875, 5817425);

insert into fairq_prod_features.coord_mapping_stadt_det
values ('TE490', 392854, 5823765, 392825, 5823725), ('TE503', 388334, 5820615, 388325, 5820575);

insert into fairq_prod_features.coord_mapping_stadt_det
values ('TE469', 391848, 5820166, 391875, 5820125), ('TE470', 391848, 5820166, 391875, 5820125);

insert into fairq_prod_features.coord_mapping_stadt_det
values ('TE493', 392732, 5820706, 392725, 5820675), ('TE494', 392732, 5820706, 392725, 5820675);

insert into fairq_prod_features.coord_mapping_stadt_det
values ('TE539', 399088, 5806369, 398875, 5806775), ('TE578', 389693, 5813515, 389725, 5813525);

insert into fairq_prod_features.coord_mapping_stadt_det
values ('TE582', 390197, 5813184, 390225, 5813175), ('TE592', 384744, 5819034, 384775, 5819025);


insert
	into
	fairq_prod_features.coord_mapping_stadt_dwd

with coords_dwd as (
select
	distinct
	  x,
	  y
from
		fairq_prod_features.dwd_observations_filled
),
	dists as (
select
		coords_stadt.x as stadt_x,
		coords_stadt.y as stadt_y,
		coords_dwd.x dwd_x,
		coords_dwd.y dwd_y,
		L2Distance((stadt_x,
		stadt_y),
		(dwd_x,
		dwd_y)) AS dist
from
		coords_dwd
CROSS JOIN
 fairq_prod_features.coord_stadt_all coords_stadt
 )

select
	stadt_x,
	stadt_y,
	argMin((dists.dwd_x,
	dists.dwd_y),
	dist).1 as dwd_x,
	argMin((dists.dwd_x,
	dists.dwd_y),
	dist).2 as dwd_y
from
	dists
group by
	stadt_x,
	stadt_y;

