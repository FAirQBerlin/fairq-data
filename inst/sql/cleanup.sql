alter table {{ table }} delete where date_time < now() - interval 1 day;
