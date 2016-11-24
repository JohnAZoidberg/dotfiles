alias tabesc="xcape -e 'Caps_Lock=Escape'"
alias tabctrl="setxkbmap -option 'caps:ctrl_modifier'"
alias cdhtml="cd /var/www/html"
alias cddev="cd /var/www/html/dev"
alias cdmaster="cd /var/www/html/master"
alias cdprjct="cd ~/Projects"
alias sshdo="ssh zoid@46.101.112.121"
alias middlemouse="synclient TapButton3=2"
alias zoidboot="tabesc|tabctrl|middlemouse"
alias rldapache="sudo /etc/init.d/apache2 reload"
alias errapache="sudo vim /var/log/apache2/error.log"
alias dotunnel="ssh -R 10002:localhost:22 tunneler@46.101.112.121"

alias rmpyc="rm *.pyc"
alias showflask="ps -fA | grep python"
alias lsh='ls -l --ignore "*.pyc" --ignore "*.swp" --ignore "*swo"'

# Enable vi mode for the terminal
set -o vi

# Enable globstar - ** recurses all directories
shopt -s globstar
