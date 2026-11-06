#!/usr/bin/env bash

SCRIPT_DIR=$(dirname $([ -L $0 ] && readlink -f $0 || echo $0))
HOST_WORKDIR=$(pwd -P)
PI_AGENT_HOME=${SCRIPT_DIR}/pi/pi-agent-home
mkdir -p "${PI_AGENT_HOME}"

WS_NAME=$(basename "$(pwd)")
CONTAINER_NAME="pi-${WS_NAME}-$(date | sha256sum | cut -c1-8)"

# In tmux, name the window like the automatic-rename format does ("path⏑pi")
# and stop automatic-rename from overwriting it with the wrapper's process
# name (bash/podman) while pi runs.
if [ -n "$TMUX" ]; then
  tmux rename-window -t "${TMUX_PANE}" "${WS_NAME}⏑pi"
  tmux set-option -t "${TMUX_PANE}" automatic-rename off
  restore_window_name() {
    tmux set-option -t "${TMUX_PANE}" automatic-rename on 2>/dev/null
    tmux rename-window -t "${TMUX_PANE}" "${WS_NAME}" 2>/dev/null
  }
  trap restore_window_name EXIT
fi

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
  --log-driver none \
  --userns=keep-id \
  --env LLAMA_SERVER_URL="http://llamacpp:8080" \
  --name "${CONTAINER_NAME}" \
  -v ${HOST_WORKDIR}:${HOST_WORKDIR}:Z \
  -v "${PI_AGENT_HOME}":/home/pi-user/.pi:Z \
  -v ~/go/pkg/mod:/home/pi-user/go/pkg/mod:ro:Z \
  -v ~/.cache/coursier:/home/pi-user/.cache/coursier:ro:Z \
  --workdir ${HOST_WORKDIR} \
  pi-agent "$@"
