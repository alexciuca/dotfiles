return {
	{
		"scalameta/nvim-metals",
		dependencies = { "nvim-lua/plenary.nvim" },
		ft = { "scala", "sbt" },
		config = function()
			local metals = require("metals")
			local metals_config = metals.bare_config()
			metals_config.settings = {
				showImplicitArguments = true,
				excludedPackages = { "akka.actor.typed.javadsl", "com.github.swagger.akka.javadsl" },
			}
			local caps_ok, cmp_caps = pcall(require, "cmp_nvim_lsp")
			metals_config.capabilities = caps_ok and cmp_caps.default_capabilities()
				or vim.lsp.protocol.make_client_capabilities()

			vim.api.nvim_create_autocmd("FileType", {
				pattern = { "scala", "sbt" },
				callback = function()
					metals.initialize_or_attach(metals_config)
				end,
			})
		end,
	},
}
