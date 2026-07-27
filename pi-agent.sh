#!/usr/bin/env bash

SCRIPT_DIR=$(dirname $([ -L $0 ] && readlink -f $0 || echo $0))
WORKSPACE_DIR="."
PI_AGENT_HOME=${SCRIPT_DIR}/pi/pi-agent-home
SCIMAP_DATA_DIR=${SCRIPT_DIR}/pi/scimap-data
mkdir -p "${PI_AGENT_HOME}"

podman run --network llama --rm -it \
  --env LLAMA_SERVER_URL="http://llamacpp:8080" \
  -v ${WORKSPACE_DIR}:/workspace \
  -v "${PI_AGENT_HOME}":/root/.pi/agent \
  -v "${SCIMAP_DATA_DIR}":/root/.scimap \
  pi-agent "$@"
