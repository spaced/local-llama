# local llama agent setup
containerized usage of llama.cpp and pi agent

## Requirements
- podman
- (nvidia-ctk if using nvidia cuda)

## Tuning
repo is optimized for running nvidia GPU 24GB vram
see models/llama-server-presets.ini 

## Setup
### create new podman network
```bash
podman network create llama
```
### llama.cpp
- download your model from https://huggingface.co/ into `models`, or uncomment the `hf` keys in models/llama-server-presets.ini 
- start llama-router.sh
```bash
./llama-router.sh
```
- check if running open browser http://127.0.0.1:28080

### pi agent
- build your personal image
```bash
 podman build pi -t pi-agent
```
- install extensions
```bash
 podman run --rm -v ./pi/pi-agent-home:/root/.pi/agent pi-agent install npm:pi-extmgr
 podman run --rm -v ./pi/pi-agent-home:/root/.pi/agent pi-agent install https://github.com/gsanhueza/pi-llama-cpp
```

### start agent
```
./pi-agent.sh
```