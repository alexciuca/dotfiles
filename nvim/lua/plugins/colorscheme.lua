return {
	{
		"NTBBloodbath/doom-one.nvim",
		lazy = false,
		priority = 1000,
		init = function()
			vim.g.doom_one_cursor_coloring = false
			vim.g.doom_one_terminal_colors = true
			vim.g.doom_one_italic_comments = false
			vim.g.doom_one_enable_treesitter = true
			vim.g.doom_one_diagnostics_text_color = false
			vim.g.doom_one_transparent_background = false
			vim.g.doom_one_pumblend_enable = false

			-- Integrations: only the plugins actually installed here
			vim.g.doom_one_plugin_telescope = true
			vim.g.doom_one_plugin_whichkey = true
			vim.g.doom_one_plugin_neorg = false
			vim.g.doom_one_plugin_barbar = false
			vim.g.doom_one_plugin_neogit = false
			vim.g.doom_one_plugin_nvim_tree = false
			vim.g.doom_one_plugin_dashboard = false
			vim.g.doom_one_plugin_startify = false
			vim.g.doom_one_plugin_indent_blankline = false
			vim.g.doom_one_plugin_vim_illuminate = false
			vim.g.doom_one_plugin_lspsaga = false
		end,
		config = function()
			-- doom-one ships comments at base5 #5B6268 = 2.3:1 on #282c34, under
			-- WCAG AA. Lift to the theme's own base7 (#9ca0a4) = 5.3:1, still
			-- clearly dim grey. On a ColorScheme autocmd so it survives reloads.
			vim.api.nvim_create_autocmd("ColorScheme", {
				pattern = "doom-one",
				callback = function()
					for _, group in ipairs({
						"Comment",
						"@comment",
						"@comment.documentation",
						"SpecialComment",
					}) do
						vim.api.nvim_set_hl(0, group, { fg = "#9ca0a4" })
					end
				end,
			})

			vim.opt.background = "dark"
			vim.cmd.colorscheme("doom-one")
		end,
	},
}
