# workflow.scenario.preparation

<!-- badges: start -->
[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental) 
<!-- badges: end -->

Welcome to `workflow.scenario.preparation`! This tool is designed to streamline the preparation of input scenario datasets for use in either [workflow.data.preparation](https://github.com/RMI-PACTA/workflow.data.preparation) or the [r2dii](https://rmi-pacta.github.io/r2dii.analysis/) R packages.

## Required Input Files

Ensure the following files exist in your input directory (default `./inputs`):

### GECO 2022

For GECO 2022, prepare the following files (TODO: Enhance this section):

- `geco2022_automotive_stocks_geco2021_retirement_rates_CORRECTED.csv`
- `GECO2022_Aviation_processed_data.csv`
- `geco2022_15c_ff_rawdata.csv`
- `geco2022_ndc_ff_rawdata.csv`
- `geco2022_ref_ff_rawdata.csv`
- `geco2022_15c_power_rawdata_region.csv`
- `geco2022_ndc_power_rawdata_region.csv`
- `geco2022_ref_power_rawdata_region.csv`
- `GECO2022_Steel_processed_data.csv`

## R_CONFIG_ACTIVE

Use the `R_CONFIG_ACTIVE` environment variable to specify the active configuration in `config.yml`. This configuration file determines the active quarter, expected scenarios, and the location of raw scenario files.


## Running with Docker (Preferred Method for `PROD`)

### Create a `.env` File

**This file is only necessary for running with `Docker`**

Create a `.env` file in the root directory with the following structure:

``` env
SCENARIO_PREPARATION_INPUTS_PATH=/PATH/TO/SCENARIO/DATA/INPUTS
SCENARIO_PREPARATION_OUTPUTS_PATH=/PATH/TO/SCENARIO/DATA/OUTPUTS
R_CONFIG_ACTIVE=YYYYQQ
```

You can use the `example.env` file as a template.

This file specifies the input/output directories and the active configuration (see `config.yml` for details).


### Running the Docker Container

Execute `docker-compose up` from the root directory to build the Docker image (if necessary) and run the scenario preparation process.

To force a rebuild of the Docker image, use `docker-compose build --no-cache`.

## Running with RStudio (Primarily for Easier Debugging and `DEV`)

Running in RStudio supports input/output data in the `.inputs/` and `./outputs/` directories, respectively (relative to the root directory).

Set `R_CONFIG_ACTIVE`:

```r
Sys.setenv(R_CONFIG_ACTIVE = "YYYYQQ")
```

Then, source `main.R`:

```r
source("main.R")
```

Alternatively, you can step through the script line-by-line for debugging.
