local telescope = require("telescope")
telescope.load_extension("hoogle")
vim.diagnostic.config({
})

require("nvls").setup({
	virtual_lines = { only_current_line = true },
	virtual_text = false,
})
