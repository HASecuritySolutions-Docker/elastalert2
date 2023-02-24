#!/bin/bash
elastalert-create-index --config /opt/elastalert/config.yaml
elastalert --config /opt/elastalert/config.yaml
