FROM debian:buster-slim
ARG BINARY=litecoind.0.18.1-arm-linux-gnueabihf

# Add user and setup directories for monerod
RUN useradd -ms /bin/bash litecoin && mkdir -p /home/litecoin/.litecoin \
    && chown -R litecoin:litecoin /home/litecoin/.litecoin
USER litecoin

# Switch to home directory and install newly built monerod binary
WORKDIR /home/litecoin
COPY --chown=litecoin:litecoin $BINARY /usr/local/bin/litecoind

# Expose p2p and restricted RPC ports
EXPOSE 8332
EXPOSE 8333

ENTRYPOINT ["litecoind"]
