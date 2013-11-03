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
            IFS=$(echo -en "\n\b"); # separate only by newlines in the for loop
            for file in $(IFS=' '; find -L ~/.cheats/ -name "$**" -type f | sort -n); do
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
        local name="${line/%:*}";
        local prompt="${line/#*:}";
        read -p "$prompt$PS2";
        command=${command//\$$name/$REPLY}; # replace the variable in the command (all occurrences)
    done
    __print_separator_line;
    eval "$command";
}

function __print_separator_line {
    printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' '-'; # print a separator line with the width of the console
}

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
    IFS=$'\n'; local allCheats=( $(ls -1 ~/.cheats ) );
    j=0;
    for (( i=0; i < ${#allCheats[*]}; i++ )); do
        if [[ -z "${allCheats[i]/#$compInput*}" ]]; then
            # cheat matches completion input
            # we now need to translate 
            # "git re" ($compInput) and
            # "git rebase 1" ($allCheats[i])
            # into "rebase 1"
            IFS=' ';
            local currentCheatArray=( ${allCheats[i]} );
            local firstDiffIndex=0;
            while [[ ${currentCheatArray[$firstDiffIndex]} == ${compInputArray[$firstDiffIndex]}
                    && $firstDiffIndex < ${#currentCheatArray} ]]; do
                firstDiffIndex=$((firstDiffIndex + 1));
            done
            COMPREPLY[$((j++))]="${currentCheatArray[*]:$firstDiffIndex}";
        fi
    done
}
complete -F _cheats cheats;
