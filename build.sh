#!/bin/bash

# export https_proxy=http://127.0.0.1:10809

# RUSTPROXY
export RUSTUP_DIST_SERVER=https://git.sjtu.edu.cn/sjtug/crates.io-index
export RUSTUP_UPDATE_ROOT=https://git.sjtu.edu.cn/sjtug/crates.io-index/rustup

# echo $1
if [ "$1" == "env" ]; then
    # 安装 rust
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh && source "$HOME/.cargo/env"
    # 设置默认版本
    rustup default nightly-2023-03-17 && rustup update nightly-2023-03-17
    # 安装target
    rustup target add wasm32-unknown-unknown
    rustup target add wasm32-wasi
    # 安装包 wasm-pack wasm-bindgen
    curl https://rustwasm.github.io/wasm-pack/installer/init.sh -sSf | sh
    cargo install wasm-pack
    cargo install wasm-bindgen-cli
    cargo install wasm-custom-section

    # 通过python安装环境依赖（很重要）
    pip install -r requirements.txt
    
elif [ "$1" == "clear" ]; then
    # echo -e "\033[34m rm -fr ./target ./libsignal-wasm/pkg \033[0m"
    # rm -fr ./target ./libsignal-wasm/pkg 
    echo -e "\033[34m cargo clean \033[0m"
    cargo clean
elif [ "$1" == "web" ]; then # web版本
    echo -e "\033[34m wasm-pack build --target web \033[0m"
    wasm-pack build --target web
elif [ "$1" == "wasm" ]; then # 指定wasm32编译
    echo -e "\033[34m cargo build --target wasm32-unknown-unknown --release \033[0m"
    cargo build --target wasm32-unknown-unknown --release
else # 编译机器环境编译
    echo -e "\033[34m cargo build --release \033[0m"
    cargo build --release
fi
