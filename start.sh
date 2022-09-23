#!/usr/bin/env bash

/bin/mkdir -p /var/run/naemon/

cat << EOF > /etc/naemon/module-conf.d/livestatus.cfg
broker_module=/usr/lib/naemon/naemon-livestatus/livestatus.so inet_addr=0.0.0.0:6666
event_broker_options=-1
EOF

/usr/bin/naemon --allow-root /etc/naemon/naemon.cfg
