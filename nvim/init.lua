vim.g.mapleader = " "
vim.g.maplocalleader = " "

local function path_join(...)
	return table.concat({ ... }, "/")
end

local function file_exists(path)
	return vim.uv.fs_stat(path) ~= nil
end

local function add_mason_bin_to_path()
	local mason_bin = path_join(vim.fn.stdpath("data"), "mason", "bin")
	local current_path = vim.env.PATH or ""
	if not current_path:find(mason_bin, 1, true) then
		vim.env.PATH = mason_bin .. ":" .. current_path
	end
end

local function lsp_setup(server, config)
	if vim.lsp.config and vim.lsp.enable then
		vim.lsp.config(server, config or {})
		vim.lsp.enable(server)
		return
	end

	local ok, lspconfig = pcall(require, "lspconfig")
	if ok and lspconfig[server] then
		lspconfig[server].setup(config or {})
	end
end

add_mason_bin_to_path()

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.signcolumn = "yes"
vim.opt.clipboard = "unnamedplus"
vim.opt.cursorline = true
vim.opt.wrap = false
vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.smartindent = true
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.termguicolors = true
vim.opt.undofile = true
vim.opt.undodir = path_join(vim.env.HOME or "~", ".vim", "undodir")

vim.api.nvim_create_autocmd("FileType", {
	pattern = "*",
	callback = function()
		vim.opt_local.formatoptions:remove({ "c", "r", "o" })
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = { "javascript", "typescript", "javascriptreact", "typescriptreact", "json", "yaml" },
	callback = function()
		vim.opt_local.tabstop = 2
		vim.opt_local.softtabstop = 2
		vim.opt_local.shiftwidth = 2
	end,
})

vim.filetype.add({
	extension = {
		razor = "razor",
		cshtml = "razor",
	},
})

vim.keymap.set("n", "<Esc>", "<cmd>noh<cr>")
vim.keymap.set("n", ";", ":", { desc = "Command mode" })
vim.keymap.set("i", "jk", "<Esc>")

local lazypath = path_join(vim.fn.stdpath("data"), "lazy", "lazy.nvim")
if not file_exists(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	{
		"loctvl842/monokai-pro.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			require("monokai-pro").setup({
				filter = "classic", -- "classic", "octagon", "pro", "machine", "ristretto", "spectrum"
			})
			vim.cmd.colorscheme("monokai-pro")
		end,
	},
	{
		"williamboman/mason.nvim",
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
		opts = {
			ensure_installed = {
				"lua-language-server",
				"stylua",
				"basedpyright",
				"ruff",
				"black",
				"isort",
				"debugpy",
				"typescript-language-server",
				"eslint-lsp",
				"prettier",
				"eslint_d",
				"html-lsp",
				"css-lsp",
				"json-lsp",
				"yaml-language-server",
				"gopls",
				"goimports",
				"golangci-lint",
				"delve",
				"roslyn",
				"rzls",
				"csharpier",
				"js-debug-adapter",
			},
			auto_update = false,
			run_on_start = true,
		},
	},
	{
		"williamboman/mason-lspconfig.nvim",
		dependencies = { "williamboman/mason.nvim" },
		opts = {
			ensure_installed = { "basedpyright", "ts_ls", "eslint", "gopls", "html", "cssls", "jsonls", "yamlls" },
			automatic_installation = true,
		},
	},
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"williamboman/mason-lspconfig.nvim",
		},
		config = function()
			local capabilities = require("cmp_nvim_lsp").default_capabilities()

			lsp_setup("basedpyright", {
				capabilities = capabilities,
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

			lsp_setup("gopls", {
				capabilities = capabilities,
				settings = {
					gopls = {
						semanticTokens = true,
						gofumpt = true,
						staticcheck = true,
						usePlaceholders = true,
						completeUnimported = true,
						analyses = {
							nilness = true,
							shadow = true,
							unusedparams = true,
							unusedwrite = true,
						},
						codelenses = {
							gc_details = true,
							generate = true,
							test = true,
							tidy = true,
							upgrade_dependency = true,
							vendor = true,
						},
					},
				},
			})

			local simple_servers = { "ts_ls", "eslint", "html", "cssls", "jsonls", "yamlls" }
			for _, server in ipairs(simple_servers) do
				lsp_setup(server, { capabilities = capabilities })
			end

			vim.diagnostic.config({
				underline = false,
				virtual_text = { spacing = 2, prefix = "●" },
				update_in_insert = false,
				severity_sort = true,
			})
		end,
	},
	{
		"seblyng/roslyn.nvim",
		dependencies = {
			"neovim/nvim-lspconfig",
			{ "tris203/rzls.nvim", config = true },
		},
		ft = { "cs", "razor" },
		config = function()
			local rzls_path = vim.fn.expand("$MASON/packages/rzls/libexec")
			local log_path = (vim.lsp.log and vim.lsp.log.get_filename) and vim.lsp.log.get_filename() or nil
			local log_dir = log_path and vim.fs.dirname(log_path) or vim.fn.stdpath("state")

			local roslyn_cmd = {
				"roslyn",
				"--stdio",
				"--logLevel=Information",
				"--extensionLogDirectory=" .. log_dir,
				"--razorSourceGenerator=" .. vim.fs.joinpath(rzls_path, "Microsoft.CodeAnalysis.Razor.Compiler.dll"),
				"--razorDesignTimePath="
					.. vim.fs.joinpath(rzls_path, "Targets", "Microsoft.NET.Sdk.Razor.DesignTime.targets"),
				"--extension",
				vim.fs.joinpath(rzls_path, "RazorExtension", "Microsoft.VisualStudioCode.RazorExtension.dll"),
			}

			lsp_setup("roslyn", {
				cmd = roslyn_cmd,
				handlers = require("rzls.roslyn_handlers"),
				settings = {
					["csharp|inlay_hints"] = {
						csharp_enable_inlay_hints_for_implicit_object_creation = true,
						csharp_enable_inlay_hints_for_implicit_variable_types = true,
						csharp_enable_inlay_hints_for_lambda_parameter_types = true,
						csharp_enable_inlay_hints_for_types = true,
						dotnet_enable_inlay_hints_for_indexer_parameters = true,
						dotnet_enable_inlay_hints_for_literal_parameters = true,
						dotnet_enable_inlay_hints_for_object_creation_parameters = true,
						dotnet_enable_inlay_hints_for_other_parameters = true,
						dotnet_enable_inlay_hints_for_parameters = true,
						dotnet_suppress_inlay_hints_for_parameters_that_differ_only_by_suffix = true,
						dotnet_suppress_inlay_hints_for_parameters_that_match_argument_name = true,
						dotnet_suppress_inlay_hints_for_parameters_that_match_method_intent = true,
					},
					["csharp|code_lens"] = {
						dotnet_enable_references_code_lens = false,
					},
				},
			})
		end,
	},
	{
		"stevearc/conform.nvim",
		opts = {
			formatters_by_ft = {
				lua = { "stylua" },
				python = function()
					if vim.fn.executable("ruff") == 1 then
						return { "ruff_organize_imports", "ruff_format" }
					end
					return { "isort", "black" }
				end,
				javascript = { "prettier" },
				javascriptreact = { "prettier" },
				typescript = { "prettier" },
				typescriptreact = { "prettier" },
				json = { "prettier" },
				yaml = { "prettier" },
				html = { "prettier" },
				css = { "prettier" },
				cs = { "csharpier" },
				go = { "goimports", "gofumpt" },
			},
			formatters = {
				csharpier = {
					command = "csharpier",
					args = { "format", "--write-stdout" },
					to_stdin = true,
				},
			},
			format_on_save = {
				timeout_ms = 1500,
				lsp_fallback = true,
			},
		},
	},
	{
		"mfussenegger/nvim-lint",
		config = function()
			local lint = require("lint")
			lint.linters_by_ft = {
				python = { "ruff" },
				go = { "golangcilint" },
				javascript = { "eslint_d" },
				javascriptreact = { "eslint_d" },
				typescript = { "eslint_d" },
				typescriptreact = { "eslint_d" },
			}

			local mason_bin = path_join(vim.fn.stdpath("data"), "mason", "bin")
			local golangci = path_join(mason_bin, "golangci-lint")
			if vim.fn.executable(golangci) == 1 and lint.linters.golangcilint then
				lint.linters.golangcilint.cmd = golangci
			end

			vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
				callback = function()
					lint.try_lint()
				end,
			})
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		opts = {
			ensure_installed = {
				"lua",
				"vim",
				"vimdoc",
				"python",
				"go",
				"gomod",
				"javascript",
				"typescript",
				"tsx",
				"json",
				"yaml",
				"html",
				"css",
				"c_sharp",
				"java",
			},
			auto_install = true,
			highlight = { enable = true },
			indent = { enable = true },
		},
		config = function(_, opts)
			require("nvim-treesitter.configs").setup(opts)
		end,
	},
	{
		"L3MON4D3/LuaSnip",
		dependencies = { "rafamadriz/friendly-snippets" },
		config = function()
			require("luasnip.loaders.from_vscode").lazy_load()
		end,
	},
	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-buffer",
			"saadparwaiz1/cmp_luasnip",
			"L3MON4D3/LuaSnip",
		},
		config = function()
			local cmp = require("cmp")
			local luasnip = require("luasnip")

			cmp.setup({
				snippet = {
					expand = function(args)
						luasnip.lsp_expand(args.body)
					end,
				},
				mapping = cmp.mapping.preset.insert({
					["<C-Space>"] = cmp.mapping.complete(),
					["<CR>"] = cmp.mapping.confirm({ select = true }),
					["<Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_next_item()
						elseif luasnip.expand_or_jumpable() then
							luasnip.expand_or_jump()
						else
							fallback()
						end
					end, { "i", "s" }),
					["<S-Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_prev_item()
						elseif luasnip.jumpable(-1) then
							luasnip.jump(-1)
						else
							fallback()
						end
					end, { "i", "s" }),
				}),
				sources = cmp.config.sources({
					{ name = "nvim_lsp" },
					{ name = "luasnip" },
					{ name = "path" },
				}, {
					{ name = "buffer" },
				}),
			})
		end,
	},
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		dependencies = { "hrsh7th/nvim-cmp" },
		config = function()
			require("nvim-autopairs").setup({})
			local cmp_ok, cmp = pcall(require, "cmp")
			if cmp_ok then
				local cmp_autopairs = require("nvim-autopairs.completion.cmp")
				cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
			end
		end,
	},
	{ "tpope/vim-surround" },
	{
		"lewis6991/gitsigns.nvim",
		opts = {},
	},
	{
		"nvim-telescope/telescope.nvim",
		branch = "0.1.x",
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
		config = function()
			local telescope = require("telescope")
			local builtin = require("telescope.builtin")
			telescope.setup({})
			pcall(telescope.load_extension, "fzf")

			vim.keymap.set("n", "<leader>sf", builtin.find_files, { desc = "Search files" })
			vim.keymap.set("n", "<leader>sg", builtin.live_grep, { desc = "Search grep" })
			vim.keymap.set("n", "<leader>sh", builtin.help_tags, { desc = "Search help" })
			vim.keymap.set("n", "<leader>sn", function()
				builtin.find_files({ cwd = vim.fn.stdpath("config") })
			end, { desc = "Search nvim config" })
		end,
	},
	{
		"stevearc/oil.nvim",
		dependencies = { "echasnovski/mini.icons" },
		opts = {
			view_options = { show_hidden = true },
			win_options = { signcolumn = "yes" },
		},
		config = function(_, opts)
			require("oil").setup(opts)
			vim.keymap.set("n", "-", "<cmd>Oil<cr>", { desc = "Open parent directory" })
			vim.keymap.set("n", "<leader>o", function()
				require("oil").open(vim.fn.getcwd())
			end, { desc = "Open project root in oil" })
		end,
	},
	{ "nvim-neotest/nvim-nio" },
	{
		"mfussenegger/nvim-dap",
		dependencies = {
			"rcarriga/nvim-dap-ui",
			"nvim-neotest/nvim-nio",
			"leoluz/nvim-dap-go",
			"mfussenegger/nvim-dap-python",
		},
		config = function()
			local dap = require("dap")
			local dapui = require("dapui")

			local mason_bin = path_join(vim.fn.stdpath("data"), "mason", "bin")
			local debugpy = path_join(vim.fn.stdpath("data"), "mason", "packages", "debugpy", "venv", "bin", "python")
			local js_debug = path_join(mason_bin, "js-debug-adapter")
			local delve = path_join(mason_bin, "dlv")
			local netcoredbg = vim.fn.exepath("netcoredbg")
			if netcoredbg == "" then
				local mason_netcoredbg = path_join(mason_bin, "netcoredbg")
				if vim.fn.executable(mason_netcoredbg) == 1 then
					netcoredbg = mason_netcoredbg
				end
			end

			if netcoredbg ~= "" then
				dap.adapters.coreclr = {
					type = "executable",
					command = netcoredbg,
					args = { "--interpreter=vscode" },
				}

				dap.configurations.cs = {
					{
						type = "coreclr",
						name = "Launch .NET dll",
						request = "launch",
						program = function()
							return vim.fn.input("Path to dll: ", vim.fn.getcwd() .. "/bin/Debug/", "file")
						end,
					},
				}
			end

			require("dap-python").setup(vim.fn.executable(debugpy) == 1 and debugpy or "python3")

			require("dap-go").setup({
				delve = {
					path = vim.fn.executable(delve) == 1 and delve or "dlv",
				},
			})

			if vim.fn.executable(js_debug) == 1 then
				dap.adapters["pwa-node"] = {
					type = "server",
					host = "127.0.0.1",
					port = "${port}",
					executable = {
						command = js_debug,
						args = { "${port}" },
					},
				}

				local js_config = {
					{
						type = "pwa-node",
						request = "launch",
						name = "Launch current file",
						program = "${file}",
						cwd = "${workspaceFolder}",
					},
					{
						type = "pwa-node",
						request = "attach",
						name = "Attach to process",
						processId = require("dap.utils").pick_process,
						cwd = "${workspaceFolder}",
					},
				}

				dap.configurations.javascript = js_config
				dap.configurations.typescript = js_config
				dap.configurations.javascriptreact = js_config
				dap.configurations.typescriptreact = js_config
			end

			dapui.setup()
			dap.listeners.after.event_initialized["dapui_config"] = function()
				dapui.open()
			end
			dap.listeners.before.event_terminated["dapui_config"] = function()
				dapui.close()
			end
			dap.listeners.before.event_exited["dapui_config"] = function()
				dapui.close()
			end

			vim.keymap.set("n", "<F5>", dap.continue, { desc = "Debug continue" })
			vim.keymap.set("n", "<F9>", dap.toggle_breakpoint, { desc = "Toggle breakpoint" })
			vim.keymap.set("n", "<F10>", dap.step_over, { desc = "Debug step over" })
			vim.keymap.set("n", "<F11>", dap.step_into, { desc = "Debug step into" })
			vim.keymap.set("n", "<F8>", dap.step_out, { desc = "Debug step out" })
			vim.keymap.set("n", "<leader>dr", dap.repl.open, { desc = "Open debug REPL" })
			vim.keymap.set("n", "<leader>dl", dap.run_last, { desc = "Run last debug session" })
		end,
	},
	{
		"nvim-neotest/neotest",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-neotest/nvim-nio",
			"nvim-treesitter/nvim-treesitter",
			"Issafalcon/neotest-dotnet",
			"nvim-neotest/neotest-python",
			"haydenmeade/neotest-jest",
		},
		config = function()
			local neotest = require("neotest")
			neotest.setup({
				adapters = {
					require("neotest-dotnet")({}),
					require("neotest-python")({ runner = "pytest" }),
					require("neotest-jest")({}),
				},
			})

			vim.keymap.set("n", "<leader>tt", function()
				neotest.run.run()
			end, { desc = "Test nearest" })
			vim.keymap.set("n", "<leader>tf", function()
				neotest.run.run(vim.fn.expand("%"))
			end, { desc = "Test file" })
			vim.keymap.set("n", "<leader>td", function()
				neotest.run.run({ strategy = "dap" })
			end, { desc = "Debug nearest test" })
			vim.keymap.set("n", "<leader>ts", neotest.summary.toggle, { desc = "Toggle test summary" })
			vim.keymap.set("n", "<leader>to", function()
				neotest.output.open({ enter = true })
			end, { desc = "Open test output" })
		end,
	},
	{
		"mfussenegger/nvim-jdtls",
		ft = { "java" },
	},
}, {
	checker = { enabled = false },
	change_detection = { notify = false },
})

vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(event)
		local map = function(keys, func, desc, mode)
			vim.keymap.set(mode or "n", keys, func, { buffer = event.buf, desc = desc })
		end
		map("K", vim.lsp.buf.hover, "LSP hover")
		map("gd", vim.lsp.buf.definition, "Go to definition")
		map("gD", vim.lsp.buf.declaration, "Go to declaration")
		map("gi", vim.lsp.buf.implementation, "Go to implementation")
		map("gr", vim.lsp.buf.references, "Find references")
		map("<leader>rn", vim.lsp.buf.rename, "Rename symbol")
		map("<leader>ca", vim.lsp.buf.code_action, "Code action", { "n", "v" })
		map("<leader>f", function()
			require("conform").format({ async = true, lsp_fallback = true })
		end, "Format buffer")
	end,
})

vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, { desc = "Line diagnostics" })
vim.keymap.set("n", "]d", function()
	vim.diagnostic.jump({ count = 1, float = true })
end, { desc = "Next diagnostic" })
vim.keymap.set("n", "[d", function()
	vim.diagnostic.jump({ count = -1, float = true })
end, { desc = "Previous diagnostic" })

if vim.fn.exists(":LspInfo") == 0 then
	vim.api.nvim_create_user_command("LspInfo", function()
		vim.cmd("checkhealth vim.lsp")
	end, { desc = "Alias to :checkhealth vim.lsp" })
end
