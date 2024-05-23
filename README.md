# My CUI based Development Environment on Docker

Docker 上で動作する、自分用にカスタマイズした CUI ベースの開発環境一式です。普段は TypeScript を使うことが多く、
その開発が出来れば十分なので、最低限の構成なっています。必要であれば [mise](https://github.com/jdx/mise)
をインストールしてあるので、都度インストールして使用することにしています。

## 起動方法

```sh
docker pull mackie376/studio:latest
docker run -it --rm -e TZ=Asia/Tokyo studio:latest
```

## apt を使ってインストールするパッケージ

- btop
- curl
- file
- gcc
- git
- git-lfs
- gnupg
- jq
- locales
- make
- openssl
- rsync
- tree
- unzip
- wget
- zsh

## 手動でインストールしているツール

- bat@0.24.0
- delta@0.17.0
- eza@0.18.16
- fd@10.1.0
- fzf@0.52.1
- gh@2.49.1
- lazygit@0.42.0
- neovim@0.10.0
- ripgrep@14.1.0
- starship@1.19.0
- mise@latest
