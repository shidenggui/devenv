#!/usr/bin/env bash
set -e

install_basic () {
    sudo apt update && sudo apt upgrade -y
    sudo apt install -y htop tmux zsh git tree build-essential libncurses5-dev libpcap-dev make
}

install_basic

install_oh_my_zsh () {
    if [ -f ~/.zshrc ]; then
        echo zsh installed, skip ......
    else
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

        cat <<EOF >> ~/.bashrc

zsh
EOF

        cat <<EOF >> ~/.zshrc

# zsh: for disable auto update and prompt
export DISABLE_UPDATE_PROMPT=true
export DISABLE_AUTO_UPDATE=true
EOF
    fi
}

install_oh_my_zsh

install_autojump () {
    if grep autojump ~/.zshrc >> /dev/null; then
        echo autojump installed, skip ......
    else 
        sudo apt install -y autojump
        # enable zsh autojump support
        sed -i "/^plugins=(/ a autojump" ~/.zshrc
    fi
}

install_autojump

install_zsh_autosuggestions () {
    if grep zsh-autosuggestions ~/.zshrc >> /dev/null; then
        echo zsh-autosuggestions installed, skip ......
    else 
        git clone https://github.com/zsh-users/zsh-autosuggestions $ZSH_CUSTOM/plugins/zsh-autosuggestions
        sed -i "/^plugins=(/ a zsh-autosuggestions" ~/.zshrc

        cat <<EOF >> ~/.zshrc

# zsh-autosuggestions
export ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20
EOF

    fi
}

install_zsh_autosuggestions

install_ananconda () {
    if [ -e ~/anaconda3 ]; then
        echo anaconda3 installed, skip ......
    else
        file=Anaconda3-5.1.0-Linux-x86_64.sh
        wget https://mirrors.tuna.tsinghua.edu.cn/anaconda/archive/${file}
        bash $file -b -p $HOME/anaconda3
        cat <<EOF >> ~/.zshrc
        export PATH="${HOME}/anaconda3/bin:$PATH"
EOF
        export PATH="${HOME}/anaconda3/bin:$PATH"
        # use tsinghua source
        conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/free/
        conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/main/
        conda config --set show_channel_urls yes
    fi
}

install_ananconda

use_china_pip_mirror () {
    if [ -e ~/.pip/pip.conf ]; then
        echo  already use pip conf, skip ......
    else
        mkdir ~/.pip || true
        cat <<EOF >> ~/.pip/pip.conf
[global]
index-url = http://mirrors.aliyun.com/pypi/simple/
[install]
trusted-host=mirrors.aliyun.com
EOF
    fi 
}

use_china_pip_mirror

install_fd () {
    if fd -h >> /dev/null; then
        echo fd installed, skip ......
    else
        # support local install package for network problem
        fd_file=fd.deb
        if [ -e $fd_file ]; then
            echo find local fd install package
        else
            fd_file=fd-musl_7.0.0_amd64.deb
            wget --limit-rate=8000k https://github.com/sharkdp/fd/releases/download/v7.0.0/${fd_file}
        fi
        sudo dpkg -i $fd_file
        rm $fd_file
    fi
}

install_fd

install_fzf () {
    if fzf --version >> /dev/null; then
        echo fzf installed, skip ......
    else
        git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
        ~/.fzf/install --all
        # let fzf use fd as default
        cat <<EOF >> ~/.zshrc
# fzf
export FZF_DEFAULT_OPTS='--extended'
export FZF_DEFAULT_COMMAND='fd --type f'
export FZF_CTRL_T_COMMAND='fd --type f'
export FZF_CTRL_D_COMMAND='fd --type d'
EOF
    fi
}

install_fzf

install_docker () {
    if docker -h >> /dev/null; then
        echo docker installed, skip ......
    else
        # source: https://help.aliyun.com/document_detail/60742.html
        # step 1: 安装必要的一些系统工具
        sudo apt-get update
        sudo apt-get -y install apt-transport-https ca-certificates curl software-properties-common
        # step 2: 安装GPG证书
        curl -fsSL http://mirrors.aliyun.com/docker-ce/linux/ubuntu/gpg | sudo apt-key add -
        # Step 3: 写入软件源信息
        sudo add-apt-repository "deb [arch=amd64] http://mirrors.aliyun.com/docker-ce/linux/ubuntu $(lsb_release -cs) stable"
        # Step 4: 更新并安装Docker-CE
        sudo apt-get -y update
        sudo apt-get -y install docker-ce

        sudo usermod -aG docker $USER
    fi
}

install_docker

install_docker_compose () {
    if [ -e /usr/local/bin/docker-compose ]; then
        echo docker-compose installed, skip ......
    else
        sudo bash -c "curl -L https://get.daocloud.io/docker/compose/releases/download/1.21.0/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose"
        sudo chmod +x /usr/local/bin/docker-compose
    fi
}

install_docker_compose

use_china_docker_mirror () {
    if [ -e /etc/docker/daemon.json ]; then
        echo already use china docker mirror, skip ......
    else
        cat <<EOF | sudo tee /etc/docker/daemon.json
{
  "registry-mirrors": ["https://registry.docker-cn.com"]
}
EOF
        sudo systemctl restart docker.service
    fi
}

use_china_docker_mirror

install_node () {
    if node -v >> /dev/null; then
        echo node installed, skip ......
    else
        if ! nvm -h >> /dev/null; then
	    curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.9/install.sh | bash || true
	    cat <<EOF >> ~/.zshrc
# for node 
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
EOF
	export NVM_DIR="$HOME/.nvm"
	[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
        fi
        nvm install node
        cat <<EOF >> ~/.zshrc

alias cnpm="npm --registry=https://registry.npm.taobao.org \
		--cache=$HOME/.npm/.cache/cnpm \
		--disturl=https://npm.taobao.org/dist \
		--userconfig=$HOME/.cnpmrc"
EOF
    fi
}

install_node

install_ss () {
	pip install shadowsocks
}

install_ss

install_zsh_syntax_highlighting () {
    if grep zsh-syntax-highlighting ~/.zshrc >> /dev/null; then
        echo zsh-syntax-highlighting installed, skip ......
    else
        git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting || true
        # enable zsh zsh-syntax-highlighting support
        sed -i "/^plugins=(/ a zsh-syntax-highlighting" ~/.zshrc
    fi
}

install_zsh_syntax_highlighting
