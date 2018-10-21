# Include config that depends on the path structure in my home
source "$HOME/.config/fish/personal.fish"

# Enable vi-style navigation in fish
fish_vi_key_bindings

# Fundle plugin manager
# Install the fish-ssh-agent plugin
fundle plugin 'tuvistavie/fish-ssh-agent'
# To source bash files and get environment variables with fish
fundle plugin 'edc/bass'
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

# Hash a path like nixpkgs expects it - for tarballs you need --unpack
#alias nixhash="nix-hash --type sha256 --flat --base32"
alias nixhash="nixos-prefetch-url"

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
    git grep -iP "name += \"$argv[2..-1]"
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
  name = \"Project\";
  buildInputs = [
    bashInteractive
  ];
}
" > default.nix
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
    sudo iw dev wlp2s0 scan | grep 'SSID:' | sort -u
end

# Draw graph of all dependencies of a Haskell package
alias haskellgraph="ghc-pkg dot | tred | dot -Tpdf > pkgs.pdf"

# Convert an office file to pdf using libreoffice and nix
# Only requirement: nix. Nothing else is installed in your $PATH
function convertoffice
    nix-shell -p libreoffice --run "libreoffice --headless --convert-to pdf $argv"
end

# print nix garbage collection roots
alias nixroots="nix-store --gc --print-roots | less"

# Generate a TOTP like Google Authenticator does
# You need to provide a 32 bytes Base-32 encoded key
# like GEZDGNBVGY3TQOJQGEZDGNBVGY3TQOJQ
function google-auth
    nix-shell -p oathToolkit --command "oathtool -b --totp=sha1 \"$argv[1]\""
end

# Enter a nix-shell with a modified stdenv, namely a different gcc
function nix-shell-gcc
    nix-shell -E "with import <nixpkgs> {}; (overrideCC stdenv $argv[1]).mkDerivation { name = \"shell-environment\"; buildInputs = [ $argv[2..-1] ]; }"
end

# Build project without having to write a default.nix that calls callPackage on the file
function nix-build-default
    nix-build -E "with import <nixpkgs> {}; callPackage ./$argv[1] {}"
end

# Get the nix-shell of a project without  having to write a default.nix
function nix-shell-default
    nix-shell -E "with import <nixpkgs> {}; callPackage ./$argv[1] {}" $argv[2..-1]
end

function haskellEnv
  nix-shell -p "haskellPackages.ghcWithPackages (pkgs: with pkgs; [ $argv ])"
end

# Build a project from local sources with the package description from nixpkgs
# call it like `nix-build-fork openssl` if you're in the OpenSSL source directory
function nix-build-fork
    nix-build -E "with import <nixpkgs> {}; $argv[1].overrideAttrs (oldAttrs: { src = ./.;  })"
end

# Should display a smooth gradient of colors from red over green to blue
# If your terminal doesn't support 16mil colors but only 256 the gradient isn't smooth
# If it's not a gradient at all, your terminal is broken
function check-colors
	awk 'BEGIN{
		  s="aaaaaaaaaaaaaaaaa"; s=s s s s s s s s;
		  for (colnum = 0; colnum<77; colnum++) {
			  r = 255-(colnum*255/76);
			  g = (colnum*510/76);
			  b = (colnum*255/76);
			  if (g>255) g = 510-g;
			  printf "\033[48;2;%d;%d;%dm", r,g,b;
			  printf "\033[38;2;%d;%d;%dm", 255-r,255-g,255-b;
			  printf "%s\033[0m", substr(s,colnum+1,1);
		  }
		  printf "\n";
	  }'
end
