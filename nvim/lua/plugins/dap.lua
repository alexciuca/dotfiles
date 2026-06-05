return {
	{
		"mfussenegger/nvim-dap",
		dependencies = {
			"rcarriga/nvim-dap-ui",
			"nvim-neotest/nvim-nio",
			"mfussenegger/nvim-dap-python",
			"leoluz/nvim-dap-go",
			"theHamsta/nvim-dap-virtual-text",
		},
		keys = {
			{ "<F5>", function() require("dap").continue() end, desc = "Debug continue" },
			{ "<F9>", function() require("dap").toggle_breakpoint() end, desc = "Toggle breakpoint" },
			{ "<F10>", function() require("dap").step_over() end, desc = "Step over" },
			{ "<F11>", function() require("dap").step_into() end, desc = "Step into" },
			{ "<F12>", function() require("dap").step_out() end, desc = "Step out" },
			{ "<leader>dr", function() require("dap").repl.open() end, desc = "REPL" },
			{ "<leader>dl", function() require("dap").run_last() end, desc = "Run last" },
			{ "<leader>du", function() require("dapui").toggle() end, desc = "Toggle UI" },
		},
		config = function()
			local dap = require("dap")
			local dapui = require("dapui")
			dapui.setup()
			require("nvim-dap-virtual-text").setup({})

			local mason_bin = vim.fs.joinpath(vim.fn.stdpath("data"), "mason", "bin")
			local debugpy = vim.fs.joinpath(
				vim.fn.stdpath("data"),
				"mason",
				"packages",
				"debugpy",
				"venv",
				"bin",
				"python"
			)
			require("dap-python").setup(vim.fn.executable(debugpy) == 1 and debugpy or "python3")
			require("dap-go").setup()

			local codelldb = vim.fs.joinpath(mason_bin, "codelldb")
			if vim.fn.executable(codelldb) == 1 then
				dap.adapters.codelldb = {
					type = "server",
					port = "${port}",
					executable = {
						command = codelldb,
						args = { "--port", "${port}" },
					},
				}
				local cpp_cfg = {
					{
						type = "codelldb",
						request = "launch",
						name = "Launch executable",
						program = function()
							return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
						end,
						cwd = "${workspaceFolder}",
						stopOnEntry = false,
					},
				}
				dap.configurations.c = cpp_cfg
				dap.configurations.cpp = cpp_cfg
				dap.configurations.rust = cpp_cfg
			end

			local netcoredbg = vim.fn.exepath("netcoredbg")
			if netcoredbg == "" then
				local m = vim.fs.joinpath(mason_bin, "netcoredbg")
				if vim.fn.executable(m) == 1 then
					netcoredbg = m
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

			dap.listeners.after.event_initialized["dapui_config"] = function() dapui.open() end
			dap.listeners.before.event_terminated["dapui_config"] = function() dapui.close() end
			dap.listeners.before.event_exited["dapui_config"] = function() dapui.close() end
		end,
	},
}
