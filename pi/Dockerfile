FROM node:trixie-slim

RUN apt-get update \
  && apt-get install -y --no-install-recommends bash ca-certificates curl git ripgrep jq xxd gradle python3 python3-pip python3-venv poppler-utils build-essential unzip zip sqlite3 chromium fonts-liberation sudo \
  && rm -rf /var/lib/apt/lists/*

# rename unprivileged node to pi-user, allowed to install packages on demand
RUN usermod -d /home/pi-user -l pi-user node && groupmod -n pi-user node\
  && printf 'pi-user ALL=(ALL) NOPASSWD: /usr/bin/apt, /usr/bin/apt-get, /usr/bin/dpkg, /usr/local/bin/npm, /usr/bin/pip3\n' > /etc/sudoers.d/pi-user \
  && chmod 0440 /etc/sudoers.d/pi-user && mv /home/node /home/pi-user

USER pi-user
RUN sudo npm install -g npm@12.0.2

# nvm
RUN curl -fsSL https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.7/install.sh | bash && \
    echo ". $HOME/.nvm/nvm.sh" > /home/pi-user/.shell-init.sh

# setup a venv (owned by pi-user), so agent is able to install packages adhoc
RUN python3 -m venv /home/pi-user/venv \
  && /home/pi-user/venv/bin/pip install pypdf pdfplumber reportlab
ENV PATH="/home/pi-user/venv/bin:$PATH"

# native tools for python, yaml, typescript (typescript-language-server: released TS LSP, push diagnostics)
RUN sudo npm install -g pyright yaml-language-server typescript-language-server typescript@5 # typescript@5: released tsserver; @latest is TS7 native (no tsserver.js)

# go support (GOPATH under pi-user so `go install` works at runtime)
RUN curl -fsSL https://go.dev/dl/go1.26.5.linux-amd64.tar.gz | tar -C /home/pi-user -xz
ENV GOPATH=/home/pi-user/go
ENV PATH=$PATH:/usr/local/go/bin:/home/pi-user/go/bin
RUN go install golang.org/x/tools/gopls@latest

# java/scala
RUN curl -s "https://get.sdkman.io" | bash && \
    echo ". $HOME/.sdkman/bin/sdkman-init.sh" >> /home/pi-user/.shell-init.sh

RUN bash -c '. "$HOME/.sdkman/bin/sdkman-init.sh" && \
    sdk install java "$(sdk list java --no-colors | grep -oE "17\.[0-9]+\.[0-9]+-zulu" | head -1)" && \
    sdk install sbt'

# scala: metals LSP (coursier launcher; uses the sdkman java above)
RUN curl -fL "https://github.com/coursier/launchers/raw/master/cs-x86_64-pc-linux.gz" | gzip -d > /tmp/cs && chmod +x /tmp/cs && \
    bash -c '. "$HOME/.sdkman/bin/sdkman-init.sh" && /tmp/cs install metals' && rm /tmp/cs
ENV PATH="/home/pi-user/.local/share/coursier/bin:$PATH"

# nvm + sdkman are shell functions, not binaries: .bashrc only loads them for interactive shells,
# but pi runs /bin/bash -c (non-interactive). BASH_ENV takes a single file, so use a small loader.
ENV BASH_ENV=/home/pi-user/.shell-init.sh

#rtk https://www.rtk-ai.app/de/#install (installs to $HOME/.local/bin)
ENV PATH="/home/pi-user/.local/bin:$PATH"
RUN bash -c 'curl -fsSL https://raw.githubusercontent.com/rtk-ai/rtk/refs/heads/master/install.sh | sh'

RUN sudo npm install -g --ignore-scripts @earendil-works/pi-coding-agent@v0.84.4

WORKDIR /workspace
ENTRYPOINT ["pi"]
