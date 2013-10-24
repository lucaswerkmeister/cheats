function cheats {
    if [[ -f "$*" ]]; then
        __run_cheat "$*"; # mainly for debugging: absolute paths outside of ~/.cheats
    else
        IFS=' ';
        if [[ -f "$HOME/.cheats/$*" ]]; then
            __run_cheat "$HOME/.cheats/$*";
            unset IFS;
        else
            local visited="false";
            IFS=$(echo -en "\n\b"); # separate only by newlines in the for loop
            for file in $(IFS=' '; find -L ~/.cheats/ -name "$**" -type f); do
                if [[ "$visited" = "true" ]]; then
                    printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' '-'; # print a separator line with the width of the console
                fi
                tput bold; # print filename in bold
                basename "$file"; # print just the filename
                tput sgr0; # reset
                head -n 2 "$file"; # print the first two lines: description and command
                visited="true";
            done
            unset IFS;
            if [[ $visited = "false" ]]; then
                echo "No cheats with prefix \"$*\" found in ~/.cheats";
            fi
        fi
    fi
}

function __run_cheat {
    local file="$*";
    head -n 2 "$file"; # print first and second line: description and command
    local command=$(sed -n '2p' < "$file"); # read second line: command
    for line in "$(tail -n +3 "$file")"; do # skip the first two lines
        [[ "$line" = "" ]] && continue;
        local prompt="$(echo "$line" | sed 's/[^:]*:\(.*\)/\1/')";
        local name=$(echo "$line" | sed 's/\([^:]*\):.*/\1/');
        read -p "$prompt$PS2";
        command=$(echo "$command" | sed "s/\$$name/$REPLY/"); # replace the variable in the command
    done
    $command;
}
