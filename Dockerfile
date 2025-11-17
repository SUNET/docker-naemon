FROM debian:trixie

ENV DEBIAN_FRONTEND=noninteractive

# Depends for setting up a custom apt repo
RUN apt-get update && \
    apt-get install --no-install-recommends -y gpg curl ca-certificates lsb-release && \
    rm -rf /var/lib/apt/lists/*

# Setup custom repo and install thruk
COPY naemon.asc  /etc/apt/trusted.gpg.d/naemon.asc
RUN echo "deb [signed-by=/etc/apt/trusted.gpg.d/naemon.asc] http://download.opensuse.org/repositories/home:/naemon/Debian_$(lsb_release -rs)/ ./" >> /etc/apt/sources.list.d/naemon-stable.list

RUN apt-get update && \
    apt-get install --no-install-recommends -y \
      eapoltest                  \
      file                       \
      jq                         \
      monitoring-plugins         \
      monitoring-plugins-contrib \
      naemon-core                \
      naemon-livestatus          \
      nagios-nrpe-plugin         \
      python3                    \
      && \
    rm -rf /var/lib/apt/lists/*
# No need of example configuration
RUN rm /etc/naemon/conf.d/printer.cfg \
       /etc/naemon/conf.d/switch.cfg \
       /etc/naemon/conf.d/localhost.cfg \
       /etc/naemon/conf.d/windows.cfg

# Depends for checks
RUN apt-get update && \
    apt-get install --no-install-recommends -y xsltproc bind9-dnsutils bc php-cli php-curl && \
    rm -rf /var/lib/apt/lists/*

COPY start.sh /
COPY naemon-commands-without-checks.cfg /etc/naemon/conf.d/naemon-commands-without-checks.cfg
COPY nagflux-commands.cfg /etc/naemon/conf.d/nagflux-commands.cfg
COPY nagflux-perfdata.cfg /etc/naemon/module-conf.d/nagflux-perfdata.cfg
COPY livestatus_aggregate.cfg /etc/naemon/conf.d/livestatus_aggregate.cfg
COPY check_livestatus_aggregation /usr/lib/naemon/plugins/check_livestatus_aggregation

CMD [ "/start.sh" ]
