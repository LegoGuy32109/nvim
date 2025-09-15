local function find_root(startpath, markers)
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
   cmd = { "deno", "lsp" },
   filetypes = {
      "javascript", "javascriptreact", "javascript.jsx",
      "typescript", "typescriptreact", "typescript.tsx",
   },
   capabilities = require("blink.cmp").get_lsp_capabilities(),
   -- Make Deno attach only when a Deno config exists (avoids conflicts with Node/vtsls)
   root_markers = { { "deno.json", "deno.jsonc" } },
   root_dir = function(bufnr, on_dir)
      local fname = vim.api.nvim_buf_get_name(bufnr)
      -- skip if in node project
      local is_node_root = find_root(fname, { "tsconfig.json", "jsconfig.json", "package.json" })
      if is_node_root then return nil end
      -- typical deno roots
      local deno_root = find_root(fname, { "deno.json", "deno.jsonc" })
      local root = deno_root or vim.fn.getcwd()
      on_dir(root)
   end,
   settings = {
      deno = {
         enable = true,
         lint = true,
         unstable = true,
      },
   },
}
