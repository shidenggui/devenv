set -e

current_path="`dirname \"$0\"`"
abs_path="`( cd \"$current_path\" && pwd )`"

link_vim_rc () {
    if [ -e ~/.vimrc ]; then
        echo .vimrc exist, skip ......
    else
        ln -s ${abs_path}/../.vimrc ~
    fi
}

link_vim_rc

cp_vim_folder () {
    if [ -e ~/.vim ]; then
        echo .vim exist, skip ......
    else
        rsync -avzP ${current_path}/../.vim ~
    fi
}

cp_vim_folder

install_vim_plugin_dependencies () {
    pip install jedi
}

install_vim_plugin_dependencies
