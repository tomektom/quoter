# About

```
Simple inspirational quotes. Usage:
   quoter                                                  – display random quote
   quoter help                                             - display help
   quoter day                                              - display quote of day
   quoter num [ <int> ]                                    - display quote from this line
   quoter config                                           - configuration
   quoter int                                              - interactive mode
   quoter loop [ random | num | int ]                      - quoter in loop
   quoter gui [ random | day | num [ <int> ] | config ]    - gui (with kdialog)
   quoter loop gui [ num | random ]                        - gui in loop
You can use custom file witch quotes with pattern `author(divider)quote`, example:
René Descartes;Cogito ergo sum
```

`quoter-handler.sh` file is highly inspired by [bash-insulter](https://github.com/hkbakke/bash-insulter) and do almost same thing, but instead insult you print you inspirational quote when you write wrong command :) If you want to use it run `quoter config`, you'll be asked for adding it to your .zshrc and .bashrc file.
