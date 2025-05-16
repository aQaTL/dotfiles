local lsp = require("lsp-zero")
local telescope = require("telescope.builtin")
local mason = require("mason")
local mason_lspconfig = require("mason-lspconfig")

mason.setup({
	ensure_installed = { 'rust_analyzer' },
	handlers = {
		function(server_name) 
				require("lspconfig")[server_name].setup({})
		end,
	}
})

-- lsp.preset("recommended")

-- lsp.ensure_installed({
-- 	'rust_analyzer',
-- })

local cmp = require('cmp')
local cmp_select = { behavior = cmp.SelectBehavior.Select }
-- local cmp_mappings = lsp.defaults.cmp_mappings({
-- 	['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
-- 	['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
-- 	['<C-y>'] = cmp.mapping.confirm({ select = true }),
-- 	["<C-Space>"] = cmp.mapping.complete(),
-- })

-- lsp.setup_nvim_cmp({
-- 	mapping = cmp_mappings
-- })

local lsp_disabled = false

vim.keymap.set("n", "<leader>ls", function ()
	lsp_disabled = true
	-- vim.cmd([[LspStop ++force]])

	vim.lsp.stop_client(vim.lsp.get_clients(), true)
	print("lsp stopped")
end, {})

lsp.on_attach(function(client, bufnr)
	local opts = { buffer = bufnr, remap = false }

	if lsp_disabled then
		--vim.cmd([[LspStop ++force]])
		--
		vim.lsp.stop_client(vim.lsp.get_clients(), true)
		print("lsp prevented")
		return
	end

	if client.name == "eslint" then
		vim.cmd.LspStop('eslint')
		return
	end

	vim.api.nvim_create_autocmd({ "CursorHold" }, {
		pattern = { "*.rs" },
		callback = function(ev)
			vim.lsp.buf.document_highlight(ev)
		end
	})

	vim.api.nvim_create_autocmd({ "CursorMoved" }, {
		pattern = { "*.rs" },
		callback = function(ev)
			vim.lsp.buf.clear_references()
		end
	})

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

end)

lsp.configure("rust_analyzer", {
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

lsp.setup()

