#!/usr/bin/env bash

HTTP_PORT="28080"
SCRIPT_DIR=$(dirname "$0")
IMAGE_VERSION=server-cuda13
LLAMA_IMAGE=ghcr.io/ggml-org/llama.cpp:${IMAGE_VERSION}
HUGGING_FACE_CACHE_DIR=${SCRIPT_DIR}/models/huggingface
MODELS_DIR=${SCRIPT_DIR}/models
mkdir -p "${HUGGING_FACE_CACHE_DIR}"

podman run --network llama --rm --name llamacpp \
  -p ${HTTP_PORT}:8080 \
  -v "${MODELS_DIR}":/models \
  -v "${HUGGING_FACE_CACHE_DIR}":/root/.cache/huggingface \
  --device nvidia.com/gpu=0 \
  ${LLAMA_IMAGE} \
  --port 8080 --host 0.0.0.0 \
  --models-dir /models \
  --models-preset /models/llama-server-presets.ini \
  --models-max 1

