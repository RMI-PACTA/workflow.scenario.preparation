# using rocker r-vers as a base with R 4.3.1
# https://hub.docker.com/r/rocker/r-ver
# https://rocker-project.org/images/versioned/r-ver.html
ARG R_VERS="4.3.1"
FROM rocker/r-ver:$R_VERS AS base

# set Docker image labels
LABEL org.opencontainers.image.source=https://github.com/RMI-PACTA/workflow.scenario.preparation
LABEL org.opencontainers.image.description="Docker image to run scenario preparation"
LABEL org.opencontainers.image.licenses=MIT
LABEL org.opencontainers.image.title=""
LABEL org.opencontainers.image.revision=""
LABEL org.opencontainers.image.version=""
LABEL org.opencontainers.image.vendor=""
LABEL org.opencontainers.image.base.name=""
LABEL org.opencontainers.image.ref.name=""
LABEL org.opencontainers.image.authors=""

WORKDIR /app

# set apt-get to noninteractive mode
ARG DEBIAN_FRONTEND="noninteractive"
ARG DEBCONF_NOWARNINGS="yes"

# install system dependencies
RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    libicu-dev=70.1-* \
    libxml2-dev=2.9.* \
  && rm -rf /var/lib/apt/lists/*

# sets CRAN repo to use Posit Package Manager to freeze R package versions to
# those available on 2023-10-30
# https://packagemanager.posit.co/client/#/repos/2/overview
# https://packagemanager.posit.co/cran/__linux__/jammy/2023-10-30
ARG CRAN_REPO="https://packagemanager.posit.co/cran/__linux__/jammy/2023-10-30"

RUN echo "options(repos = c(CRAN = '$CRAN_REPO'), pkg.sysreqs = FALSE)" >> "${R_HOME}/etc/Rprofile.site" \
  && Rscript -e "\
  install.packages('pak'); \
  "

# copy in DESCRIPTION from this repo
COPY DESCRIPTION /app/DESCRIPTION

# install pak, find dependencies from DESCRIPTION, and install them
RUN Rscript -e "\
  deps <- pak::local_deps(root = '.'); \
  pkg_deps <- deps[!deps[['direct']], 'ref']; \
  print(pkg_deps); \
  pak::pak(pkg_deps); \
  "
COPY config.yml /app/config.yml
COPY *.R /app/

CMD ["Rscript", "/app/main.R"]

