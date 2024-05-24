FROM node:20-bookworm-slim
LABEL maintainer="Takashi Makimoto <mackie@beehive-dev.com>"

SHELL [ "/bin/bash", "-o", "pipefail", "-c" ]
WORKDIR /root

ARG BAT_VER=0.24.0
ARG DELTA_VER=0.17.0
ARG EZA_VER=0.18.16
ARG FD_VER=10.1.0
ARG FZF_VER=0.52.1
ARG GITHUB_CLI_VER=2.49.2
ARG LAZYGIT_VER=0.42.0
ARG NEOVIM_VER=0.10.0
ARG RIPGREP_VER=14.1.0
ARG STARSHIP_VER=1.19.0

ENV \
  TERM=xterm-256color \
  SHELL=/usr/bin/zsh \
  PATH="/root/.local/bin:/opt/nvim-linux64/bin:$PATH" \
  LANGUAGE="en_US.UTF-8" \
  LC_ALL="en_US.UTF-8"

COPY "${PWD}/data/conf.d/bat/" /root/.config/bat/
COPY "${PWD}/data/conf.d/btop/" /root/.config/btop/
COPY "${PWD}/data/conf.d/lazygit/" /root/.config/lazygit/
COPY "${PWD}/data/conf.d/nvim/" /root/.config/nvim/
COPY "${PWD}/data/conf.d/zsh/" /root/.config/zsh/
COPY "${PWD}/data/.zshenv" /root/.zshenv
# COPY "${PWD}/bin/*" /root/.local/bin/

RUN \
  mkdir -p .cache/zsh .local/share/zsh .local/state Projects && \
  apt-get update -y && \
  DEBIAN_FRONTEND=nointeractive apt-get install -y --no-install-recommends \
  btop=1.2.13-1 \
  ca-certificates=20230311 \
  curl=7.88.1-10+deb12u5 \
  file=1:5.44-3 \
  gcc=4:12.2.0-3 \
  git=1:2.39.2-1.1 \
  git-lfs=3.3.0-1+b5 \
  gnupg=2.2.40-1.1 \
  hexyl=0.8.0-2+b5 \
  jq=1.6-2.1 \
  locales=2.36-9+deb12u7 \
  luarocks=3.8.0+dfsg1-1 \
  libicu-dev=72.1-3 \
  make=4.3-4.1 \
  openssh-client=1:9.2p1-2+deb12u2 \
  openssl=3.0.11-1~deb12u2 \
  rsync=3.2.7-1 \
  tree=2.1.0-1 \
  unzip=6.0-28 \
  wget=1.21.3-1+b2 \
  zsh=5.9-4+b2 && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/* && \
  echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && \
  locale-gen en_US.UTF-8 && \
  DEBIAN_FRONTEND=nointeractive dpkg-reconfigure locales && \
  /usr/sbin/update-locale LANG=en_US.UTF-8 && \
  curl -L \
  -O "https://github.com/sharkdp/bat/releases/download/v${BAT_VER}/bat-musl_${BAT_VER}_amd64.deb" \
  -O "https://github.com/dandavison/delta/releases/download/${DELTA_VER}/git-delta-musl_${DELTA_VER}_amd64.deb" \
  -O "https://github.com/eza-community/eza/releases/download/v${EZA_VER}/eza_x86_64-unknown-linux-musl.tar.gz" \
  -O "https://github.com/sharkdp/fd/releases/download/v${FD_VER}/fd-musl_${FD_VER}_amd64.deb" \
  -O "https://github.com/junegunn/fzf/releases/download/${FZF_VER}/fzf-${FZF_VER}-linux_amd64.tar.gz" \
  -O "https://github.com/cli/cli/releases/download/v${GITHUB_CLI_VER}/gh_${GITHUB_CLI_VER}_linux_amd64.deb" \
  -O "https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VER}/lazygit_${LAZYGIT_VER}_Linux_x86_64.tar.gz" \
  -O "https://github.com/neovim/neovim/releases/download/v${NEOVIM_VER}/nvim-linux64.tar.gz" \
  -O "https://github.com/BurntSushi/ripgrep/releases/download/${RIPGREP_VER}/ripgrep-${RIPGREP_VER}-x86_64-unknown-linux-musl.tar.gz" \
  -O "https://github.com/starship/starship/releases/download/v${STARSHIP_VER}/starship-x86_64-unknown-linux-musl.tar.gz" \
  -o /usr/local/bin/fzf-tmux https://raw.githubusercontent.com/junegunn/fzf/master/bin/fzf-tmux && \
  dpkg -i \
  bat-musl_${BAT_VER}_amd64.deb \
  git-delta-musl_${DELTA_VER}_amd64.deb \
  fd-musl_${FD_VER}_amd64.deb \
  gh_${GITHUB_CLI_VER}_linux_amd64.deb && \
  tar xzvf eza_x86_64-unknown-linux-musl.tar.gz -C /usr/local/bin && \
  tar xzvf fzf-${FZF_VER}-linux_amd64.tar.gz -C /usr/local/bin && \
  tar xzvf lazygit_${LAZYGIT_VER}_Linux_x86_64.tar.gz -O lazygit > /usr/local/bin/lazygit && \
  tar xzvf nvim-linux64.tar.gz -C /opt && \
  tar xzvf ripgrep-${RIPGREP_VER}-x86_64-unknown-linux-musl.tar.gz -O ripgrep-${RIPGREP_VER}-x86_64-unknown-linux-musl/rg > /usr/local/bin/rg && \
  tar xzvf starship-x86_64-unknown-linux-musl.tar.gz -C /usr/local/bin && \
  rm -f ./*.deb ./*.tar.gz ./*.zip && \
  chown root:root /usr/local/bin/* && \
  chmod +x /usr/local/bin/*
RUN \
  curl https://mise.run | sh && \
  curl -fsSL --create-dirs -o /root/.local/share/zsh/zim/zimfw.zsh https://github.com/zimfw/zimfw/releases/latest/download/zimfw.zsh && \
  bat cache --build && \
  nvim --headless "+Lazy! sync" +qa

WORKDIR /root/Projects
CMD [ "/usr/bin/zsh", "--login" ]
