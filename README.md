# docker-latex

## Description

The `dockerfile` to build [csorger/latex](https://hub.docker.com/r/csorger/latex)
on [hub.docker.com](https://hub.docker.com).

The images contain a distribution of latex and friends on debian bookworm

- texlive-full
- biber
- latexmk
- pandoc

## Built and pushed using

docker build -t csorger/latex .
docker push csorger/latex