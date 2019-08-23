# Include config that depends on the path structure in my home
source "$HOME/.config/fish/personal.fish"

# Enable vi-style navigation in fish
function fish_user_key_bindings
  fish_vi_key_bindings
end

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
alias ..    "cd .."
alias ...   "cd ../.."
alias ....  "cd ../../.."
alias ..... "cd ../../../.."

# Inform tmux that UTF-8 is supported even if the locale is wrong
alias tmux="tmux -u"

# Stay in the folder navigated to when exiting ranger
#alias ranger="ranger --choosedir=$HOME/.rangerdir; cd (cat $HOME/.rangerdir)"
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

# Easily activate and deactivate redshift
alias redshift="redshift -O 4000K"
alias killallredshift="redshift -O 6500K"

# Parallel compression and decompression of xz archives
function tarxz
    tar -Ipixz -cf "$argv[1].tar.xz" "$argv[1]/"
end
alias untarxz="tar -Ipixz -xf"
function targz
    tar -Ipigz -cf "$argv[1].tar.xz" "$argv[1]/"
end
alias untargz="tar -Ipigz -xf"

# Search for a specific package in a nixpkgs repo
function grepkg
    pushd $argv[1]
    git grep -iP "name += \"$argv[2..-1]"
    popd
end

# Remove hidden files that are created by MacOS
function rmmac
    rm -r ../**/{.DS_Store,.AppleDouble,.LSOverride,__MACOSX}
end

# Turn project into a nix/direnv project
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

# Start emacs daemon and launch in parent directory (because of direnv)
alias startemacs="emacs --daemon; emacsclient -cn .."
# Open file in emacs if daemon is running. Open in vim if not
alias vime="emacsclient -n -a=vim"
# Kill running emacs
alias killemacs='emacsclient -e "(kill-emacs)"'

# Post json data with curl
# NOTE: unnecessary with the package httpie
function curlpost
    curl --verbose -H "Content-Type: application/json" -X POST -d $argv
end

# Use default colorscheme in httpie
# I have no idea why it has to be specifiedd
alias http="http -s default"

# Print name of the wireless interface
function wifiinterface
  echo /sys/class/net/*/wireless | awk -F'/' '{ print $5 }'
end

# Scan for wifi access points with iw
function scanwifi
    sudo true  # to force password prompt before pipe
    sudo iw dev (wifiinterface) scan | grep 'SSID:' | sort -u
end

# Show connection status of wifi
function wifistatus
    sudo true  # to force password prompt before pipe
    sudo iw dev (wifiinterface) link
end

# Draw graph of all dependencies of a Haskell package
alias haskellgraph="ghc-pkg dot | tred | dot -Tpdf > pkgs.pdf"

# Convert an office file to pdf using libreoffice and nix
# Only requirement: nix. Nothing else is installed in your $PATH
function convertoffice
    nix-shell -p libreoffice --run "libreoffice --headless --convert-to pdf $argv"
end

# Print nix garbage collection roots
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
function nix-build-default-python
    nix-build -E "with import <nixpkgs> {}; pythonPackages.callPackage ./$argv[1] {}"
end
function nix-build-default-python3
    nix-build -E "with import <nixpkgs> {}; python3Packages.callPackage ./$argv[1] {}"
end

# Get the nix-shell of a project without  having to write a default.nix
function nix-shell-default
    nix-shell -E "with import <nixpkgs> {}; callPackage ./$argv[1] {}" $argv[2..-1]
end

function ns-haskell
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

alias treesult="tree result"
alias dc="docker-compose"

# Launch my pdf reader on a file and detach it
function pdf
  evince $argv &; disown
end

# Nix shell with fish as its shell
function ns
  nix-shell --run fish $argv
end

# Nix shell with python dependencies
function ns-python
  ns -p "python3.withPackages(ps: with ps; [ $argv ])"
end
function ns-python2
  ns -p "python2.withPackages(ps: with ps; [ $argv ])"
end

function ns-default-a
  ns -p "(import ./default.nix {}).$argv[1]" $argv[2..-1]
end

# Launch the manual
alias nixos-doc="nixos-help"
# Build the nixpkgs manual
alias nixpkgs-doc="nix build -f '<nixos/nixos/release-combined.nix>' nixpkgs.manual"
# Build all the document
alias nix-doc="nix build -f '<nixos>' nix.doc"

# Review a nixpkgs pull request
alias nr="nix-review"
# Run nix-review on the latest local commit
# One benefit: Builds reverse dependencies of the changes packages
function nr-local
  nix-review rev (git rev-parse HEAD)
end

# Print the human-readable size of a nix closure
function nix-size
  nix path-info -Sh $argv
end

# Print the derivation of a build product (if it's available in the nix-store)
function nix-derivation
  nix-store -qd $argv
end

# Build-time dependencies
function nix-deps
  nix-store -qR (nix-derivation $argv[1]) $argv[2..-1]
end
function nix-deps-tree
  nix-store -q --tree (nix-derivation $argv[1]) $argv[2..-1]
end

# Runtime dependencies
function nix-closure
  nix-store -qR $argv
end
function nix-closure-tree
  nix-store -q --tree $argv
end

# Find paths that depend on this
function nix-reverse-deps
  nix-store -q --referrers $argv
end

# Print nix garbage collection roots
alias nix-gc-roots "nix-store -q --roots"

# Checkout a GitHub pull request by its number
function checkout-pr
  set pr "pr-$argv[1]"
  git fetch upstream pull/$argv[1]/head:$pr; and git checkout $pr
end

# Guarantee to re-build a nix-expression, even if a build result is already in
# the cache or available with a substituter. Useful to debug transient issues.
# Better than `--check` because it also works when there is no version in the
# store yet and it won't complain about non-reproducibility.
function nix-rebuild
  set expression "with (import ./. {}); $argv[1].overrideAttrs (old: { REBUILD_MARKER="(random)"; })"
  echo "Building '$expression'"
  nix-build -E "$expression"
end

# Don't use binary caches
# --option build-use-substitutes false

# Systemd aliases (because I always mistype...)
function sstart
  sudo systemctl start $argv
end

function sstop
  sudo systemctl stop $argv
end

function sstatus
  systemctl status $argv
end

# Replacement
alias ll 'exa -l --group --git-ignore'

# Open files found by fzf fuzzy finder
alias vf 'vim (fzf)'

# Fancy Rust cat alternative
alias bat 'bat --theme=ansi-dark'

# Remove trailing whitespace
# + puts all found files as arguments after sed
# ; would run sed for every file found
function  rmtrail
  find -type f -exec sed -i 's/ *$//' {} +
end

# Ignore all -not -path '*/\.*'
# Ignore git directory
function find
  command find $argv -not -path '*/\.git*'
end

# Ignore binary files and git directory
alias codespell 'codespell -q 2 -S .git'

# Information about the output of a derivation
alias llbin 'll result/bin/'
alias lllib 'll result/lib/'
alias llman 'll result/share/man/*'

# List non-embedded fonts in a PDF
function lspdffonts
  nix-shell -p poppler_utils --run "pdffonts $argv | awk '\$4 == \"no\" {print \$0}'"
end

# List files that are not encoded with UTF-8 (or ASCII because that's a subset)
function ll-nonutf8
  find -type f | xargs file | grep -v -e ASCII -e UTF-8 #| awk -F ':' '{print $1}'
end

# Extract RPM in a subdirectory with the same name (minus file extension)
function unrpm
  set out_dir (basename -s .rpm $argv[1])
  mkdir $out_dir
  pushd $out_dir
  nix-shell -p rpm --run "rpm2cpio ../$argv[1] | cpio -idmv"
  popd
end

# Show all dependencies of RPM package
alias rpmdeps "rpm -qpR"

# Show the contents of a X.509 certificate
alias dumpcert "openssl x509 -text -noout -in"

# Print all files with more than one hardlink
alias findhardlinks "find . -type f -links +1 2>/dev/null"

# Find sparse files (size is bigger than their occupied disk space)
# Left column: BLOCK-SIZE*st_blocks / st_size
function findsparse
  find . -type f -printf "%S\t%p\n" | awk '$1 < 1.0 {print}'
end
