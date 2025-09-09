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
   cmd = { "vtsls", "--stdio" },
   filetypes = {
      "javascript", "javascriptreact", "javascript.jsx",
      "typescript", "typescriptreact", "typescript.tsx",
   },
   capabilities = require("blink.cmp").get_lsp_capabilities(),
   root_dir = function(bufnr, on_dir)
      local fname = vim.api.nvim_buf_get_name(bufnr)
      -- skip if in deno project
      local is_deno_proj = find_root(fname, { "deno.json", "deno.jsonc" })
      if is_deno_proj then return nil end
      -- Typical TS roots
      local node_root = find_root(fname, { "tsconfig.json", "jsconfig.json", "package.json" })
      local root = node_root or vim.fn.getcwd()
      on_dir(root)
   end,
   settings = {
      -- vtsls top-level settings plus nested typescript settings are widely used
      vtsls = {
         autoUseWorkspaceTsdk = true, -- prefer workspace TS version when available
         -- You can also enable server-side fuzzy matching to trim heavy completion payloads
         experimental = {
            completion = { enableServerSideFuzzyMatch = true },
            maxInlayHintLength = 30,
         },
      },
      typescript = {
         suggest = { completeFunctionCalls = true },
         updateImportsOnFileMove = { enabled = "always" },
         inlayHints = {
            enumMemberValues = { enabled = true },
            functionLikeReturnTypes = { enabled = true },
            parameterNames = { enabled = "literals" },
            parameterTypes = { enabled = true },
            propertyDeclarationTypes = { enabled = true },
            variableTypes = { enabled = false },
         },
      },
   },
}
