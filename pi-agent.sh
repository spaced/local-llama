#!/usr/bin/env bash

SCRIPT_DIR=$(dirname $([ -L $0 ] && readlink -f $0 || echo $0))
HOST_WORKDIR=$(pwd -P)
PI_AGENT_HOME=${SCRIPT_DIR}/pi/pi-agent-home
mkdir -p "${PI_AGENT_HOME}"

WS_NAME=$(basename "$(pwd)")
CONTAINER_NAME="pi-${WS_NAME}-$(date | sha256sum | cut -c1-8)"

# Parent-death detection in its own session so it survives if the parent group is killed.
PARENT_PID=$PPID
setsid bash -c '
  while kill -0 '"$PARENT_PID"' 2>/dev/null; do
    sleep 1
  done
  podman stop '"${CONTAINER_NAME}"'
' </dev/null >/dev/null 2>&1 &
disown $! 2>/dev/null

# maps the invoking user onto itself in the container, so bind-mount files
# keep host uid/gid/permissions (parity requires your uid to be pi-user's, 1000)
podman run --network llama --rm -it \
  --userns=keep-id \
  --env LLAMA_SERVER_URL="http://llamacpp:8080" \
  --name "${CONTAINER_NAME}" \
  -v ${HOST_WORKDIR}:${HOST_WORKDIR}:Z \
  -v "${PI_AGENT_HOME}":/home/pi-user/.pi:Z \
  -v ~/go/pkg/mod:/home/pi-user/go/pkg/mod:ro,Z \
  --workdir ${HOST_WORKDIR} \
  pi-agent "$@"
