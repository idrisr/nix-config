local telescope = require("telescope")
telescope.load_extension("hoogle")

vim.diagnostic.config({
	virtual_text = {
		prefix = "●", -- Customize the prefix as desired
		source = "always", -- Show source of diagnostic
		spacing = 2, -- Increase spacing between text and virtual text
		format = function(diagnostic)
			local message = diagnostic.message
			local max_width = 80 -- Adjust this value to your screen width
			if #message > max_width then
				message = message:sub(1, max_width) .. "..."
			end
			return message
		end,
	},
})
