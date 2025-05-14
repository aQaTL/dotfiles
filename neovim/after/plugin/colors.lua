local theme_preference = vim.fn.system("gsettings get org.gnome.desktop.interface color-scheme")
if string.find(theme_preference, "light") then
	vim.o.background = "light"
else
	vim.o.background = "dark"
end

vim.cmd([[colorscheme gruvbox]])
