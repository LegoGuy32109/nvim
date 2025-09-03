return {
   cmd = { "vtsls", "--stdio" },
   filetypes = {
      "javascript", "javascriptreact", "javascript.jsx",
      "typescript", "typescriptreact", "typescript.tsx",
   },
   capabilities = require("blink.cmp").get_lsp_capabilities(),
   -- Typical TS roots; keep tight so it doesn't collide with deno
   root_markers = { { "tsconfig.json", "jsconfig.json", "package.json" }, ".git" },
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
