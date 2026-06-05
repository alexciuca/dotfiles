return {
	{
		"rebelot/kanagawa.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			require("kanagawa").setup({
				compile = false,
				dimInactive = true,
				theme = "dragon",
				background = { dark = "dragon", light = "lotus" },
			})
			vim.cmd.colorscheme("kanagawa-dragon")
		end,
	},
}
