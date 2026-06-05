vim.g.mapleader = " "
vim.g.maplocalleader = " "

local mason_bin = vim.fs.joinpath(vim.fn.stdpath("data"), "mason", "bin")
if not (vim.env.PATH or ""):find(mason_bin, 1, true) then
	vim.env.PATH = mason_bin .. ":" .. (vim.env.PATH or "")
end

local opt = vim.opt
opt.number = true
opt.relativenumber = true
opt.signcolumn = "yes"
opt.clipboard = "unnamedplus"
opt.cursorline = true
opt.wrap = false
opt.expandtab = true
opt.tabstop = 4
opt.softtabstop = 4
opt.shiftwidth = 4
opt.smartindent = true
opt.swapfile = false
opt.backup = false
opt.termguicolors = true
opt.undofile = true
opt.undodir = vim.fs.joinpath(vim.env.HOME or "~", ".vim", "undodir")
opt.splitright = true
opt.splitbelow = true
opt.scrolloff = 4

vim.filetype.add({
	extension = {
		razor = "razor",
		cshtml = "razor",
	},
})
