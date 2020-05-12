# Smart history, use the begining of the line something is already typed
vim-mode-bindkey viins vicmd -- up-line-or-beginning-search '^P'
vim-mode-bindkey viins vicmd -- down-line-or-beginning-search '^N'

# Double escape put into normal mode without delay
# But it overrides Alt + arrow_keys, which I don't care
bindkey -rpM viins '^[^['
