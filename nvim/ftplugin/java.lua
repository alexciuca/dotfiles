local jdtls = require("jdtls")

local home = os.getenv("HOME")
local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")

local workspace_dir = home .. "/.local/share/jdtls-workspace/" .. project_name

local root_markers = { ".git", "mvnw", "gradlew", "pom.xml", "build.gradle" }
local root_dir = require("jdtls.setup").find_root(root_markers)

if root_dir == nil then
	return
end

local config = {
	cmd = { "jdtls" },

	root_dir = root_dir,
	workspace_folder = workspace_dir,

	settings = {
		java = {
			configuration = {
				runtimes = {
					{
						name = "JavaSE-21",
						path = vim.fn.expand("$JAVA_HOME"),
					},
				},
			},
		},
	},

	init_options = {
		bundles = {},
	},
}

jdtls.start_or_attach(config)
