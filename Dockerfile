FROM eclipse-mosquitto:latest

COPY mosquitto.base.conf /mosquitto/config/mosquitto.base.conf
COPY entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/bin/sh", "/entrypoint.sh"]
