#!/bin/sh
set -eu

PASSWD_FILE="/mosquitto/config/passwd"
CONF_FILE="/mosquitto/config/mosquitto.conf"

ALLOW_ANON="${MQTT_ALLOW_ANONYMOUS:-false}"

if [ "$ALLOW_ANON" != "true" ]; then
  if [ -z "${MQTT_USER:-}" ] || [ -z "${MQTT_PASSWORD:-}" ]; then
    echo "Error: MQTT_USER and MQTT_PASSWORD must be set (or MQTT_ALLOW_ANONYMOUS=true)."
    exit 1
  fi

  # Create/update password file
  # Use -c only when creating a new file
  if [ ! -f "$PASSWD_FILE" ]; then
    mosquitto_passwd -b -c "$PASSWD_FILE" "$MQTT_USER" "$MQTT_PASSWORD"
  else
    mosquitto_passwd -b "$PASSWD_FILE" "$MQTT_USER" "$MQTT_PASSWORD"
  fi

  chmod 0700 "$PASSWD_FILE" 2>/dev/null || true
else
  echo "MQTT_ALLOW_ANONYMOUS=true: authentication disabled."
fi

exec mosquitto -c "$CONF_FILE"
