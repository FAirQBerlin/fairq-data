
This repository contains R code to run main ETLs that are needed to bring the data from the output of the air pollution model (fairq-model) to the api (fairq-api). Additionally it contains code to maintain the central Clickhouse database and to monitor its documentation status.


## How to get started

- Create an .Renviron file in the project folder, see `.Renviron_template` for 
the structure
- Build the R package
- Create database as described in https://github.com/FAirQBerlin/fairq-data/tree/public/inst/db 


## Most important files

### ETLs for transferring data to the API
- Stations: [`inst/RScripts/main_stations.R`](https://github.com/FAirQBerlin/fairq-data/blob/public/inst/RScripts/main_stations.R) transfers the air pollution predictions at the measurement stations to the table `api_stations`, which is directly used by the api endpoint `/stations`
- Grid, Streets, and LOR ("Lebensweltlich orientierte Räume"): [`inst/RScripts/main_grid.R`](https://github.com/FAirQBerlin/fairq-data/blob/public/inst/RScripts/main_grid.R) transfers the air pollution predictions on the grid of Berlin to the table `api_grid` which is directly used by the api endpoint `/grid`. This script also aggregates the grid predictions on street and LOR level and transfers the aggregates to the table `api_street` resp. `api_lor`, directly used by the api endpoint `/street` (or `/lor`)
- Simulation: [`inst/RScripts/main_grid_sim.R`](https://github.com/FAirQBerlin/fairq-data/blob/public/inst/RScripts/main_grid_sim.R) aggregates the hourly air pollution predictions with simulated car numbers to street level and daily temporal resolution. Writes the results into the table `api_simulation`, which is directly used by the `/simulation` endpoint.

### Cleanup tables
- [`inst/RScripts/cleanup.R`](https://github.com/FAirQBerlin/fairq-data/blob/public/inst/RScripts/cleanup.R) cleans the tables during nighttime.

### DB Check
- [`inst/RScripts/db_check.R`](https://github.com/FAirQBerlin/fairq-data/blob/public/inst/RScripts/db_check.R) regularly checks if the database defined in [`inst/db`](https://github.com/FAirQBerlin/fairq-data/tree/public/inst/db) is setting up a database with the same tables as our productive clickhouse db. Additionally it checks for differences in the database between the development (DEV) stage and production (PROD) stage. During development of new features, it may be ok that this script throws an error - especially if there are features in DEV stage on the database, which are not yet in the PROD stage.


## Input and output

### Input

The following database tables for the ETL jobs in the schema fairq_{prod}_output are required:
- stations: ```model_predictions_temporal```
- grid and street predictions: ```model_predictions_grid```
- simulation: ```model_predictions_grid_sim```

### Output

Output of the ETL jobs is written to the following database tables in the schema fairq_{prod}_output :
- for stations: ```api_stations```
- for grid and street predictions: ```api_grid```, ```api_streets``` and ```api_lor```
- for simulation: ```api_stations```

## Code style

Please use the RStudio code autoformatter by pressing `Ctrl + Shift + A`
to format the selected code. Additionally, lintr is used in ```tests/testthat```. Tests are run automatically after each commit using Jenkins.
