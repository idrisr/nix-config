local dap = require("dap")
dap.configurations.lua = {
	{
		type = "nlua",
		request = "attach",
		name = "Attach to running Neovim instance",
	},
}

dap.adapters.nlua = function(callback, config)
	callback({ type = "server", host = config.host or "127.0.0.1", port = config.port or 8086 })
end

-- dap.configurations = {
-- ["lua"] = {
-- {
-- type = "lua",
-- request = "attach",
-- name = "Attach to running Neovim instance",
-- },
-- },
-- ["cpp"] = {
-- {
-- name = "Launch",
-- type = "gdb",
-- request = "launch",
-- program = function()
-- return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/result/bin/git-crypt", "file")
-- end,
-- cwd = "${workspaceFolder}",
-- stopAtBeginningOfMainSubprogram = true,
-- },
-- },
-- }

-- dap.adapters = {
-- ["lua"] = function(callback, config)
-- callback({ type = "server", host = config.host or "127.0.0.1", port = config.port or 8086 })
-- end,

-- ["gdb"] = {
-- type = "executable",
-- command = "gdb",
-- args = { "-i", "dap" },
-- },
-- }

vim.api.nvim_set_keymap("n", "<leader>db", [[:lua require"dap".toggle_breakpoint()<CR>]], { noremap = true })
vim.api.nvim_set_keymap("n", "<leader>dc", [[:lua require"dap".continue()<CR>]], { noremap = true })
vim.api.nvim_set_keymap("n", "<leader>dso", [[:lua require"dap".step_over()<CR>]], { noremap = true })
vim.api.nvim_set_keymap("n", "<leader>dsi", [[:lua require"dap".step_into()<CR>]], { noremap = true })
vim.api.nvim_set_keymap("n", "<leader>dh", [[:lua require"dap.ui.widgets".hover()<CR>]], { noremap = true })
vim.api.nvim_set_keymap("n", "<leader>dl", [[:lua require"osv".launch({port = 8086})<CR>]], { noremap = true })
vim.api.nvim_set_keymap("n", "<leader>dt", [[:lua require"dapui".toggle()<CR>]], { noremap = true })
