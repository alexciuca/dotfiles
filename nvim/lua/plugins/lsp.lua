return {
	{
		"williamboman/mason.nvim",
		cmd = { "Mason", "MasonInstall", "MasonUninstall", "MasonUpdate", "MasonLog" },
		opts = {},
	},
	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		dependencies = { "williamboman/mason.nvim" },
		event = "VeryLazy",
		opts = {
			ensure_installed = {
				-- Lua            (lua-language-server comes from brew)
				"stylua",
				-- Python
				"basedpyright",
				"ruff",
				"debugpy",
				-- C# / Razor
				"roslyn-language-server",
				"csharpier",
				"netcoredbg",
				-- C / C++        (clangd + clang-format come from brew llvm)
				"codelldb",
				-- Go             (gopls comes from brew)
				"delve",
				"gofumpt",
				"goimports",
				"golangci-lint",
				-- Web            (tailwindcss-language-server comes from brew)
				"vtsls",
				"eslint-lsp",
				"emmet-language-server",
				"prettier",
				-- Markup / data
				"html-lsp",
				"css-lsp",
				"json-lsp",
				"yaml-language-server",
				-- CMake
				"cmake-language-server",
			},
			auto_update = false,
			run_on_start = true,
		},
	},
	{
		"folke/lazydev.nvim",
		ft = "lua",
		opts = {
			library = {
				{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
			},
		},
	},
	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			local function enable(server, config)
				vim.lsp.config(server, config or {})
				vim.lsp.enable(server)
			end

			enable("lua_ls", {
				settings = {
					Lua = {
						workspace = { checkThirdParty = false },
						telemetry = { enable = false },
					},
				},
			})

			enable("basedpyright", {
				settings = {
					basedpyright = {
						analysis = {
							autoSearchPaths = true,
							useLibraryCodeForTypes = true,
							typeCheckingMode = "basic",
						},
					},
				},
			})

			enable("vtsls", {
				settings = {
					typescript = {
						inlayHints = {
							parameterNames = { enabled = "literals" },
							variableTypes = { enabled = true },
							propertyDeclarationTypes = { enabled = true },
						},
					},
				},
			})

			enable("eslint", {})
			enable("tailwindcss", {})
			enable("emmet_language_server", {})

			enable("clangd", {
				cmd = {
					"clangd",
					"--background-index",
					"--clang-tidy",
					"--completion-style=detailed",
					"--header-insertion=iwyu",
					"--function-arg-placeholders=true",
					"--fallback-style=llvm",
				},
				init_options = {
					fallbackFlags = { "-std=c++23" },
				},
			})

			enable("cmake", {})

			enable("gopls", {
				settings = {
					gopls = {
						gofumpt = true,
						completeUnimported = true,
						usePlaceholders = true,
						staticcheck = true,
						hints = {
							assignVariableTypes = true,
							compositeLiteralFields = true,
							constantValues = true,
							functionTypeParameters = true,
							parameterNames = true,
							rangeVariableTypes = true,
						},
						analyses = {
							unusedparams = true,
							shadow = true,
							nilness = true,
						},
					},
				},
			})

			for _, s in ipairs({ "html", "cssls", "jsonls", "yamlls" }) do
				enable(s, {})
			end
		end,
	},
}
