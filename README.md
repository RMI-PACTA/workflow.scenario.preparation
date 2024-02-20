# workflow.scenario.preparation

<!-- badges: start -->
[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental) 
<!-- badges: end -->

The goal of `workflow.scenario.preparation` is to prepare all input scenario datasets required as input by both the [pactaverse](https://rmi-pacta.github.io/pactaverse/) R packages (for investors), and [r2dii](https://rmi-pacta.github.io/r2dii.analysis/) R packages (for banks).

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

## Run using Docker (preferred method)

### Create a `.env` file

Running this workflow requires a file called `.env` in the root directory, that looks like...

```
HOST_INPUTS_PATH=/PATH/TO/SCENARIO/DATA/INPUTS
HOST_OUTPUTS_PATH=/PATH/TO/SCENARIO/DATA/OUTPUTS
R_CONFIG_ACTIVE=YYYYQQ # this sets the active configuration in `config.yml`
```

You may use the `example.env` file as a template.

This file will specify the location of the input and output directories, and the active configuration set-up (see `config.yml` for more information).

### Running the Docker container

Run `docker-compose up` from the root directory, and docker will build the image (if necessary), and then run the scenario preparation process.

Use `docker-compose build --no-cache` to force a rebuild of the Docker image.

## Running using RStudio

Running in RStudio only supports input and output data in the `.inputs/` and `./outputs/` directories, respectively (relative to the root directory).

Set your `R_CONFIG_ACTIVE` by calling something like:
``` r
Sys.setenv(R_CONFIG_ACTIVE = "YYYYQQ")
```

then source `main.R`:

``` r
source("main.R")
```

(or you may also step through it line-by-line for debugging purposes).
