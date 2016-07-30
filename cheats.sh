function cheats {
    local IFS;
    if [[ -f "$*" ]]; then
        __run_cheat "$*"; # mainly for debugging: absolute paths outside of ~/.cheats
    else
        IFS=' ';
        if [[ -f "$HOME/.cheats/$*" ]]; then
            __run_cheat "$HOME/.cheats/$*";
        else
            local visited="false";
            for file in ~/.cheats/"$*"*; do
                ! [[ -f "$file" ]] && continue; # skip things that aren't files
                if [[ "$visited" = "true" ]]; then
                    __print_separator_line;
                fi
                tput bold; # print filename in bold
                basename -- "$file"; # print just the filename
                tput sgr0; # reset
                head -n 2 -- "$file"; # print the first two lines: description and command
                visited="true";
            done
            if [[ $visited = "false" ]]; then
                echo "No cheats with prefix \"$*\" found in ~/.cheats";
            fi
        fi
    fi
}

function __run_cheat {
    local IFS;
    local file="$*";
    head -n 2 -- "$file"; # print first and second line: description and command
    local command=$(sed -n '2p' -- "$file"); # read second line: command
    IFS=$'\n';
    for line in $(tail -n +3 -- "$file"); do # skip the first two lines
        if [[ -z "$line" || ${line:0:1} == '#' ]]; then
            # blank line or comment line
            continue;
        fi
        local name="${line%%:*}";
        local prompt="${line##*:}";
        read -e -p "$prompt$PS2";
        command=${command//\$$name/$REPLY}; # replace the variable in the command (all occurrences)
    done
    __print_separator_line;
    eval "$command";
}

function __print_separator_line {
    printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' '-'; # print a separator line with the width of the console
}

if shopt -q progcomp 2> /dev/null; then
    # bash completion
    # to understand how this function manipulates variables,
    # I recommend reading the sections "Parameter Expansion" and "Arrays" of the bash manpage.
    function _cheats {
        if [[ ! -d ~/.cheats ]]; then
            return 0;
        fi
        local IFS;
        IFS=' '; local compInput="${COMP_WORDS[*]:1}"; # strip away "cheats" command
        local compInputArray=( $compInput );
        IFS=$'\n'; local allCheats=(~/.cheats/*);
        j=0;
        shopt -q nullglob; hadNullglob=$?
        shopt -s nullglob
        for cheat in ~/.cheats/"$compInput"*; do
            # cheat matches completion input
            # we now need to translate
            # "git re" ($compInput) and
            # "~/.cheats/git rebase 1" ($cheat)
            # into "rebase 1"
            IFS=' ';
            local currentCheatArray=( ${cheat#~/.cheats/} );
            local firstDiffIndex=0;
            while [[ ${currentCheatArray[$firstDiffIndex]} == ${compInputArray[$firstDiffIndex]}
                            && $firstDiffIndex < ${#currentCheatArray} ]]; do
                ((firstDiffIndex++));
            done
            if [[ $COMP_CWORD == $firstDiffIndex ]]; then
                ((firstDiffIndex--)); # don’t override the current word; see #3
            fi
            COMPREPLY[$((j++))]="${currentCheatArray[*]:$firstDiffIndex}";
        done
        if ((hadNullglob==0)); then shopt -u nullglob; fi
    }
    complete -F _cheats cheats;
fi
