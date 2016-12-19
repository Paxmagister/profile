source ~/.bash_profile
export WORKON_HOME=~/dev/envs
export PATH="$(brew --prefix homebrew/php/php56)/bin:$PATH"
export PATH="$WEBSITE_DOCROOT/vendor/bin:$WEBSITE_DOCROOT/bin:$PATH"
export PATH="/usr/local/Cellar/php56/5.6.22/bin:$PATH"

source $(brew --prefix nvm)/nvm.sh
source /usr/local/bin/virtualenvwrapper.sh

eval $(docker-machine env default)

function title {
    echo -ne "\033]0;"$*"\007"
}

function stopAllDocker {
    docker stop $(docker ps -a -q)
    docker rm $(docker ps -a -q)
}

alias reload="source ~/.zshrc"

#bindkey "OA" up-line-or-local-history
#bindkey "OB" down-line-or-local-history
#
#up-line-or-local-history() {
#    zle set-local-history 1
#    zle up-line-or-history
#    zle set-local-history 0
#}
#zle -N up-line-or-local-history
#down-line-or-local-history() {
#    zle set-local-history 1
#    zle down-line-or-history
#    zle set-local-history 0
#}
#zle -N down-line-or-local-history

# Path to your oh-my-zsh installation.
export ZSH=/Users/ssundell/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="risto"

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git)

# User configuration

export PATH="/Users/ssundell/.nvm/versions/node/v4.4.1/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/opt/X11/bin:$PATH"
# export MANPATH="/usr/local/man:$MANPATH"

source $ZSH/oh-my-zsh.sh

setopt APPEND_HISTORY

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/dsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

DEV_DIR="~/dev"
alias web="cd $DEV_DIR/website"
alias policies="cd $DEV_DIR/policies-app"
alias bot="cd $DEV_DIR/dasbot"
alias web_vagrant="cd ~/website-vagrant-trusty64"

go () {
  # RESOURCES:
  # http://apple.stackexchange.com/questions/110778/open-new-tab-in-iterm-and-execute-command-there
  # http://stackoverflow.com/questions/756756/multiple-commands-in-an-alias-for-bash
  # https://iterm2.com/documentation-scripting.html
  iterm_runcommand "web_vagrant";
  vagrant up;
  iterm_new_tab;
  website;
  iterm_new_tab;
  policies_app;
}

website () {
  WORKON="workon website_venv && nvm use v4.4.1 && web"
  iterm_runcommand "$WORKON && git fetch origin && git pull";
  iterm_split;
  iterm_runcommand "$WORKON && selenium-standalone start";
  iterm_split;
  iterm_runcommand "$WORKON && grunt webpack:watch";
  iterm_vsplit;
  iterm_runcommand "$WORKON && grunt watch:sass:jsx";
}

policies_app () {
  WORKON="workon policies-app && nvm use default && policies"
  iterm_runcommand "$WORKON && git fetch origin && git pull";
  iterm_split;
  iterm_runcommand "$WORKON && npm run start:dashboard";
}

hubot () {
  WORKON="workon dasbot && bot"
  iterm_runcommand "$WORKON && git fetch origin && git pull";
  iterm_split;
  iterm_runcommand "$WORKON"
}

###############################################################################
############################### ITERM FUNCTIONS ###############################
###############################################################################

iterm_activate() {
  osascript -e 'activate application "iTerm"'
}

iterm_new_tab() {
  iterm_activate;
  # COMMAND + T creates new tab
  osascript -e 'tell application "System Events" to keystroke "t" using command down'
}

iterm_next_tab() {
  iterm_activate;
  # COMMAND + SHIFT + ] moves to next tab
  osascript -e 'tell application "System Events" to keystroke "]" using {command down, shift down}'
}

iterm_next_pane() {
  iterm_activate;
  # COMMAND + ] moves to next pane
  osascript -e 'tell application "System Events" to keystroke "]" using command down'
}

iterm_split() {
  iterm_activate;
  # COMMAND + SHIFT + D splits current view horizontally
  osascript -e 'tell application "System Events" to keystroke "d" using {command down, shift down}'
}

iterm_vsplit() {
  iterm_activate;
  # COMMAND + D splits current view vertically
  osascript -e 'tell application "System Events" to keystroke "d" using command down'
}

iterm_runcommand() {
    iterm_activate;
    osascript -e "tell application \"iTerm\" to tell current session of current window to write text \"$1\""
}
