FROM debian:bullseye

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install --no-install-recommends -y gpg curl ca-certificates && \
    rm -rf /var/lib/apt/lists/*
RUN curl -sS https://labs.consol.de/repo/stable/RPM-GPG-KEY | gpg --dearmor > /usr/share/keyrings/labs.consol.de-5E3C45D7B312C643.gpg
RUN echo 'deb [signed-by=/usr/share/keyrings/labs.consol.de-5E3C45D7B312C643.gpg] http://labs.consol.de/repo/stable/debian bullseye main' > /etc/apt/sources.list.d/consol.list
RUN apt-get update && \
    apt-get install --no-install-recommends -y naemon-core naemon-livestatus nagios-plugins nagios-nrpe-plugin && \
    rm -rf /var/lib/apt/lists/*
# No need of example configuration
RUN rm /etc/naemon/conf.d/printer.cfg \
       /etc/naemon/conf.d/switch.cfg \
       /etc/naemon/conf.d/localhost.cfg \
       /etc/naemon/conf.d/windows.cfg

# Depends for check_metadata (used by SWAMID)
RUN apt-get update && \
    apt-get install --no-install-recommends -y xsltproc && \
    rm -rf /var/lib/apt/lists/*

COPY start.sh /

CMD [ "/start.sh" ]
