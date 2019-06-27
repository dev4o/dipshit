#!/bin/bash

while true; do
  if [ "$(systemctl is-active httpd)" == "active" ]; then
  exit 0

  elif [ "$(systemctl is-active httpd)" != "active" ]; then
  if $(sleep 2; systemctl restart httpd); then
        echo "Restarted httpd."
  exit 0
  fi
fi
done
