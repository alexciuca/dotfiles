return {
	{
		"nvim-telescope/telescope.nvim",
		branch = "0.1.x",
		cmd = "Telescope",
		dependencies = {
			"nvim-lua/plenary.nvim",
			{
				"nvim-telescope/telescope-fzf-native.nvim",
				build = "make",
				cond = function()
					return vim.fn.executable("make") == 1
				end,
			},
		},
		keys = {
			{ "<leader>sf", function() require("telescope.builtin").find_files() end, desc = "Files" },
			{ "<leader>sg", function() require("telescope.builtin").live_grep() end, desc = "Grep" },
			{ "<leader>sb", function() require("telescope.builtin").buffers() end, desc = "Buffers" },
			{ "<leader>sh", function() require("telescope.builtin").help_tags() end, desc = "Help" },
			{ "<leader>sd", function() require("telescope.builtin").diagnostics() end, desc = "Diagnostics" },
			{ "<leader>sn", function()
				require("telescope.builtin").find_files({ cwd = vim.fn.stdpath("config") })
			end, desc = "Nvim config" },
		},
		config = function()
			local telescope = require("telescope")
			telescope.setup({})
			pcall(telescope.load_extension, "fzf")
		end,
	},
	{
		"stevearc/oil.nvim",
		dependencies = { "echasnovski/mini.icons" },
		lazy = false,
		opts = {
			view_options = { show_hidden = true },
			win_options = { signcolumn = "yes" },
		},
		keys = {
			{ "-", "<cmd>Oil<cr>", desc = "Open parent directory" },
			{ "<leader>o", function() require("oil").open(vim.fn.getcwd()) end, desc = "Open project root" },
		},
	},
}
