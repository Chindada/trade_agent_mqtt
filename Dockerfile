FROM debian:bullseye as production-stage
USER root

ENV DEPLOYMENT=docker
ENV TZ=Asia/Taipei

WORKDIR /
RUN mkdir trade_agent_mqtt
WORKDIR /trade_agent_mqtt
COPY . .

RUN apt update && \
    apt install -y tzdata wget gnupg && \
    wget http://repo.mosquitto.org/debian/mosquitto-repo.gpg.key && \
    apt-key add mosquitto-repo.gpg.key && \
    wget http://repo.mosquitto.org/debian/mosquitto-jessie.list -O /etc/apt/sources.list.d/mosquitto-jessie.list && \
    wget http://repo.mosquitto.org/debian/mosquitto-stretch.list -O /etc/apt/sources.list.d/mosquitto-stretch.list && \
    wget http://repo.mosquitto.org/debian/mosquitto-buster.list -O /etc/apt/sources.list.d/mosquitto-buster.list && \
    apt update && \
    apt install -y mosquitto && \
    apt autoremove -y && \
    apt clean && \
    rm -rf /var/lib/apt/lists/*

ENTRYPOINT ["/trade_agent_mqtt/scripts/docker-entrypoint.sh"]
