local find_root = function(startpath, markers)
	local dir = vim.fs.dirname(startpath)
	for path in vim.fs.parents(dir) do
		for _, marker in ipairs(markers) do
			local candidate = path .. "/" .. marker
			if vim.fn.filereadable(candidate) == 1 then
				return path
			end
		end
	end
	return nil
end

return {
	cmd = { "biome", "lsp-proxy" },
	filetypes = {
		"html",
		"ejs",
		"css",
		"javascript",
		"javascriptreact",
		"javascript.jsx",
		"typescript",
		"typescriptreact",
		"typescript.tsx",
		"json",
		"jsonc",
	},
	capabilities = require("blink.cmp").get_lsp_capabilities(),
	root_markers = { "biome.json" },
	root_dir = function(bufnr, on_dir)
		local fname = vim.api.nvim_buf_get_name(bufnr)
		-- skip if in deno project
		local is_deno_root = find_root(fname, { "deno.json" })
		if is_deno_root then
			return nil
		end
		-- the biome root
		local biome_root = find_root(fname, { "biome.json" })
		local root = biome_root or vim.fn.getcwd()
		on_dir(root)
	end,
	single_file_support = false,
	settings = {}, -- Biome LSP is mostly auto-configured; project config lives in biome.json/biome.jsonc
}
