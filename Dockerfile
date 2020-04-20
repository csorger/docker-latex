FROM debian:jessie-slim

ARG DEBIAN_FRONTEND=noninteractive

# Create the user latex
ARG USER_NAME=latex
ARG USER_HOME=/home/latex
ARG USER_ID=1000
ARG USER_GECOS=LaTeX

RUN adduser \
  --home "$USER_HOME" \
  --uid $USER_ID \
  --gecos "$USER_GECOS" \
  --disabled-password \
  "$USER_NAME"

# Install apt-utils to avoid subsequent warnings of type
# "debconf: delaying package configuration, since apt-utils is not installed".
RUN apt-get update -y \
    && apt-get install -y --no-install-recommends apt-utils 2>&1 | grep -v "debconf: delaying package configuration, since apt-utils is not installed" \
    && rm -rf /var/lib/apt/lists/*

# Install and configure locales: perl scripts as latexindent use locale settings.
RUN apt-get update -y \
    && apt-get install -y locales \
    && rm -rf /var/lib/apt/lists/* \
    && sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen \
    && dpkg-reconfigure locales 2>&1 \
    && update-locale LANG=en_US.UTF-8

ENV LANG en_US.UTF-8 
ENV LANGUAGE en_US:en  
ENV LC_ALL en_US.UTF-8  

# Install texlive and some common latex tools
RUN apt-get update && apt-get install -y \
    texlive-full \
    biber \
    latexmk \
    make \
    pandoc \
    pandoc-citeproc \
    && apt-get --purge remove -y "texlive-*-doc" \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/*
