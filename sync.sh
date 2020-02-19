#!/usr/bin/env bash

set -o errexit

git add -A && \
git commit -m "bump" && \
git push origin master && \
fluxctl sync --k8s-fwd-ns flux
