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

dap.adapters.gdb = {
	type = "executable",
	command = "gdb",
	args = { "-i", "dap" },
}

dap.adapters.lldb = {
	type = "executable",
	command = "/nix/store/xsk02903mk555ga559g7rgv7y7329kwq-lldb-14.0.6/bin/lldb-vscode",
	name = "lldb",
}

dap.configurations.cpp = {
	{
		name = "Launch",
		type = "lldb",
		request = "launch",
		program = function()
			return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
		end,
		cwd = "${workspaceFolder}",
		stopOnEntry = true,
		args = {},
	},
}

dap.configurations.c = {
	{
		name = "Launch",
		type = "gdb",
		request = "launch",
		program = function()
			return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
		end,
		cwd = "${workspaceFolder}",
		stopAtBeginningOfMainSubprogram = true,
	},
}

vim.api.nvim_set_keymap("n", "<leader>db", [[:lua require"dap".toggle_breakpoint()<CR>]], { noremap = true })
vim.api.nvim_set_keymap("n", "<leader>dc", [[:lua require"dap".continue()<CR>]], { noremap = true })
vim.api.nvim_set_keymap("n", "<leader>dso", [[:lua require"dap".step_over()<CR>]], { noremap = true })
vim.api.nvim_set_keymap("n", "<leader>dsi", [[:lua require"dap".step_into()<CR>]], { noremap = true })
vim.api.nvim_set_keymap("n", "<leader>dh", [[:lua require"dap.ui.widgets".hover()<CR>]], { noremap = true })
vim.api.nvim_set_keymap("n", "<leader>dl", [[:lua require"osv".launch({port = 8086})<CR>]], { noremap = true })
vim.api.nvim_set_keymap("n", "<leader>dt", [[:lua require"dapui".toggle()<CR>]], { noremap = true })
