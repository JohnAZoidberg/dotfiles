# Mostly tasken from https://github.com/guserav/dotfiles

function fish_prompt --description 'Write out the prompt'
	set laststatus $status

    set -l nix_shell_info (
      # Variable can be empty, "impure" or "pure"
      if test -n "$IN_NIX_SHELL"
        echo -n "<nix>"
      end
      if test -n "$GUIX_ENVIRONMENT"
        echo -n "<guix>"
      end
    )

    function _git_branch_name
        echo (git symbolic-ref HEAD ^/dev/null | sed -e 's|^refs/heads/||')
    end
    function _is_git_dirty
        echo (git status -s --ignore-submodules=dirty ^/dev/null)
    end


    #if [ (_git_branch_name) ]
    #    set -l git_branch (set_color -o blue)(_git_branch_name)
    #    if [ (_is_git_dirty) ]
    #        for i in (git branch -qv --no-color| string match -r '\*'|cut -d' ' -f4-|cut -d] -f1|tr , '\n')\
    #            (git status --porcelain | cut -c 1-2 | uniq)
    #            switch $i
    #                case "*[ahead *"
    #                    set git_status "$git_status"(set_color red)⬆
    #                case "*behind *"
    #                    set git_status "$git_status"(set_color red)⬇
    #                case "."
    #                    set git_status "$git_status"(set_color green)✚
    #                case " D"
    #                    set git_status "$git_status"(set_color red)✖
    #                case "*M*"
    #                    set git_status "$git_status"(set_color green)✱
    #                case "*R*"
    #                    set git_status "$git_status"(set_color purple)➜
    #                case "*U*"
    #                    set git_status "$git_status"(set_color brown)═
    #                case "??"
    #                    set git_status "$git_status"(set_color red)≠
    #            end
    #        end
    #    else
    #        set git_status (set_color green):
    #    end
    #    set git_info "(git$git_status$git_branch"(set_color black)")"
    #end

    printf '%s[%s] %s%s%s%s%s%s%s%s%s' \
    \
    (set_color normal)                 \
    (date "+%H:%M:%S")                 \
    \
    (set_color blue)                   \
    $USER                              \
    \
    (set_color normal)                 \
    '  '                               \
    \
    (set_color green)                  \
    (echo $PWD | sed -e "s|^$HOME|~|") \
    \
    (set_color black)                  \
    $git_info                          \
    \
    (set_color black)

    if test $laststatus -eq 0
        printf "%s %s%s"     \
        (set_color -o green) \
	    $laststatus          \
        (set_color black)    \
        (set_color normal)
    else
        printf "%s %s%s"     \
        (set_color -o red)   \
	    $laststatus          \
        (set_color black)    \
        (set_color normal)
    end

    echo -n -s "$nix_shell_info"
    printf "\f\r>%s "
end
