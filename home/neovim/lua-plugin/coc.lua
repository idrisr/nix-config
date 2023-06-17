vim.api.nvim_set_keymap("n", "<leader>cl", "<Plug>(coc-codelens-action)", {})
vim.api.nvim_create_user_command("Format", "call CocAction('format')", {})

