local cmp = require("cmp")

cmp.setup {
	mapping = {
		['<CR>'] = function(fallback)
			if cmp.visible() then
				cmp.confirm()
			else
				fallback() -- If you use vim-endwise, this fallback will behave the same as vim-endwise.
			end
		end
	}
}
