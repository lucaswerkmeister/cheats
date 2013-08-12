cheats
======

`cheats` is a command line utility that allows you to define interactive cheat cheets for the command line.
This is intended mainly for command that you use frequently, but not frequently enough to remember them.

`cheats` was inspired by [`cheat`](htps://github.com/chrisallenlane/cheat) by chrisallenlane, although it contains none of its code.

Installation
------------

Put `cheats.sh` somewhere and source it on bash startup (for example, `echo -en '\n\n' | cat - cheats.sh >> ~/.bashrc`), then copy the cheats folder into your home folder (`cp cheats ~/.cheats`).

Usage
-----

    $ cheats dd
    dd 1
    Backup your primary drive
    dd if=/dev/sda of=$backup
    ------------------------------------------------
    dd 2
    Burn a disc image
    dd if=$file of=/dev/cdrom
    $ cheats dd 1
    Backup your primary drive
    Backup file path> [prompt]
    [dd runs]

If the argument(s) match(es) exactly one cheat, then that cheat is run.
Otherwise, all matching cheats are printed, and you can select one.

Defining cheats
---------------

Cheats are placed in the ~/.cheats directory, with one file per cheat.
Each cheat has the following format:

    One-line description
    The command itself, where $variables can be defined like $this
    variablename:Prompt
    other_variable:Prompt 2
    ...

Any variables that you declare from the third line on will be prompted from the user and placed into the command where necessary.
(It's completely okay if the variable isn't in the command; this is useful for "Are you sure?" type prompts where you don't care about the input, but want the user to press enter before taking action.)
Any variables left in the command after the prompts are inserted are replaced by bash, if they are present (things like $PWD, $PS1 etc.).

System requirements
-------------------

`cheats` was written for `bash`.

    * `sh`: Doesn't work at all. Even if you fix the easy stuff (`function x` -> `x()`, `[[ ... ]]` -> `[ ... ]`), it still does some weird stuff so that the filenames are messed up. Not sure why.
    * `zsh`: Works as long as there is only one argument; invoke with `cheats "git commit 1"` instead of `cheats git commit 1`. There's probably a simple fix if you know `zsh`, but I don't.
    * `csh`: Doesn't work at all. I also have no knowledge of this shell, so I don't know if it even could work.

Other than your shell, the following commands are used: `printf`, `basename`, `head`, `tail`, `sed`. For `dpkg`: With the exception of `sed`, they are all part of `coreutils`. `sed` is part of package `sed`.
