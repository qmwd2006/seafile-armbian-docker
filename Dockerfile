FROM debian:buster

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update -qq
RUN apt-get install -qq -y vim htop net-tools psmisc git wget curl tzdata

RUN apt-get install -y python2.7-dev python-ldap python-mysqldb zlib1g-dev libmemcached-dev gcc
RUN curl -sSL -o /tmp/get-pip.py https://bootstrap.pypa.io/get-pip.py && \
    python /tmp/get-pip.py && \
    rm -rf /tmp/get-pip.py && \
    pip install -U wheel

ADD requirements.txt  /tmp/requirements.txt
RUN pip install -r /tmp/requirements.txt

COPY scripts /scripts

WORKDIR /opt/seafile

RUN mkdir -p /opt/seafile/
COPY seafile-server_7.0.5_aarch64.tar.gz /opt/seafile
RUN tar xzf /opt/seafile/seafile-server_7.0.5_aarch64.tar.gz -C /opt/seafile

RUN rm -rf \
    /opt/seafile/seafile-server_7.0.5_aarch64.tar.gz
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
