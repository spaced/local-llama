#!/usr/bin/env bash

if [ $# -eq 0 ]
  then
    echo "No arguments supplied"
    echo "Usage: $0 <workspace_dir>"
    exit 2
fi

SCRIPT_DIR=$(dirname "$0")
WORKSPACE_DIR=${1}
PI_AGENT_HOME=${SCRIPT_DIR}/pi/pi-agent-home
mkdir -p "${PI_AGENT_HOME}"

podman run --network llama --rm -it \
  --env LLAMA_SERVER_URL="http://llamacpp:8080" \
  -v ${WORKSPACE_DIR}:/workspace \
  -v "${PI_AGENT_HOME}":/root/.pi/agent \
  pi-agent
