#!/bin/sh

test -d /opt/skywire || {
  echo "no docker volume mounted, exiting..."
  exit 1
}

conf_path=/opt/skywire
CONFIG_FILE=/opt/skywire/skywire-config.json
exec_path=/root/skywire

if [ ! -f $CONFIG_FILE ]; then
    cd $exec_path || exit
    skywire-cli visor gen-config --is-hypervisor
    cp ./skywire-config.json $conf_path/ 
else
    cp $CONFIG_FILE $exec_path/
fi

cmd="$(echo "$1" | tr -d '[:space:]')"
shift 1

echo "$@"

case "$cmd" in
skywire-visor)
  /usr/local/bin/"$cmd" -c $conf_path/skywire-config.json "$@"
  ;;
skywire-cli)
  /usr/local/bin/skywire-cli "$@"
  ;;
skychat | skysocks | skysocks-client)
  /apps/"$cmd" "$@"
  ;;
esac