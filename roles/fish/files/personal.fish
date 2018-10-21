export GOPATH="/home/zoid/cloudhome/projects/gopath/"

# variables to cd easier into important nix directories
set nix "$HOME/media/clone/reference/nixpkgs/"
set nixchannels "$HOME/media/clone/reference/nixpkgs-channels/"
set conf "$HOME/cloudhome/nixconfig/daniel"
function nixpkgs
    cd (nix eval --raw "(import $conf/nixpkgs.nix).src")
end

# usage:
# $ localnix $PATH_TO_NIXPKGS {test, rebuild}
function localnix
    set NIXPKGS $argv[1]
    sudo nixos-rebuild -I nixos=$NIXPKGS/nixos -I nixpkgs=$NIXPKGS $argv[2..-1]
    sudo rm result # TODO remove result if test
end

function localnixshell
    set NIXPKGS "$HOME/media/clone/nixpkgs-channels"
    nix-shell -I nixpkgs=$NIXPKGS $argv
end
