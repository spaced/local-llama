#!/usr/bin/env bash

SCRIPT_DIR=$(dirname "$0")
PI_AGENT_HOME=${SCRIPT_DIR}/pi/pi-agent-home
mkdir -p "${PI_AGENT_HOME}"

podman run --network llama --rm -it \
  --env LLAMA_SERVER_URL="http://llamacpp:8080" \
  -v .:/workspace \
  -v "${PI_AGENT_HOME}":/root/.pi/agent \
  pi-agent
