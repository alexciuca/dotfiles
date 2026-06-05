return {
	{
		"nvim-neotest/neotest",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-neotest/nvim-nio",
			"nvim-treesitter/nvim-treesitter",
			"mfussenegger/nvim-jdtls",
			"rcasia/neotest-java",
			"Issafalcon/neotest-dotnet",
			"nvim-neotest/neotest-python",
			"fredrikaverpil/neotest-golang",
		},
		keys = {
			{ "<leader>tt", function() require("neotest").run.run() end, desc = "Test nearest" },
			{ "<leader>tf", function() require("neotest").run.run(vim.fn.expand("%")) end, desc = "Test file" },
			{ "<leader>td", function() require("neotest").run.run({ strategy = "dap" }) end, desc = "Debug test" },
			{ "<leader>ts", function() require("neotest").summary.toggle() end, desc = "Toggle summary" },
			{ "<leader>to", function() require("neotest").output.open({ enter = true }) end, desc = "Open output" },
		},
		config = function()
			require("neotest").setup({
				adapters = {
					require("neotest-java")({}),
					require("neotest-dotnet")({}),
					require("neotest-python")({ runner = "pytest" }),
					require("neotest-golang")({ dap_go_enabled = true }),
				},
			})
		end,
	},
}
