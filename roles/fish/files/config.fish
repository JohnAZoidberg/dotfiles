# Include config that depends on the path structure in my home
source "$HOME/.config/fish/personal.fish"

# Enable vi-style navigation in fish
fish_vi_key_bindings

# Fundle plugin manager
# Install the fish-ssh-agent plugin
fundle plugin 'tuvistavie/fish-ssh-agent'
fundle init

# Enable direnv if it is installed
if type -q direnv
    eval (direnv hook fish)
end

# Faster cd into multiple levels up
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."

# Inform tmux that UTF-8 is supported even if the locale is wrong
alias tmux="tmux -u"

# Stay in the folger navigated to when exiting ranger
alias ranger="ranger --choosedir=$HOME/.rangerdir; cd (cat $HOME/.rangerdir)"
function rangerd
    pushd $argv[1]
    ranger
    popd
end

# hash a path like nixpkgs expects it
alias nixhash="nix-hash --type sha256 --flat --base32"

# edit and source this config file
alias vimfish="vim $HOME/.config/fish/config.fish"
alias srcfish="source $HOME/.config/fish/config.fish"

# easily activate and deactivate redshift
alias redshift="redshift -O 4000K"
alias killallredshift="redshift -O 6500K"

# parallel compression and decompression of archives
function tarxz
    tar -Ipixz -cf "$argv[1].tar.xz" "$argv[1]/"
end
alias untarxz="tar -Ipixz -xf"
function targz
    tar -Ipigz -cf "$argv[1].tar.xz" "$argv[1]/"
end
alias untargz="tar -Ipigz -xf"

# search for a specific package in a nixpkgs repo
function grepkg
    pushd $argv[1]
    git grep "name = \"$argv[2..-1]"
    popd
end

# check a code tree for TODO markers
alias greptodo="grep -irn TODO"

#function cd
#    "builtin cd $argv[1]; and ls -ahl | head; and echo ..."
#end

# remove hidden files that are created by MacOS
function rmmac
    rm -r ../**/{.DS_Store,.AppleDouble,.LSOverride,__MACOSX}
end

# turn project into a nix/direnv project
function nixify
    if not test -e ./.envrc
        echo "use nix" > .envrc
        direnv allow
    end
    if not test -e default.nix
        echo "\
with import <nixpkgs> {};
stdenv.mkDerivation {
  name = "env";
  buildInputs = [
    bashInteractive
  ];
}
" > default.nix
        ${EDITOR:-vim} default.nix
    end
end


# Start emacs daemon and launch in folder above (because of direnv)
alias startemacs="emacs --daemon; emacsclient -cn .."
# Open file in emacs if daemon is running. Open in vim if not
alias vime="emacsclient -n -a=vim"
# Kill running emacs
alias killemacs='emacsclient -e "(kill-emacs)"'

# post json data with curl
# NOTE: unnecessary with the packaage httpie
function curlpost
    curl --verbose -H "Content-Type: application/json" -X POST -d $argv
end

# Use default colorscheme in httpie
# I have no idea why it has to be specifiedd
alias http="http -s default"

# Scan for wifi access points with iw
function scanwifi
    sudo true  # to force password prompt before pipe
    sudo iw dev wlp2s0 scan | less | grep SSID | sort -u
end

# Draw graph of all dependencies of a Haskell package
alias haskellgraph="ghc-pkg dot | tred | dot -Tpdf > pkgs.pdf"

# Convert an office file to pdf using libreoffice and nix
# Only requirement: nix. Nothing else is installed in your $PATH
function convertoffice
    nix-shell -p libreoffice --run "libreoffice --headless --convert-to pdf $argv"
end
