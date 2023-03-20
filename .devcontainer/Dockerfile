# R version: 4, 4.1, 4.2
ARG VARIANT="4.2"
FROM rocker/tidyverse:${VARIANT}

# key dependencies for utilities
RUN apt-get update -qq \
  && export DEBIAN_FRONTEND=noninteractive \
  && apt-get -y install --no-install-recommends libxt6 curl libglpk-dev python3-pip

# install chrome for shinytest2
RUN curl -L https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -o /tmp/chrome.deb
RUN apt-get update -qq \
  && apt-get -y install ./tmp/chrome.deb

# install radian
RUN pip3 install radian

# install R package dependencies
RUN install2.r shinyjs purrr jsonlite remotes devtools dplyr stringr tidyr shiny colourpicker htmltools shinyWidgets shinyvalidate visNetwork igraph

USER rstudio
