#ID:~:Egm4dK7W
What is the 'small delete register' (`-`)?
---
It contains deleted or changed content smaller than one line
#ID:~:Wn3gJ0Mn
Which read-only register contains the name of the current file?
---
The `%` register
#ID:~:1GWkdEN6
What is the 'unnamed register' (referenced with `"`)?
---
It contains the last deleted, changed, or yanked content
#ID:~:uHZjKJ7u
In a Vim command range, what does the symbol `.` represent?
---
The current line
#ID:~:2YaYeSdP
In INSERT mode, which shortcut allows you to insert the content of a register (e.g., register 'a')?
---
`CTRL-R a`
#ID:~:nwYL8BMX
Which read-only register contains the most recent command line executed?
---
The `:` register
#ID:~:bJinBxB6
What does the command `:v/pattern/command` do?
---
Executes the command on every line `NOT` matching the pattern
#ID:~:CnOjmPsc
In a substitute command, what does the flag `&` do?
---
Uses the flags from the previous substitute command
#ID:~:ON7632RF
What's the syntax for a normalish regex in a vim substitute?
---
`:%s/\v(input)/\1wut/` -- capture input and use as \1 in result
#ID:~:KxfNY1tg
In a substitute command, what does the flag `i` do?
---
Makes the pattern case-insensitive
#ID:~:TxYhYCEB
In a substitute command, what does the flag `n` do?
---
Reports the number of matches without actually substituting
#ID:~:KowLiyHZ
Evaluate a bash command and populate quick fix list with {{`:cex system("ls")`}}
#ID:~:32G4EWP1
Which read-only register contains the last inserted text?
---
The `.` register
#ID:~:nhBkiHt8
In a Vim command range, what does the symbol `*` represent?
---
The last selection made in VISUAL mode
#ID:~:jdLT3Pn7
Empty quick fix list quickly with {{`:cex []`}}
#ID:~:qJmPtnKy
What is the basic syntax for the global command?
---
`:g/pattern/command`
#ID:~:Ywrmp1xz
What does the command `:g/ERROR/d` do?
---
Deletes every line containing the word 'ERROR'
#ID:~:3HuJYUlt
In a Vim command range, what does the symbol `$` represent?
---
The last line of the current buffer
#ID:~:4hwmg2Q2
Vim Syntax to search all `.rb` files for `hello`: {{:vimgrep hello \*\*/\*.rb}}
#ID:~:JfFGVwMH
In a substitute command, what does the flag `c` do?
---
Confirm each substitution
#ID:~:660YNxIs
In a substitute command (`:s/pat/repl/g`), what does the flag `g` do?
---
Replace all occurrences in each line (global)
#ID:~:pvGFnsz4
In a Vim command range, what does the symbol `%` represent?
---
The entire file (shorthand for 1,$)
#ID:~:48yCcW6U
Registers `1-9` function as a stack. Which register receives the most recently deleted or changed content?
---
Register 1
#ID:~:EA18KRLp
Which numbered register contains the content of the last yank?
---
Register `0`
#ID:~:ZYjvpFXR
Vim has 26 'named registers' (`a-z`). How do you append to register 'a' instead of overwriting it?
---
Use the uppercase version: "A