cheats
======

`cheats` is a command line utility that allows you to define interactive cheat cheets for the command line.
This is intended mainly for command that you use frequently, but not frequently enough to remember them.

`cheats` was inspired by [`cheat`](https://github.com/chrisallenlane/cheat) by chrisallenlane, although it contains none of its code. There is also a [bash reimplementation of `cheat`](https://github.com/jahendrie/cheat) by jahendrie.

Installation
------------

Put `cheats.sh` somewhere and source it on bash startup (for example, `echo -en '\n\n' | cat - cheats.sh >> ~/.bashrc`), then copy the cheats folder into your home folder (`cp -r cheats ~/.cheats`).

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
  * `zsh`: *Kinda* works. I don't know the specifics of `zsh`, so I can't fix it. If you can, off to CONTRIBUTING.md with you!
  * `csh`, `ksh`: Doesn't work at all. I also have no knowledge of these shells, so I don't know if it even could work.

Other than your shell, the following commands are used: `printf`, `basename`, `head`, `tail`, `sed`, `grep`. For `dpkg`: `sed` and `grep` are in their own packagis, they rest are part of `coreutils`.
