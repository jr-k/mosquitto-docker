## Mosquitto with username/password from environment variables

### Start
cp .env.example .env
docker compose up -d --build

### Logs
docker logs -f mosquitto

### Test
mosquitto_sub -h localhost -p 1883 -u "$MQTT_USER" -P "$MQTT_PASSWORD" -t test
mosquitto_pub -h localhost -p 1883 -u "$MQTT_USER" -P "$MQTT_PASSWORD" -t test -m "hello"
