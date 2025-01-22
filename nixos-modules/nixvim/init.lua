local telescope = require("telescope")
telescope.load_extension("hoogle")
vim.diagnostic.config({
	virtual_lines = { only_current_line = true },
	virtual_text = false,
})

vim.api.nvim_create_autocmd("User", {
	pattern = { "TelescopePreviewerLoaded" },
	callback = function()
		vim.api.nvim_set_option_value("number", true, { scope = "local" })
	end,
})

require("outline").setup({})
require("lspconfig").hls.setup({})
require("lspconfig").lua_ls.setup({
	settings = {
		Lua = {
			diagnostics = {
				globals = { "vim" },
			},
		},
	},
})
