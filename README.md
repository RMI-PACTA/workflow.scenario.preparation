# workflow.scenario.preparation

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental) 
<!-- badges: end -->

The goal of `workflow.scenario.preparation` is to prepare all input scenario datasets required as input by both the [pactaverse](https://rmi-pacta.github.io/pactaverse/) R packages (for investors), and [r2dii](https://rmi-pacta.github.io/r2dii.analysis/) R packages (for banks).

## Setting up the `.env` file

Running this workflow requires a file `.env` to exist in the root directory, that looks like...

```
HOST_INPUTS_PATH=/users/scenario_data/inputs
HOST_OUTPUTS_PATH=/users/scenario_data/outputs
```

## Running the docker image

Run `docker-compose up` from the root directory, and docker will build the image (if necessary), and then run the scenario preparation process.

Use `docker-compose build --no-cache` to force a rebuild of the Docker image.
