#!/usr/bin/env bash
set -e

cd ..
python -m pip install --no-index --find-links=./deploy/vendor -r ./deploy/requirements.txt
python anomalies.py

