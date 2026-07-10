# local llama cpp with pi agent setup
containerized usage of llama.cpp and pi agent

## Requirements
- podman
- (nvidia-ctk if using nvidia cuda)

## Tuning
This repo is optimized for running NVIDIA GPU with 24GB VRam.
See also `models/llama-server-presets.ini` 

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
- check with browser http://127.0.0.1:28080

### pi agent
- build your local `pi-agent` image
```bash
 podman build pi -t pi-agent
```
- install extensions
```bash
 podman run --rm -v ./pi/pi-agent-home:/root/.pi/agent pi-agent install npm:pi-extmgr
 podman run --rm -v ./pi/pi-agent-home:/root/.pi/agent pi-agent install https://github.com/gsanhueza/pi-llama-cpp
```
create a symlink, so you can run pi from everywhere
```bash
ln -s ${PWD}/pi-agent.sh ~/.local/bin/pi
```

## Start llama server and pi agent

In one terminal, start the llama server:
```bash
./llama-router.sh
```

In another terminal, start the pi agent pointing to your workspace:
```bash
cd /path/to/your/workspace
pi
```
