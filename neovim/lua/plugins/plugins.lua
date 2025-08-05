return {
	{
		"mason-org/mason-lspconfig.nvim",
		tag = "v2.0.0",
		lazy = false,
		opts = {
			ensure_installed = { "rust_analyzer" },
		},
		dependencies = {
			{ "mason-org/mason.nvim", opts = {} },
			"neovim/nvim-lspconfig",
		},
	},
	{
		"neovim/nvim-lspconfig",
		tag = "v2.3.0",
	},
	{
		"ellisonleao/gruvbox.nvim",
		config = function()
			local theme_preference = vim.fn.system("gsettings get org.gnome.desktop.interface color-scheme")
			if string.find(theme_preference, "light") then
				vim.o.background = "light"
			else
				vim.o.background = "dark"
			end

			vim.cmd([[colorscheme gruvbox]])
		end
	},
	{
		"airblade/vim-gitgutter",
	},
	{
		"nvim-telescope/telescope.nvim",
		--tag = "0.1.8",
		commit = "b4da76b",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-telescope/telescope-file-browser.nvim",
		},
		init = function()
			local builtin = require("telescope.builtin")
			vim.keymap.set("n", "<leader>f", builtin.find_files, {})
			vim.keymap.set("n", "<leader>af", function ()
				builtin.find_files({ no_ignore = true, hidden = true })
			end, {})
			vim.keymap.set("n", "<leader>g", builtin.git_files, {})
			vim.keymap.set("n", "<leader>s", builtin.live_grep, {})
			vim.keymap.set("n", "<leader>/", builtin.live_grep, {})
			vim.keymap.set("n", "<leader>b", builtin.buffers, {})

			-- TODO: Remove the leader. Problem: lsp-zero default mappings override <F3> when attaching lsp
			vim.keymap.set("n", "<leader><F3>", builtin.current_buffer_fuzzy_find, {})

			require("telescope").load_extension "file_browser"

			vim.keymap.set(
				"n",
				"<leader>w",
				function()
					require("telescope").extensions.file_browser.file_browser()
				end,
				{ noremap = true }
			)
		end
	},
	{
		"nvim-tree/nvim-tree.lua",
		tag = "v1.12.0",
		config = function()
			require("nvim-tree").setup({
				actions = {
					open_file = {
						quit_on_open = true,
					}
				}
			})
			local api = require("nvim-tree.api")
			vim.keymap.set("n", "<leader>e", api.tree.toggle, {})
			vim.keymap.set("n", "<F8>", function() api.tree.toggle({ find_file=true }) end, {})
		end
	},
	{
		"nvim-treesitter/nvim-treesitter",
		tag = "v0.10.0",
		lazy = false,
		build = function()
			require("nvim-treesitter.install").update({ with_sync = true })()
		end,
		opts = {
			-- A list of parser names, or "all"
			ensure_installed = "all",

			-- Install parsers synchronously (only applied to `ensure_installed`)
			sync_install = false,

			-- Automatically install missing parsers when entering buffer
			-- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
			auto_install = false,

			highlight = {
				-- `false` will disable the whole extension
				enable = true,

				-- Setting this to true will run `:h syntax` and tree-sitter at the same time.
				-- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
				-- Using this option may slow down your editor, and you may see some duplicate highlights.
				-- Instead of true it can also be a list of languages
				additional_vim_regex_highlighting = false,
		  },
	  }
	},
}
