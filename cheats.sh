function cheats
{
    if [[ -f "$@" ]]; then
        __run_cheat $@; # mainly for debugging: absolute paths outside of ~/.cheats
    else
        if [[ -f "~/.cheats/$@" ]]; then
            __run_cheat "~/.cheats/$@";
        else
            local visited="false";
            local oldIFS=$IFS;
            IFS=$(echo -en "\n\b"); # separate only by newlines in the for loop
            for file in $(find ~/.cheats/ -iname "$@*")
            do
                if [[ $visited = "true" ]]; then
                    printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' -; # print a separator line with the width of the console
                fi
                basename $file; # print just the filename
                head -n 2 "$file"; # print the first two lines: description and command
                visited="true";
            done
            IFS=$oldIFS; # restore backup
            if [[ $visited = "false" ]]; then
                echo No cheats with prefix \"$@\" found in ~/.cheats
            fi
        fi
    fi
}

function __run_cheat
{
    local file="$@";
    head -n 1 "$file"; # print first line: description
    local command=$(sed -n '2p' < "$file"); # read second line: command
    for line in "$(tail -n +3 "$file")" # skip the first two lines
    do
        local prompt="$(echo "$line" | sed 's/[^:]*:\(.*\)/\1/')";
        local name=$(echo "$line" | sed 's/\([^:]*\):.*/\1/');
        read -p "$prompt$PS2";
        command=$(echo $command | sed "s/\$$name/$REPLY/"); # replace the variable in the command
    done
    $command;
}
