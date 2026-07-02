return {
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "echasnovski/mini.icons" },
		event = "VeryLazy",
		opts = {
			options = {
				theme = "kanagawa",
				globalstatus = true,
				section_separators = "",
				component_separators = "",
			},
			sections = {
				lualine_c = { { "filename", path = 1 } },
				lualine_x = { "diagnostics", "filetype" },
			},
		},
	},
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		opts = {
			preset = "modern",
			spec = {
				{ "<leader>s", group = "search" },
				{ "<leader>m", group = "make" },
				{ "<leader>d", group = "debug" },
				{ "<leader>t", group = "test" },
				{ "<leader>c", group = "code" },
				{ "<leader>r", group = "rename/refactor" },
				{ "<leader>j", group = "java" },
				{ "<leader>g", group = "git" },
				{ "<leader>e", desc = "Line diagnostics" },
				{ "<leader>q", desc = "Diagnostics → loclist" },
				{ "<leader>sd", desc = "Search diagnostics" },
				{ "]d", desc = "Next diagnostic" },
				{ "[d", desc = "Previous diagnostic" },
				{ "]e", desc = "Next error" },
				{ "[e", desc = "Previous error" },
			},
		},
		keys = {
			{
				"<leader>?",
				function()
					require("which-key").show({ global = false })
				end,
				desc = "Buffer keymaps",
			},
		},
	},
	{
		"folke/todo-comments.nvim",
		event = { "BufReadPost", "BufNewFile" },
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = {},
		keys = {
			{ "<leader>st", "<cmd>TodoTelescope<cr>", desc = "Search todos" },
			{
				"]t",
				function()
					require("todo-comments").jump_next()
				end,
				desc = "Next todo",
			},
			{
				"[t",
				function()
					require("todo-comments").jump_prev()
				end,
				desc = "Previous todo",
			},
		},
	},
	{
		"lewis6991/gitsigns.nvim",
		event = { "BufReadPre", "BufNewFile" },
		opts = {},
	},
}
