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
create a symlink, so you can run pi from everywhere
```bash
ln -s ${PWD}/pi-agent.sh ~/.local/bin/pi
```
- optional: install extensions
```bash
 pi install npm:pi-extmgr
 pi install pi-taskgraph
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

you may ask pi to create `models` configuration, so it will create `pi/pi-agent-home/agent/models.json`, so you are able to select thinking levels
```
{
  "providers": {
    "llama.cpp": {
      "baseUrl": "http://llamacpp:8080/v1",
      "api": "openai-completions",
      "apiKey": "123",
      "compat": {
        "supportsStore": false,
        "supportsDeveloperRole": false,
        "supportsReasoningEffort": false,
        "supportsUsageInStreaming": true,
        "supportsStrictMode": false,
        "maxTokensField": "max_tokens"
      },
      "models": [
        { "id": "Qwen3.8-27B-Q5_K_M", "name": "qwen3.8-q5 (default)", "reasoning": true, "thinkingLevelMap": { "xhigh": "high" }, "compat": { "thinkingFormat": "qwen-chat-template" }, "input": ["text", "image"], "contextWindow": 102000, "maxTokens": 102000, "cost": { "input": 0, "output": 0, "cacheRead": 0, "cacheWrite": 0 } },
        { "id": "Qwen3.8-27B-UD-Q4_K_XL", "name": "qwen3.8-q4", "reasoning": true, "thinkingLevelMap": { "xhigh": "high" }, "compat": { "thinkingFormat": "qwen-chat-template" }, "input": ["text", "image"], "contextWindow": 131072, "maxTokens": 131072, "cost": { "input": 0, "output": 0, "cacheRead": 0, "cacheWrite": 0 } },
        { "id": "Qwen3.6-bartowski-27B-MTP-Q4_K_M", "name": "qwen3.6", "reasoning": true, "thinkingLevelMap": { "xhigh": "high" }, "compat": { "thinkingFormat": "qwen-chat-template" }, "input": ["text"], "contextWindow": 131072, "maxTokens": 131072, "cost": { "input": 0, "output": 0, "cacheRead": 0, "cacheWrite": 0 } },
      ]
    }
  }
}

```


