-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Setup lazy.nvim
require("lazy").setup({
  spec = {
    -- import your plugins
    { import = "plugins" },
  },
  -- Configure any other settings here. See the documentation for more details.
  -- colorscheme that will be used when installing plugins.
  install = { colorscheme = { "habamax" } },
  -- automatically check for plugin updates
  checker = { enabled = true, notify = false },
})

-- LSP SETUP

local telescope = require("telescope.builtin")
local mason = require("mason")

vim.lsp.config("rust_analyzer", {
	settings = {
		["rust-analyzer"] = {
			workspace = {
				symbol = {
					search = {
						kind = "all_symbols"
					}
				}
			}
		}
	}
})

vim.lsp.config("lua_ls", {
	settings = {
		Lua = {
			diagnostics = {
				globals = {
					"vim"
				}
			}
		}
	}
})

local lsp_disabled = false

vim.keymap.set("n", "<leader>ls", function ()
	lsp_disabled = true
	-- vim.cmd([[LspStop ++force]])

	vim.lsp.stop_client(vim.lsp.get_clients(), true)
	print("lsp stopped")
end, {})

vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("my.lsp", {}),
	callback = function(args)
		local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
		local bufnr = args.buf

		local opts = { buffer = bufnr, remap = false }

		if lsp_disabled then
			--vim.cmd([[LspStop ++force]])
			--
			vim.lsp.stop_client(vim.lsp.get_clients(), true)
			print("lsp prevented")
			return
		end

		vim.lsp.completion.enable(true, args.data.client_id, bufnr, { autotrigger = true })

		vim.keymap.set("i", "<C-space>", vim.lsp.completion.get, { 
			desc = "trigger autocompletion",
		})

		if client.server_capabilities.documentHighlightProvider then 
			vim.api.nvim_create_autocmd({ "CursorHold" }, {
                buffer = bufnr,
				callback = function(ev)
					vim.lsp.buf.document_highlight(ev)
				end
			})

			vim.api.nvim_create_autocmd({ "CursorMoved" }, {
                buffer = bufnr,
				callback = function(ev)
					vim.lsp.buf.clear_references()
				end
			})
		end

		vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
		vim.keymap.set("n", "<F12>", vim.lsp.buf.definition, opts)
		vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
		vim.keymap.set("n", "<leader>vws", vim.lsp.buf.workspace_symbol, opts)
		vim.keymap.set("n", "<leader>vd", vim.diagnostic.open_float, opts)
		vim.keymap.set("n", "<F1>", vim.diagnostic.open_float, opts)
		vim.keymap.set("n", "[d", vim.diagnostic.goto_next, opts)
		vim.keymap.set("n", "]d", vim.diagnostic.goto_prev, opts)
		vim.keymap.set("n", "<leader>vca", vim.lsp.buf.code_action, opts)
		vim.keymap.set("n", "<leader><F1>", vim.lsp.buf.code_action, opts)
		vim.keymap.set("n", "<leader>vrr", vim.lsp.buf.references, opts)
		vim.keymap.set("n", "<leader><F7>", vim.lsp.buf.references, opts)
		vim.keymap.set("n", "<leader>vrn", vim.lsp.buf.rename, opts)
		vim.keymap.set("i", "<C-h>", vim.lsp.buf.signature_help, opts)
		vim.keymap.set("n", "<leader><F9>", vim.lsp.buf.document_symbol, opts)
		vim.keymap.set("n", "<F4>", vim.lsp.buf.format, opts)

		-- Telescope pickers
		vim.keymap.set("n", "<F9>", telescope.lsp_document_symbols, opts)
		vim.keymap.set("n", "<F7>", telescope.lsp_references, opts)
		vim.keymap.set("n", "<leader><leader>", telescope.lsp_dynamic_workspace_symbols, opts)
		vim.keymap.set("n", "<leader>w", telescope.lsp_workspace_symbols, opts)


		-- configure document_highlight colors
		local theme_preference = vim.fn.system("gsettings get org.gnome.desktop.interface color-scheme")
		if string.find(theme_preference, "light") then
			vim.cmd([[ highlight LspReferenceText guibg=#d5c4a1 ]]) -- slightly brighter than CursorLine
		else
			vim.cmd([[ highlight LspReferenceText guibg=#4c4744 ]]) -- slightly brighter than CursorLine
		end
		vim.cmd([[ highlight link LspReferenceRead CursorLine ]])
		vim.cmd([[ highlight link LspReferenceWrite CursorLine ]])
	end
})


