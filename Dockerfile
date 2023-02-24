FROM --platform=$BUILDPLATFORM python:3.11.2-slim as builder
ARG TARGETPLATFORM

LABEL description="ElastAlert 2 Official Image"
LABEL maintainer="Jason Ertel"

COPY . /tmp/elastalert

RUN mkdir -p /opt/elastalert && \
    cd /tmp/elastalert && \
    pip install setuptools wheel && \
    python setup.py sdist bdist_wheel

FROM --platform=$BUILDPLATFORM python:3.11.2-slim
ARG TARGETPLATFORM

ARG GID=1000
ARG UID=1000
ARG USERNAME=elastalert

COPY --from=builder /tmp/elastalert/dist/*.tar.gz /tmp/
COPY --from=builder entrypoint.sh /opt/elastalert/entrypoint.sh

RUN apt update && apt -y upgrade && \
    apt -y install jq curl gcc libffi-dev && \
    rm -rf /var/lib/apt/lists/* && \
    pip install /tmp/*.tar.gz && \
    rm -rf /tmp/* && \
    apt -y remove gcc libffi-dev && \
    apt -y autoremove && \
    mkdir -p /opt/elastalert && \
    chmod +x /opt/elastalert/entrypoint.sh && \
    useradd elastalert && \
    chown elastalert:elastalert /opt/elastalert

USER elastalert
ENV TZ "UTC"

WORKDIR /opt/elastalert
ENTRYPOINT ["/opt/elastalert/entrypoint.sh"]
