set fish_greeting ""

# set -gx TERM xterm-256color
set -U fish_user_paths /opt/homebrew/bin

# theme
set -g theme_color_scheme terminal-dark
set -g fish_prompt_pwd_dir_length 1
set -g theme_display_user yes
set -g theme_hide_hostname no
set -g theme_hostname always

# aliases
alias ls "ls -p -G"
alias la "ls -A"
alias ll "ls -l"
alias lla "ll -A"
alias llt "ll -T --no-filesize --no-permissions --no-user --no-time"
alias g git
alias gssh "gcloud compute ssh"
alias glog "git log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold cyan)%aD%C(reset) %C(bold green)(%ar)%C(reset)%C(bold yellow)%d%C(reset)%n''          %C(white)%s%C(reset) %C(dim white)- %an%C(reset)'"
command -qv nvim && alias vim nvim
alias python python3

set -gx EDITOR nvim

set -gx PATH bin $PATH
set -gx PATH ~/bin $PATH
set -gx PATH ~/.local/bin $PATH
set -gx PATH ~/google-cloud-sdk/bin $PATH
# Setting PATH for Python 3.10
# set -x PATH "/Library/Frameworks/Python.framework/Versions/3.10/bin" "$PATH"
set -gx PATH /Applications/Visual\ Studio\ Code.app/Contents/Resources/app/bin $PATH
set -gx ANDROID_SDK_ROOT $HOME/Library/Android/sdk
set -gx PATH $ANDROID_SDK_ROOT/emulator $PATH
set -gx PATH $ANDROID_SDK_ROOT/platform-tools $PATH
set -gx LANG "en_US.UTF-8"
set -gx LC_ALL "en_US.UTF-8"
set -x TMUX_TMPDIR "/Users/peter/.tmux/tmp"
set -gx CLOUDSDK_PYTHON /usr/bin/python3
# set for python mysqlclient package
set -gx fish_user_paths /opt/homebrew/opt/mysql-client@8.0/bin /opt/homebrew/opt/mysql@8.0/bin /opt/homebrew/bin
set -gx MYSQLCLIENT_CFLAGS "$(mysql_config --cflags)"
set -gx MYSQLCLIENT_LDFLAGS "$(mysql_config --libs)"

# tide items setup 
set --universal tide_left_prompt_items pwd newline character
set --universal tide_right_prompt_items git time

# NodeJS
# set -gx PATH node_modules/.bin $PATH

# Go
# set -g GOPATH $HOME/go
# set -gx PATH $GOPATH/bin $PATH

# NVM
#function nvm
#   bass source $NVM_DIR/nvm.sh --no-use ';' nvm $argv
#end
set -x NVM_DIR ~/.nvm
#nvm use default --silent
#function __check_rvm --on-variable PWD --description 'Do nvm stuff'
#  status --is-command-substitution; and return
#
#  if test -f .nvmrc; and test -r .nvmrc;
#    nvm use
#  else
#  end
#end

switch (uname)
    case Darwin
        source (dirname (status --current-filename))/config-osx.fish
    case Linux
        source (dirname (status --current-filename))/config-linux.fish
    case '*'
        source (dirname (status --current-filename))/config-windows.fish
end

set LOCAL_CONFIG (dirname (status --current-filename))/config-local.fish
if test -f $LOCAL_CONFIG
    source $LOCAL_CONFIG
end

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/peter/Documents/google-cloud-sdk/path.fish.inc' ]
    . '/Users/peter/Documents/google-cloud-sdk/path.fish.inc'
end
