FROM debian:bookworm

LABEL maintainer="Christoph Sorger <christoph.sorger@gmail.com>"

ARG DEBIAN_FRONTEND=noninteractive

# Set the Timezone
ENV TZ="Europe/Paris"

# Configure locales
RUN apt-get update -qq \
    && apt-get install -y locales \
    && rm -rf /var/lib/apt/lists/* \
    && sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen \
    && dpkg-reconfigure locales 2>&1 \
    && update-locale LANG=en_US.UTF-8

ENV LANG=en_US.UTF-8 
ENV LANGUAGE=en_US:en  
ENV LC_ALL=en_US.UTF-8  

# Install texlive and some common latex tools
RUN apt-get update -qq \
    && apt-get install -y sudo wget git texlive-full biber latexmk make pandoc \
    && apt-get --purge remove -y "texlive-*-doc" \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/*

# Set the default shell
ENV SHELL /bin/bash

# Create the latex user
ARG USERNAME=latex
ARG USER_UID=1000
ARG USER_GID=${USER_UID}
ARG USER_HOME=/home/${USERNAME}

RUN groupadd --gid $USER_GID ${USERNAME} \
    && useradd --uid ${USER_UID} --gid ${USER_GID} --home-dir ${USER_HOME} --create-home ${USERNAME} \
    && echo ${USERNAME} ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/${USERNAME} \
    && chmod 0440 /etc/sudoers.d/${USERNAME}

# Run everything from now on as the sage user in sage's home
USER ${USERNAME}
ENV HOME ${HOME}
WORKDIR ${HOME}

CMD ["bash"]