# home/dot_config/nvim/

Group fields in lazy.nvim plugin specs in this order:

1. Setup fields, in this order: `dependencies`, `init`, `opts`, `config`.
2. Loading fields, in this order: `lazy`, `cond`, `event`, `ft`, `cmd`, `keys`.

Write `event`, `cmd`, and `keys` lists as multiline Lua tables, with one entry per line, even for a single entry.
