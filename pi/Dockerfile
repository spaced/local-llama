FROM node:trixie-slim

RUN apt-get update \
  && apt-get install -y --no-install-recommends bash ca-certificates curl git ripgrep jq xxd default-jdk-headless gradle python3 python3-pip python3-venv poppler-utils \
  && rm -rf /var/lib/apt/lists/*

RUN npm install -g npm@12.0.0

# setup a venv, so agent is able to install packages adhoc
RUN python3 -m venv /root/venv
ENV PATH="/root/venv/bin:$PATH"
RUN python3 -m pip install pypdf pdfplumber reportlab

# native tools for typescript and yaml
RUN npm install -g typescript-language-server typescript
RUN npm install -g yaml-language-server
#RUN npm install -g  --allow-scripts=core-js vscode-langservers-extracted

# go support
RUN curl -fsSL https://go.dev/dl/go1.26.5.linux-amd64.tar.gz | tar -C /usr/local -xz
ENV PATH=$PATH:/usr/local/go/bin
RUN go install golang.org/x/tools/gopls@latest

#rtk https://www.rtk-ai.app/de/#install
ENV PATH="/root/.local/bin:$PATH"
RUN curl -fsSL https://raw.githubusercontent.com/rtk-ai/rtk/refs/heads/master/install.sh | sh

RUN npm install -g --ignore-scripts @earendil-works/pi-coding-agent@v0.84.1

WORKDIR /workspace
ENTRYPOINT ["pi"]
