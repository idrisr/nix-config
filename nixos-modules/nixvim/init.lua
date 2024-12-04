local telescope = require("telescope")
telescope.load_extension("hoogle")
vim.diagnostic.config({
	virtual_lines = { only_current_line = true },
	virtual_text = false,
})
vim.cmd("autocmd User TelescopePreviewerLoaded setlocal number")

require("outline").setup({})

require("lspconfig").texlab.setup({
	document_config = {
		{
			default_config = {
				settings = {
					texlab = {
						auxDirectory = ".",
						bibtexFormatter = "texlab",
						build = {
							args = { "-pdf", "-interaction=nonstopmode", "-synctex=1", "%f" },
							executable = "latexmk",
							forwardSearchAfter = false,
							onSave = false,
						},
						chktex = {
							onEdit = false,
							onOpenAndSave = true,
						},
						diagnosticsDelay = 300,
						formatterLineLength = 80,
						forwardSearch = {
							args = {},
						},
						latexFormatter = "latexindent",
						latexindent = {
							modifyLineBreaks = false,
						},
					},
				},
				single_file_support = true,
			},
		},
	},
})
