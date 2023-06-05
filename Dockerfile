FROM --platform=linux/amd64 rocker/tidyverse

# install system dependencies for R packages
RUN apt-get update \
  && apt-get install -y libcurl4-openssl-dev libssl-dev make libicu-dev libxml2-dev \
  zlib1g-dev libfontconfig1-dev libfreetype6-dev libfribidi-dev libharfbuzz-dev libjpeg-dev \
  libpng-dev libtiff-dev pandoc git libgit2-dev \
  && rm -rf /var/lib/apt/lists/*

RUN Rscript -e 'install.packages(c("pak", "renv"))'

COPY . /workflow.scenario.preparation

WORKDIR /workflow.scenario.preparation

RUN Rscript -e '\
  readRenviron(".env"); \
  non_cran_pkg_deps <- c("RMI-PACTA/pacta.scenario.data.preparation"); \
  cran_pkg_deps <- setdiff(renv::dependencies()$Package, basename(non_cran_pkg_deps)); \
  pak::pkg_install(pkg = c(non_cran_pkg_deps, cran_pkg_deps)); \
  '

CMD Rscript run_pacta_scenario_preparation.R
