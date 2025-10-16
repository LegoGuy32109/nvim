return {
	find_root = function(startpath, markers)
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
	end,
}
