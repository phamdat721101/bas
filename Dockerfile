# Build Geth in a stock Go builder container
FROM golang:1.17.0 as builder

RUN apt update && apt install --yes make gcc musl-dev git bash

WORKDIR /app

RUN git clone https://github.com/Ankr-network/bas-template-bsc.git
RUN cd bas-template-bsc && make geth

WORKDIR /app
# Pull Geth into a second stage deploy alpine container
FROM builder as test

COPY --from=builder app/bas-template-bsc/build/bin/geth /usr/local/bin/

EXPOSE 8545 8546 8547 30303 30303/udp
# ENTRYPOINT ["geth"]