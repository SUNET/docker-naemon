FROM debian:bookworm

ENV DEBIAN_FRONTEND=noninteractive

# Depends for setting up a custom apt repo
RUN apt-get update && \
    apt-get install --no-install-recommends -y gpg curl ca-certificates lsb-release && \
    rm -rf /var/lib/apt/lists/*

# Setup custom repo and install thruk
COPY naemon.asc  /etc/apt/trusted.gpg.d/naemon.asc
RUN echo "deb [signed-by=/etc/apt/trusted.gpg.d/naemon.asc] http://download.opensuse.org/repositories/home:/naemon/Debian_$(lsb_release -rs)/ ./" >> /etc/apt/sources.list.d/naemon-stable.list

RUN apt-get update && \
    apt-get install --no-install-recommends -y naemon-core naemon-livestatus monitoring-plugins monitoring-plugins-contrib nagios-nrpe-plugin file jq && \
    rm -rf /var/lib/apt/lists/*
# No need of example configuration
RUN rm /etc/naemon/conf.d/printer.cfg \
       /etc/naemon/conf.d/switch.cfg \
       /etc/naemon/conf.d/localhost.cfg \
       /etc/naemon/conf.d/windows.cfg

# Depends for checks
RUN apt-get update && \
    apt-get install --no-install-recommends -y xsltproc bind9-dnsutils && \
    rm -rf /var/lib/apt/lists/*

COPY start.sh /
COPY naemon-commands-without-checks.cfg /etc/naemon/conf.d/naemon-commands-without-checks.cfg
COPY nagflux-commands.cfg /etc/naemon/conf.d/nagflux-commands.cfg
COPY nagflux-perfdata.cfg /etc/naemon/module-conf.d/nagflux-perfdata.cfg

CMD [ "/start.sh" ]
