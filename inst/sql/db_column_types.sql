select 
  database, 
  table, 
  name, 
  type 
from 
  system.columns 
where
  database in ('fairq_raw', 'fairq_features', 'fairq_output', 'fairq_prod_features', 'fairq_prod_output');
