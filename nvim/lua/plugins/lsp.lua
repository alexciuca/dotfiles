return {
	{
		"williamboman/mason.nvim",
		cmd = { "Mason", "MasonInstall", "MasonUpdate" },
		opts = {
			registries = {
				"github:mason-org/mason-registry",
				"github:Crashdummyy/mason-registry",
			},
		},
	},
	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		dependencies = { "williamboman/mason.nvim" },
		event = "VeryLazy",
		opts = {
			ensure_installed = {
				-- Lua
				"lua-language-server",
				"stylua",
				-- Python
				"basedpyright",
				"ruff",
				"debugpy",
				-- JS / TS / React
				"vtsls",
				"eslint-lsp",
				"tailwindcss-language-server",
				"emmet-language-server",
				"prettier",
				-- Web
				"html-lsp",
				"css-lsp",
				"json-lsp",
				"yaml-language-server",
				-- Java + Spring Boot
				"jdtls",
				"java-debug-adapter",
				"java-test",
				"spring-boot-tools",
				-- C# / Razor
				"roslyn",
				"rzls",
				"csharpier",
				"netcoredbg",
				-- C / C++
				"clangd",
				"clang-format",
				"codelldb",
				"cmake-language-server",
				-- Go
				"gopls",
				"gofumpt",
				"goimports",
				"golangci-lint",
				"delve",
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
		dependencies = { "hrsh7th/cmp-nvim-lsp" },
		config = function()
			local capabilities = require("cmp_nvim_lsp").default_capabilities()

			local function enable(server, config)
				vim.lsp.config(server, vim.tbl_deep_extend("force", { capabilities = capabilities }, config or {}))
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
					"--function-arg-placeholders",
					"--fallback-style=llvm",
				},
				init_options = {
					fallbackFlags = { "-std=c++20" },
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
