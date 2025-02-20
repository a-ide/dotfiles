# PATH
export PATH=/opt/homebrew/bin:$PATH
export PATH=/opt/homebrew/opt/mysql@8.0/bin:$PATH
export PATH=/opt/homebrew/opt/imagemagick@6/bin:$PATH
export PATH=$(yarn global bin):$PATH
#export PATH=/opt/homebrew/opt/openjdk/bin:$PATH
export PATH=/Library/Java/JavaVirtualMachines/openjdk.jdk/Contents/Home/bin:$PATH
export JAVA_HOME=/Library/Java/JavaVirtualMachines/zulu-16.jdk/Contents/Home
export PKG_CONFIG_PATH="/opt/homebrew/opt/zlib/lib/pkgconfig"
# 一時的に追加
export PATH=/opt/homebrew/opt/postgresql@10:$PATH


# Editor
export EDITOR=vim

eval "$(direnv hook zsh)"
# eval "$(anyenv init -)"

setopt hist_ignore_dups

# Alias

## Brew
alias b='brew'
alias bug='b upgrade'

## Git
alias g='git'
alias gb='g branch'
alias gpl='g pull'
alias gps='g push'
alias gpsf='gps -f'
alias gst='g stash'
alias gstp='gst pop'
alias gsw='g switch'
alias gswc='gsw --create'
alias gw='g wip'

## Yarn
alias yd='yarn dev'
alias ycl='yarn clean'
alias ycm='yarn commit'

## Zsh
alias cz='cat ~/.zshrc'
alias sz='source ~/.zshrc'
alias vz='vim ~/.zshrc'

## Others
alias t='tig'

## Simulator
alias ios-simulator="open $(xcode-select -p)/Applications/Simulator.app"
alias android-simulator="~/Library/Android/sdk/emulator/emulator -avd $(~/Library/Android/sdk/emulator/emulator -list-avds | head)"

# asdf
. /opt/homebrew/opt/asdf/libexec/asdf.sh
