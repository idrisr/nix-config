vim.g["surround_" .. vim.fn.char2nr("l")] = "[[\r]]"
vim.api.nvim_set_keymap("n", "dsl", ":normal ds[ds[<cr>", { noremap = true })
