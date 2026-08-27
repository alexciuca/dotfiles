return {
	{
		"seblyng/roslyn.nvim",
		ft = { "cs", "razor" },
		-- Pinned: commits after this call vim.fs.ext(), which does not exist in
		-- the nvim 0.12-dev build at ~/tools/nvim-macos-arm64 (Feb 2026). Newer
		-- roslyn.nvim errors out in sln/discovery.lua and no client attaches.
		-- Drop this pin once nvim is updated.
		commit = "2dcbbe81b48f8377df2281d9be4f2c84ccfff520",
		config = function()
			-- Server settings go through vim.lsp.config now; the plugin finds the
			-- Mason roslyn binary and the bundled Razor extension on its own.
			vim.lsp.config("roslyn", {
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
			})

			require("roslyn").setup({})
		end,
	},
}
