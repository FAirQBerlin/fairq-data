select 
  database,
  name as table,
  engine
from 
  system.tables 
where is_temporary = 0
and database in ('fairq_raw', 'fairq_features', 'fairq_output', 'fairq_prod_features', 'fairq_prod_output');
