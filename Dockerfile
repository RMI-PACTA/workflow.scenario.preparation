FROM --platform=linux/amd64 rocker/tidyverse

# install system dependencies for R packages
RUN apt-get update \
  && rm -rf /var/lib/apt/lists/*

# copy in DESCRIPTION from this repo
COPY DESCRIPTION /DESCRIPTION

# install pak, find dependencies from DESCRIPTION, and install them
RUN Rscript -e "\
    install.packages('pak'); \
    deps <- pak::local_deps(root = '.'); \
    pkg_deps <- deps[!deps[['direct']], 'ref']; \
    print(pkg_deps); \
    pak::pak(pkg_deps); \
    "

COPY . /workflow.scenario.preparation

WORKDIR /workflow.scenario.preparation

CMD Rscript run_pacta_scenario_preparation.R
