FROM python:slim-bookworm

COPY . /tmp/elastalert

RUN apt update && \
    apt install git -y && \
    git clone https://github.com/HASecuritySolutions-Docker/elastalert2.git && \
    mv elastalert2 /tmp/elastalert && \
    mkdir -p /opt/elastalert && \
    cd /tmp/elastalert && \
    pip install setuptools wheel && \
    python setup.py sdist bdist_wheel && \
    cp /tmp/elastalert/dist/*.tar.gz /tmp/ && \
    apt update && apt -y upgrade && \
    apt -y install jq curl gcc libffi-dev && \
    rm -rf /var/lib/apt/lists/* && \
    pip install /tmp/*.tar.gz && \
    apt -y remove gcc libffi-dev && \
    apt -y autoremove && \
    mkdir -p /opt/elastalert && \
    useradd elastalert && \
    chown elastalert:elastalert /opt/elastalert && \
    cd /opt/elastalert && \
    rm -rf /tmp/*

USER elastalert
ENV TZ "UTC"

WORKDIR /opt/elastalert
CMD /usr/local/bin/elastalert-create-index --config /opt/elastalert/config.yaml && /usr/local/bin/elastalert --config /opt/elastalert/config.yaml
