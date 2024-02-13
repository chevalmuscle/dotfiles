# Neovim config

## Setup

```shell
# 1. Install menlo nerd font (for icons) and set it as the font for the terminal
https://github.com/yumitsu/font-menlo-extra

# 2. Install vim-plug
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

# 3. remap vim to nvim in ~/.bash_profile
alias vim=nvim

# 4. Open vim
vim

# 5. Install plugins
:PlugInstall
```
