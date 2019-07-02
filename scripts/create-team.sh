#!/usr/bin/env bash

set -o errexit

: ${1?"Usage: $0 team-name"}

REPO_ROOT=$(git rev-parse --show-toplevel)
TEAM=$1
TEAM1="team1"
TEAM_DIR="${REPO_ROOT}/cluster/${TEAM}/"

mkdir -p ${TEAM_DIR}

cp -r "${REPO_ROOT}/cluster/${TEAM1}/." ${TEAM_DIR}


for f in "${TEAM_DIR}*.yaml"
do
 sed -i '' "s/$TEAM1/$TEAM/g" ${f}
done

echo "${TEAM} created at ${TEAM_DIR}"
echo "  - ./${TEAM}/" >> "${REPO_ROOT}/cluster/kustomization.yaml"
echo "${TEAM} added to ${REPO_ROOT}/cluster/kustomization.yaml"
