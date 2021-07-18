FROM debian:buster-slim AS downloader
ARG VERSION=0.18.1

RUN apt update && apt install -y curl gpg
COPY download_binary.sh thrasher-releases.asc ./
RUN bash download_binary.sh $VERSION


FROM debian:buster-slim

# Add user and setup directories
RUN useradd -ms /bin/bash litecoin \
    && mkdir -p /home/litecoin/.litecoin \
    && chown -R litecoin:litecoin /home/litecoin/.litecoin
USER litecoin

# Switch to home directory and install newly built binary
WORKDIR /home/litecoin
COPY --chown=litecoin:litecoin $BINARY /usr/local/bin/litecoind
COPY --chown=bitcoin:bitcoin --from=downloader /usr/local/bin/litecoind /usr/local/bin/litecoind

# Expose p2p and restricted RPC ports
EXPOSE 8332
EXPOSE 8333

ENTRYPOINT ["litecoind"]
