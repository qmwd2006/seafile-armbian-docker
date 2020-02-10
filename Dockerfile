FROM debian:buster

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update
RUN apt-get install --no-install-recommends -y htop net-tools psmisc procps tzdata
RUN apt-get install --no-install-recommends -y vim git wget curl
RUN apt-get install --no-install-recommends -y python2.7-dev python-ldap python-mysqldb
RUN apt-get install --no-install-recommends -y zlib1g-dev libjpeg-dev libmemcached-dev
RUN apt-get install --no-install-recommends -y gcc
RUN apt-get install --no-install-recommends -y ca-certificates

RUN curl -sSL -o /tmp/get-pip.py https://bootstrap.pypa.io/get-pip.py \
 && python /tmp/get-pip.py \
 && rm -rf /tmp/get-pip.py \
 && pip install -U wheel

ADD requirements.txt /tmp/requirements.txt
RUN pip install -r /tmp/requirements.txt

COPY scripts /scripts

WORKDIR /opt/seafile

RUN mkdir -p /opt/seafile/ && mkdir /shared/

ADD seafile-server_7.0.5_aarch64.tar.gz /opt/seafile/

RUN rm -rf \
    /root/.cache \
    /root/.npm \
    /root/.pip \
    /usr/local/share/doc \
    /usr/share/doc \
    /usr/share/man \
    /usr/share/vim/vim74/doc \
    /usr/share/vim/vim74/lang \
    /usr/share/vim/vim74/spell/en* \
    /usr/share/vim/vim74/tutor \
    /var/lib/apt/lists/* \
    /tmp/*

ENV SEAFILE_VERSION=7.0.5 SEAFILE_SERVER=seafile-server

CMD ["/usr/bin/python", "/scripts/start.py"]
