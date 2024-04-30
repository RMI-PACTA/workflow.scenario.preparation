# workflow.scenario.preparation

<!-- badges: start -->
[![Lifecycle: stable](https://img.shields.io/badge/lifecycle-stable-brightgreen.svg)](https://lifecycle.r-lib.org/articles/stages.html#stable)
[![docker](https://github.com/RMI-PACTA/workflow.scenario.preparation/actions/workflows/docker.yml/badge.svg)](https://github.com/RMI-PACTA/workflow.scenario.preparation/actions/workflows/docker.yml)
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

Alternatively, you can read in the `.env` file (specified above for the Docker process) and run the process with:

```r
readRenviron(".env"); source("main.R")
```

⚠️ When opening a built-in Terminal pane in RStudio, RStudio copies in any environment variables that were available when RStudio starts. That can have the effect of overwriting/ignoring the environment variables in the `.env` file if you try to build/run the Docker container from there.

## Running on Azure Container Instances

A parameter file with the values that the RMI-PACTA team uses for extracting data is available at [`azure-deploy.rmi-pacta.parameters.json`](azure-deploy.rmi-pacta.parameters.json).

```sh
# run from repo root

# change this value as needed.
RESOURCEGROUP="RMI-SP-PACTA-DEV"

# Users with access to the RMI-PACTA Azure subscription can run:
az deployment group create --resource-group "$RESOURCEGROUP" --template-file azure-deploy.json --parameters azure-deploy.rmi-pacta.parameters.json

```

For security, the RMI-PACTA parameters file makes heavy use of extracting secrets from an Azure Key vault, but an example file that passes parameters "in the clear" is available as [`azure-deploy.example.parameters.json`](azure-deploy.example.parameters.json)

Non RMI-PACTA users can define their own parameters and invoke the ARM Template with:

```sh
# Otherwise:
# Prompts for parameters without defaults
az deployment group create --resource-group "$RESOURCEGROUP" --template-file azure-deploy.json 

# if you have created your own parameters file:
az deployment group create --resource-group "$RESOURCEGROUP" --template-file azure-deploy.json --parameters @azure-deploy.parameters.json
```

### Preparing GitHub Actions Runner

The GitHub Actions workflow to run this workflow starts an Azure Container Instance.
To prepare the Azure landscape:

1. Create a User Assigned Managed identity for the repo as described [here](https://github.com/marketplace/actions/azure-login#login-with-openid-connect-oidc-recommended)
2. Manually start a container group with `azure-deploy.json` as documented above
3. Grant `Contributor` role on the new Container Group to the Managed Identity
4. Grant `Managed Application Contributor Role` Role to the Managed Identity for the Resource Group in which the Container Group will run
5. Ensure the Managed identity [has deploy permissions](https://learn.microsoft.com/en-us/azure/azure-resource-manager/templates/key-vault-parameter?tabs=azure-cli#grant-deployment-access-to-the-secrets) to the key vault (if needed)
6. Ensure the Managed Identity has the `Managed Identity Operator` Role for the managed idenity used by the container group (specified with the `identity` parameter in the deploy template).

See the [Microsoft documentation](https://learn.microsoft.com/en-us/azure/container-instances/container-instances-github-action?tabs=userlevel) for more information on setting up GH Actions.
