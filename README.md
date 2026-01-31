## Mosquitto with runtime auth mode (anonymous or user/password)

### Start
cp .env.example .env
docker compose up -d --build

### Logs
docker logs -f mosquitto

### Test (password mode)
mosquitto_sub -h localhost -p 1883 -u "$MQTT_USER" -P "$MQTT_PASSWORD" -t test
mosquitto_pub -h localhost -p 1883 -u "$MQTT_USER" -P "$MQTT_PASSWORD" -t test -m "hello"

### Test (anonymous mode)
mosquitto_sub -h localhost -p 1883 -t test
mosquitto_pub -h localhost -p 1883 -t test -m "hello"
