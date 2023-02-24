#!/bin/bash
/usr/local/bin/elastalert-create-index --config /opt/elastalert/config.yaml
/usr/local/bin/elastalert --config /opt/elastalert/config.yaml
