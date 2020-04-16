#!/bin/sh
conf_path=/root/skywire/config
exec_path=/root/skywire-mainnet

userid=0 # 65534 - nobody, 0 - root
groupid=0

if [ ! -f $conf_path/hypervisor-config.json ]; then
    cd $exec_path
    hypervisor gen-config
    cp ./hypervisor-config.json $conf_path/
else
    cp $conf_path/hypervisor-config.json $exec_path/
fi

if [[ -n "$PUID" && -n  "$PGID" ]]; then
    userid=$PUID
    groupid=$PGID
fi

chown -R $userid:$groupid $exec_path

cd $exec_path

su-exec $userid:$groupid hypervisor