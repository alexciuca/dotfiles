local au = vim.api.nvim_create_autocmd

au("FileType", {
	pattern = "*",
	callback = function()
		vim.opt_local.formatoptions:remove({ "c", "r", "o" })
	end,
})

au("FileType", {
	pattern = { "json", "yaml", "javascript", "typescript", "javascriptreact", "typescriptreact", "html", "css" },
	callback = function()
		vim.opt_local.tabstop = 2
		vim.opt_local.softtabstop = 2
		vim.opt_local.shiftwidth = 2
	end,
})

au("LspAttach", {
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

vim.diagnostic.config({
	underline = false,
	virtual_text = { spacing = 2, prefix = "●" },
	update_in_insert = false,
	severity_sort = true,
})
