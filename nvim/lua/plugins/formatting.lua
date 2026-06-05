return {
	{
		"stevearc/conform.nvim",
		event = { "BufWritePre" },
		cmd = { "ConformInfo" },
		opts = {
			formatters_by_ft = {
				lua = { "stylua" },
				python = function()
					if vim.fn.executable("ruff") == 1 then
						return { "ruff_organize_imports", "ruff_format" }
					end
					return {}
				end,
				javascript = { "prettier" },
				typescript = { "prettier" },
				javascriptreact = { "prettier" },
				typescriptreact = { "prettier" },
				json = { "prettier" },
				yaml = { "prettier" },
				html = { "prettier" },
				css = { "prettier" },
				markdown = { "prettier" },
				cs = { "csharpier" },
				c = { "clang-format" },
				cpp = { "clang-format" },
				go = { "goimports", "gofumpt" },
			},
			formatters = {
				csharpier = {
					command = "csharpier",
					args = { "format", "--write-stdout" },
					to_stdin = true,
				},
			},
			format_on_save = false,
		},
	},
	{
		"mfussenegger/nvim-lint",
		event = { "BufReadPost", "BufNewFile" },
		config = function()
			local lint = require("lint")
			lint.linters_by_ft = {
				python = { "ruff" },
				go = { "golangcilint" },
			}

			vim.api.nvim_create_autocmd({ "BufWritePost", "InsertLeave" }, {
				callback = function()
					if lint.linters_by_ft[vim.bo.filetype] then
						lint.try_lint()
					end
				end,
			})
		end,
	},
}
