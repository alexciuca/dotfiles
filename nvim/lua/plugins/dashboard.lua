return {
	{
		"goolord/alpha-nvim",
		event = "VimEnter",
		dependencies = { "echasnovski/mini.icons" },
		config = function()
			local alpha = require("alpha")
			local dashboard = require("alpha.themes.dashboard")

			dashboard.section.header.val = {
				[[                                                   ]],
				[[                                              ___  ]],
				[[                                           ,o88888 ]],
				[[                                        ,o8888888' ]],
				[[                  ,:o:o:oooo.        ,8O88Pd8888"  ]],
				[[              ,.::.::o:ooooOoOoO. ,oO8O8Pd888'"    ]],
				[[            ,.:.::o:ooOoOoOO8O8OOo.8OOPd8O8O"      ]],
				[[           , ..:.::o:ooOoOOOO8OOOOo.FdO8O8"        ]],
				[[          , ..:.::o:ooOoOO8O888O8O,COCOO"          ]],
				[[         , . ..:.::o:ooOoOOOO8OOOOCOCO"            ]],
				[[          . ..:.::o:ooOoOoOO8O8OCCCC"o             ]],
				[[             . ..:.::o:ooooOoCoCCC"o:o             ]],
				[[             . ..:.::o:o:,cooooCo"oo:o:            ]],
				[[          `   . . ..:.:cocoooo"'o:o:::'            ]],
				[[          .`   . ..::ccccoc"'o:o:o:::'             ]],
				[[         :.:.    ,c:cccc"':.:.:.:.:.'              ]],
				[[       ..:.:"'`::::c:"'..:.:.:.:.:.'               ]],
				[[     ...:.'.:.::::"'    . . . . .'                 ]],
				[[    .. . ....:."' `   .  . . ''                    ]],
				[[  . . . ...."'                                     ]],
				[[  .. . ."'                                         ]],
				[[ .                                                 ]],
				[[                                                   ]],
			}

			dashboard.section.buttons.val = {
				dashboard.button("f", "  Find file", "<cmd>Telescope find_files<cr>"),
				dashboard.button("r", "  Recent files", "<cmd>Telescope oldfiles<cr>"),
				dashboard.button("g", "  Live grep", "<cmd>Telescope live_grep<cr>"),
				dashboard.button("n", "  New file", "<cmd>ene <BAR> startinsert<cr>"),
				dashboard.button("c", "  Config", "<cmd>Telescope find_files cwd=" .. vim.fn.stdpath("config") .. "<cr>"),
				dashboard.button("l", "󰒲  Lazy", "<cmd>Lazy<cr>"),
				dashboard.button("m", "  Mason", "<cmd>Mason<cr>"),
				dashboard.button("q", "  Quit", "<cmd>qa<cr>"),
			}

			local function footer()
				local stats = require("lazy").stats()
				local ms = math.floor(stats.startuptime * 100) / 100
				return "⚡ " .. stats.loaded .. "/" .. stats.count .. " plugins in " .. ms .. "ms"
			end

			dashboard.section.header.opts.hl = "Function"
			dashboard.section.buttons.opts.hl = "Keyword"
			dashboard.section.footer.opts.hl = "Comment"

			alpha.setup(dashboard.opts)

			vim.api.nvim_create_autocmd("User", {
				once = true,
				pattern = "LazyVimStarted",
				callback = function()
					dashboard.section.footer.val = footer()
					pcall(vim.cmd.AlphaRedraw)
				end,
			})

			vim.api.nvim_create_autocmd("User", {
				once = true,
				pattern = "AlphaReady",
				callback = function()
					if package.loaded["lazy"] then
						dashboard.section.footer.val = footer()
						pcall(vim.cmd.AlphaRedraw)
					end
				end,
			})
		end,
	},
}
