require("nvim-tree").setup {
	actions = {
		open_file = {
			quit_on_open = true,
		},
	},
}
local api = require("nvim-tree.api")
vim.keymap.set("n", "<leader>e", api.tree.toggle, {})
vim.keymap.set("n", "<F8>", function() api.tree.toggle({ find_file=true }) end, {})
