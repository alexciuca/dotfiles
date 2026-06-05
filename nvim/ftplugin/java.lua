local ok, jdtls = pcall(require, "jdtls")
if not ok then
	return
end

local home = vim.env.HOME
local mason = vim.fs.joinpath(vim.fn.stdpath("data"), "mason", "packages")

local jdtls_path = vim.fs.joinpath(mason, "jdtls")
local launcher = vim.fn.glob(jdtls_path .. "/plugins/org.eclipse.equinox.launcher_*.jar")
if launcher == "" then
	vim.notify("jdtls launcher jar not found — :MasonInstall jdtls", vim.log.levels.WARN)
	return
end

local os_config = "config_linux"
if vim.fn.has("mac") == 1 then
	os_config = "config_mac"
elseif vim.fn.has("win32") == 1 then
	os_config = "config_win"
end

local root_markers = { "gradlew", "mvnw", ".git", "pom.xml", "build.gradle", "build.gradle.kts", "settings.gradle" }
local root_dir = vim.fs.dirname(vim.fs.find(root_markers, { upward = true })[1]) or vim.fn.getcwd()
local project_name = vim.fn.fnamemodify(root_dir, ":p:h:t")
local workspace_dir = vim.fs.joinpath(home, ".local", "share", "jdtls-workspace", project_name)

local bundles = {}
local jdebug = vim.split(
	vim.fn.glob(mason .. "/java-debug-adapter/extension/server/com.microsoft.java.debug.plugin-*.jar"),
	"\n"
)
vim.list_extend(bundles, jdebug)
vim.list_extend(bundles, vim.split(vim.fn.glob(mason .. "/java-test/extension/server/*.jar"), "\n"))

local sb_ok, sb = pcall(require, "spring_boot")
if sb_ok and sb.java_extensions then
	vim.list_extend(bundles, sb.java_extensions())
end

local caps_ok, cmp_caps = pcall(require, "cmp_nvim_lsp")
local capabilities = caps_ok and cmp_caps.default_capabilities() or vim.lsp.protocol.make_client_capabilities()

local config = {
	cmd = {
		"java",
		"-Declipse.application=org.eclipse.jdt.ls.core.id1",
		"-Dosgi.bundles.defaultStartLevel=4",
		"-Declipse.product=org.eclipse.jdt.ls.core.product",
		"-Dlog.protocol=true",
		"-Dlog.level=ALL",
		"-Xms1g",
		"-Xmx2g",
		"--add-modules=ALL-SYSTEM",
		"--add-opens",
		"java.base/java.util=ALL-UNNAMED",
		"--add-opens",
		"java.base/java.lang=ALL-UNNAMED",
		"-jar",
		launcher,
		"-configuration",
		vim.fs.joinpath(jdtls_path, os_config),
		"-data",
		workspace_dir,
	},
	root_dir = root_dir,
	capabilities = capabilities,
	init_options = { bundles = bundles },
	settings = {
		java = {
			signatureHelp = { enabled = true },
			contentProvider = { preferred = "fernflower" },
			completion = {
				favoriteStaticMembers = {
					"org.junit.jupiter.api.Assertions.*",
					"org.mockito.Mockito.*",
					"org.assertj.core.api.Assertions.*",
				},
				importOrder = { "java", "javax", "com", "org" },
			},
			sources = {
				organizeImports = { starThreshold = 9999, staticStarThreshold = 9999 },
			},
			references = { includeDecompiledSources = true },
			inlayHints = { parameterNames = { enabled = "all" } },
			eclipse = { downloadSources = true },
			maven = { downloadSources = true },
			configuration = { updateBuildConfiguration = "interactive" },
		},
	},
}

jdtls.start_or_attach(config)

local map = function(lhs, rhs, desc)
	vim.keymap.set("n", lhs, rhs, { buffer = 0, desc = desc })
end

map("<leader>jo", function() jdtls.organize_imports() end, "Java: organize imports")
map("<leader>jv", function() jdtls.extract_variable() end, "Java: extract variable")
map("<leader>jc", function() jdtls.extract_constant() end, "Java: extract constant")
map("<leader>jt", function() jdtls.test_class() end, "Java: test class")
map("<leader>jn", function() jdtls.test_nearest_method() end, "Java: test nearest")
vim.keymap.set("v", "<leader>jm", [[<Esc><Cmd>lua require("jdtls").extract_method(true)<CR>]],
	{ buffer = 0, desc = "Java: extract method" })
