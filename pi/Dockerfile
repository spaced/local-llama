FROM node:trixie-slim

RUN apt-get update \
  && apt-get install -y --no-install-recommends bash ca-certificates curl git ripgrep jq xxd default-jdk-headless gradle python3 python3-pip python3-venv poppler-utils build-essential unzip zip sqlite3 chromium fonts-liberation sudo \
  && rm -rf /var/lib/apt/lists/*

# rename unprivileged node to pi-user, allowed to install packages on demand
RUN usermod -d /home/pi-user -l pi-user node && groupmod -n pi-user node\
  && printf 'pi-user ALL=(ALL) NOPASSWD: /usr/bin/apt, /usr/bin/apt-get, /usr/bin/dpkg, /usr/local/bin/npm, /usr/bin/pip3\n' > /etc/sudoers.d/pi-user \
  && chmod 0440 /etc/sudoers.d/pi-user && mv /home/node /home/pi-user

USER pi-user
RUN sudo npm install -g npm@12.0.2

# nvm (installer appends source line to ~/.bashrc)
ENV NVM_DIR=/home/pi-user/.nvm
RUN curl -fsSL https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.7/install.sh | bash

# setup a venv (owned by pi-user), so agent is able to install packages adhoc

RUN python3 -m venv /home/pi-user/venv \
  && /home/pi-user/venv/bin/pip install pypdf pdfplumber reportlab
ENV PATH="/home/pi-user/venv/bin:$PATH"

# native tools for typescript and yaml
RUN sudo npm install -g typescript-language-server typescript
RUN sudo npm install -g yaml-language-server
#RUN npm install -g  --allow-scripts=core-js vscode-langservers-extracted

# go support (GOPATH under pi-user so `go install` works at runtime)
RUN curl -fsSL https://go.dev/dl/go1.26.5.linux-amd64.tar.gz | tar -C /home/pi-user -xz
ENV GOPATH=/home/pi-user/go
ENV PATH=$PATH:/usr/local/go/bin:/home/pi-user/go/bin
RUN go install golang.org/x/tools/gopls@latest

#rtk https://www.rtk-ai.app/de/#install (installs to $HOME/.local/bin)
ENV PATH="/home/pi-user/.local/bin:$PATH"
RUN bash -c 'curl -fsSL https://raw.githubusercontent.com/rtk-ai/rtk/refs/heads/master/install.sh | sh'

RUN sudo npm install -g --ignore-scripts @earendil-works/pi-coding-agent@v0.84.3

WORKDIR /workspace
ENTRYPOINT ["pi"]
