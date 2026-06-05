return {
	{
		"mfussenegger/nvim-jdtls",
		ft = { "java" },
	},
	{
		"JavaHello/spring-boot.nvim",
		ft = { "java", "yaml", "jproperties" },
		dependencies = { "mfussenegger/nvim-jdtls" },
		opts = {},
	},
}
