#!/usr/bin/env bash

/bin/mkdir -p /var/run/naemon
/bin/mkdir -p /var/log/naemon/archives
/bin/mkdir -p /var/naemon
/bin/mkdir -p /var/nagflux/perfdata

cat << EOF > /etc/naemon/module-conf.d/livestatus.cfg
broker_module=/usr/lib/naemon/naemon-livestatus/livestatus.so inet_addr=0.0.0.0:6666
event_broker_options=-1
EOF

# Use commands defined by nagios-nrpe-plugin
echo "include_dir=/etc/nagios-plugins/config/" > /etc/naemon/conf.d/commands.cfg

exec /usr/bin/naemon --allow-root /etc/naemon/naemon.cfg
