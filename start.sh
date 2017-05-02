#!/bin/bash

home/couchdb/couchdb/bin/couchdb &
sleep 1
cd app && npm start && npm run keep-running