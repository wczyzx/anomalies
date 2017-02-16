#!/usr/bin/env bash
set -e

python -m pip install --no-index --find-links=./vendor -r requirements.txt
python ../anomalies_feed.py

