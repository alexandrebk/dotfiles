ZSH=$HOME/.oh-my-zsh

echo 'Load ZSH THEME'
# You can change the theme with another one from https://github.com/robbyrussell/oh-my-zsh/wiki/themes
ZSH_THEME="robbyrussell"

echo 'oh-my-zsh plugins'
# Useful oh-my-zsh plugins
plugins=(git gitfast last-working-dir common-aliases sublime zsh-syntax-highlighting history-substring-search)

echo 'Prevent Homebrew from reporting'
# (macOS-only) Prevent Homebrew from reporting - https://github.com/Homebrew/brew/blob/master/docs/Analytics.md
export HOMEBREW_NO_ANALYTICS=1

# Disable warning about insecure completion-dependent directories
ZSH_DISABLE_COMPFIX=true

echo 'Load Oh-My-Zsh'
# Actually load Oh-My-Zsh
source "${ZSH}/oh-my-zsh.sh"
unalias rm # No interactive rm by default (brought by plugins/common-aliases)

echo 'Load rbenv'
# Load rbenv if installed
export PATH="${HOME}/.rbenv/bin:${PATH}"
type -a rbenv > /dev/null && eval "$(rbenv init -)"

# PYTHON
# Load pyenv (to manage your Python versions)
# export PYENV_VIRTUALENV_DISABLE_PROMPT=1
# type -a pyenv > /dev/null && eval "$(pyenv init -)" && eval "$(pyenv virtualenv-init -)" && RPROMPT+='[🐍 $(pyenv_prompt_info)]'
# Set ipdb as the default Python debugger
# export PYTHONBREAKPOINT=ipdb.set_trace

echo 'Load nvm'
# Load nvm (to manage your node versions)
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

echo 'Call `nvm use` automatically in a directory with a `.nvmrc` file'
# Call `nvm use` automatically in a directory with a `.nvmrc` file
autoload -U add-zsh-hook
load-nvmrc() {
  if nvm -v &> /dev/null; then
    local node_version="$(nvm version)"
    local nvmrc_path="$(nvm_find_nvmrc)"

    if [ -n "$nvmrc_path" ]; then
      local nvmrc_node_version=$(nvm version "$(cat "${nvmrc_path}")")

      if [ "$nvmrc_node_version" = "N/A" ]; then
        nvm install
      elif [ "$nvmrc_node_version" != "$node_version" ]; then
        nvm use --silent
      fi
    elif [ "$node_version" != "$(nvm version default)" ]; then
      nvm use default --silent
    fi
  fi
}
type -a nvm > /dev/null && add-zsh-hook chpwd load-nvmrc
type -a nvm > /dev/null && load-nvmrc

echo 'export Path bin for Rails'
# Rails and Ruby uses the local `bin` folder to store binstubs.
# So instead of running `bin/rails` like the doc says, just run `rails`
# Same for `./node_modules/.bin` and nodejs
export PATH="./bin:./node_modules/.bin:${PATH}:/usr/local/sbin"

echo 'Install the macvim shell'
### Install the macvim shell
export PATH="${PATH}:/Applications/MacVim.app/Contents/bin"

echo 'store your own aliases'
# Store your own aliases in the ~/.aliases file and load the here.
[[ -f "$HOME/.aliases" ]] && source "$HOME/.aliases"

echo 'encoding stuff'
# Encoding stuff for the terminal
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# For tmuxinator
export EDITOR=vim

echo 'Disable spring for caching'
# Disable Spring for caching
export DISABLE_SPRING=true

echo 'ngrok export variable'
ngrok_export_variable(){
  url=`curl -s  http://localhost:4040/api/tunnels | ruby -e "require 'json' ; puts JSON.parse(ARGF.read)['tunnels'][1]['public_url'] rescue nil"`
  if [ $url ]
  then
    export NGROK_URL=$url
    echo "NGROK_URL=$NGROK_URL"
  else
    unset NGROK_URL
    echo "Pas de ngrok qui tourne"
  fi
}

echo 'tabtab'
# tabtab source for packages
# uninstall by removing these lines
[[ -f ~/.config/tabtab/__tabtab.zsh ]] && . ~/.config/tabtab/__tabtab.zsh || true
export BUNDLER_EDITOR="'/Applications/Sublime Text.app/Contents/SharedSupport/bin/subl' -a"
# export BUNDLER_EDITOR=code
# export EDITOR=code

export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"

# echo 'Scalingo auto completion'
# Scalingo auto completion
# source ~/.zsh/completion/scalingo_complete.zsh

# All files for
export PATH="$HOME/code/alexandrebk/dotfiles/bin:$PATH"

echo 'Setup loaded from zshrc'
