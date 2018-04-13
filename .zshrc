# The following lines were added by compinstall
zstyle :compinstall filename '/Users/jrod/.zshrc'

autoload -Uz compinit
compinit -u
# End of lines added by compinstall
# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
setopt appendhistory
unsetopt beep
# End of lines configured by zsh-newuser-install


# If you come from bash you might have to change your $PATH.
PATH=$HOME/bin:/usr/local/bin:$PATH:/Users/jrod/Library/Android/sdk/platform-tools

# Path to your oh-my-zsh installation.
export ZSH=/Users/jrod/.oh-my-zsh

# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-zsh is loaded.
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="robbyrussell"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  git npm rails ruby
)

source $ZSH/oh-my-zsh.sh

# User configuration

ZSH_THEME="mh"
source ~/.oh-my-zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh  

#MY ALIASES

#KNEX
alias knexml='knex migrate:latest'
alias knexmr='knex migrate:rollback'
alias knexsr='knex seed:run'

#NPM

alias dev='npm run dev'
alias deploy='npm run deploy'
# AWS SSH
alias gp_www1='ssh -i ~/.ssh/GYMPOINTS_AWS.pem ec2-user@13.58.74.48'
alias gp_www2='ssh -i ~/.ssh/GYMPOINTS_AWS.pem ec2-user@18.219.235.217'
alias gp_staging1='ssh -i ~/.ssh/GYMPOINTS_AWS.pem ec2-user@13.59.155.123'
# Shipit
alias gp_sd='shipit staging deploy'
alias gp_pd='shipit production deploy'


#SIMPLENEXUS ALIASES
alias snpd='echo DEPLOYING MASTER TO PRODUCTION; say deploying to production; export BRANCH=master; cap production deploy; say deploy to production complete'
alias snsd='echo DEPLOYING STAGING TO STAGING; export BRANCH=staging; cap staging deploy; say deploy to staging complete'
alias staging1_ssh='ssh -l ec2-user staging1.simplenexus.com'
alias staging2_ssh='ssh -l ec2-user staging2.simplenexus.com'
alias www1_ssh='ssh -l ec2-user www1.simplenexus.com'
alias www2_ssh='ssh -l ec2-user www2.simplenexus.com'

AWS_ACCESS_KEY_ID=AKIAJXDAUSKP3N6OG7CA
AWS_SECRET_ACCESS_KEY=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
AWS_REGION=us-east-1
export PATH="/usr/local/opt/node@8/bin:$PATH"

alias ggg='git add . && git commit -m "default commit" && git push'

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
