#!/bin/sh
set -eu

BASE_CONF="/mosquitto/config/mosquitto.base.conf"
FINAL_CONF="/mosquitto/config/mosquitto.conf"
PASSWD_FILE="/mosquitto/config/passwd"

ALLOW_ANON="${MQTT_ALLOW_ANONYMOUS:-false}"

# Build final config every start
cp "$BASE_CONF" "$FINAL_CONF"

# Ensure directories are writable
chown -R mosquitto:mosquitto /mosquitto/data /mosquitto/log

if [ "$ALLOW_ANON" = "true" ]; then
  {
    echo ""
    echo "# Auth mode: anonymous"
    echo "allow_anonymous true"
  } >> "$FINAL_CONF"

  echo "Anonymous mode enabled."
else
  if [ -z "${MQTT_USER:-}" ] || [ -z "${MQTT_PASSWORD:-}" ]; then
    echo "Error: MQTT_USER and MQTT_PASSWORD must be set when MQTT_ALLOW_ANONYMOUS is not true."
    exit 1
  fi

  # Create/update password file
  if [ ! -f "$PASSWD_FILE" ]; then
    mosquitto_passwd -b -c "$PASSWD_FILE" "$MQTT_USER" "$MQTT_PASSWORD"
  else
    mosquitto_passwd -b "$PASSWD_FILE" "$MQTT_USER" "$MQTT_PASSWORD"
  fi

  chown mosquitto:mosquitto "$PASSWD_FILE"
  chmod 0700 "$PASSWD_FILE" 2>/dev/null || true

  {
    echo ""
    echo "# Auth mode: password"
    echo "allow_anonymous false"
    echo "password_file $PASSWD_FILE"
  } >> "$FINAL_CONF"

  echo "Password mode enabled for user: $MQTT_USER"
fi

chown mosquitto:mosquitto "$FINAL_CONF"
exec mosquitto -c "$FINAL_CONF"
