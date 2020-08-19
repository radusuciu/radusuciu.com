#!/usr/bin/env bash

bin/hugo/hugo -s src --bind 0.0.0.0 -d ../build "$@"
