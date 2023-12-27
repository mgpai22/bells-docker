#!/bin/sh
set -e

if [ $(echo "$1" | cut -c1) = "-" ]; then
  echo "$0: assuming arguments for bellsd"

  set -- bellsd "$@"
fi

if [ $(echo "$1" | cut -c1) = "-" ] || [ "$1" = "bellsd" ]; then
  mkdir -p "$BELLS_DATA"
  chmod 770 "$BELLS_DATA" || echo "Could not chmod $BELLS_DATA (may not have appropriate permissions)"
  chown -R bells "$BELLS_DATA" || echo "Could not chown $BELLS_DATA (may not have appropriate permissions)"

  echo "$0: setting data directory to $BELLS_DATA"

  set -- "$@" -datadir="$BELLS_DATA"
fi

if [ "$(id -u)" = "0" ] && ([ "$1" = "bellsd" ] || [ "$1" = "bells-cli" ] || [ "$1" = "bells-tx" ]); then
  set -- gosu bells "$@"
fi

exec "$@"