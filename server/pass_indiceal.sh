#!/bin/bash

docker logs rke_server 2>&1 | grep "Bootstrap Password:"
