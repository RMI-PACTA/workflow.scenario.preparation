# workflow.scenario.preparation

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental) 
<!-- badges: end -->

The goal of `workflow.scenario.preparation` is to prepare all input scenario datasets required as input by both the [pactaverse](https://rmi-pacta.github.io/pactaverse/) R packages (for investors), and [r2dii](https://rmi-pacta.github.io/r2dii.analysis/) R packages (for banks).

## Create a `.env` file

Running this workflow requires a file called `.env` in the root directory, that looks like...

```
HOST_INPUTS_PATH=/users/scenario_data/inputs
HOST_OUTPUTS_PATH=/users/scenario_data/outputs
R_CONFIG_ACTIVE=YYYYQQ
```

This file will specify the location of the input and output directories, and the active configuration set-up (see `config.yml` for more information).

## Required Input Files

All required files must exist at `$HOST_INPUTS_PATH`.

### General files

These files are required for the preparation of all scenarios:

- `technology_bridge.csv`

### GECO 2022

Files to prepare GECO 2022 are (TODO: Improve the state of this):

- `geco2022_automotive_stocks_geco2021_retirement_rates_CORRECTED.csv`
- `GECO2022_Aviation_processed_data.csv`
- `geco2022_15c_ff_rawdata.csv`
- `geco2022_ndc_ff_rawdata.csv`
- `geco2022_ref_ff_rawdata.csv`
- `geco2022_15c_power_rawdata_region.csv`
- `geco2022_ndc_power_rawdata_region.csv`
- `geco2022_ref_power_rawdata_region.csv`
- `GECO2022_Steel_processed_data.csv`

## Running in Docker

Run `docker-compose up` from the root directory, and docker will build the image (if necessary), and then run the scenario preparation process.

Use `docker-compose build --no-cache` to force a rebuild of the Docker image.

## Running in RStudio

Make sure to load your `.env` file into your R environment, then source `main.R`:

``` r
readRenviron(".env")
source("main.R")
```
