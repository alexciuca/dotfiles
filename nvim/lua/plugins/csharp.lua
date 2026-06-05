return {
	{
		"seblyng/roslyn.nvim",
		ft = { "cs", "razor" },
		dependencies = {
			{ "tris203/rzls.nvim", config = true },
		},
		config = function()
			local rzls_path = vim.fn.expand("$MASON/packages/rzls/libexec")
			local log_path = (vim.lsp.log and vim.lsp.log.get_filename) and vim.lsp.log.get_filename() or nil
			local log_dir = log_path and vim.fs.dirname(log_path) or vim.fn.stdpath("state")

			require("roslyn").setup({
				config = {
					cmd = {
						"roslyn",
						"--stdio",
						"--logLevel=Information",
						"--extensionLogDirectory=" .. log_dir,
						"--razorSourceGenerator=" .. vim.fs.joinpath(rzls_path, "Microsoft.CodeAnalysis.Razor.Compiler.dll"),
						"--razorDesignTimePath=" .. vim.fs.joinpath(
							rzls_path,
							"Targets",
							"Microsoft.NET.Sdk.Razor.DesignTime.targets"
						),
						"--extension",
						vim.fs.joinpath(rzls_path, "RazorExtension", "Microsoft.VisualStudioCode.RazorExtension.dll"),
					},
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
						},
						["csharp|code_lens"] = {
							dotnet_enable_references_code_lens = false,
						},
					},
				},
			})
		end,
	},
}
