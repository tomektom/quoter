# About

This small script display you inspirational quote. Copy all wherever you want and run `./quoter.sh`

## Help

```
Simple inspirational quotes. Usage:
   quoter                                                  – display random quote
   quoter help                                             - display help
   quoter day                                              - display quote of day
   quoter num [ <int> ]                                    - display quote from this line
   quoter config                                           - configuration
   quoter int                                              - interactive mode
   quoter walk [ <int> <step> ]                            - walk mode
   quoter loop [ random | num | int ]                      - quoter in loop
   quoter gui [ random | day | num [ <int> ] | config ]    - gui (with kdialog)
   quoter gui walk [ <int> <step> ]                        - walk mode
   quoter loop gui [ num | random ]                        - gui in loop
You can use custom file witch quotes with pattern `author(divider)quote`, example:
René Descartes;Cogito ergo sum
```

## Command not found handler

`quoter-handler` is highly inspired by [bash-insulter](https://github.com/hkbakke/bash-insulter) and do almost same thing, but instead insult you print you inspirational quote when you write wrong command :) If you want to use it run `quoter config`, you'll be asked for adding it to your .zshrc and .bashrc file. After that restart your computer or run `source ~/.zshrc` for zsh or `source ~/.bashrc` for bash.
