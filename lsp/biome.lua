return {
   cmd = { "biome",  "lsp-proxy" },
   filetypes = {
      "javascript", "javascriptreact", "javascript.jsx",
      "typescript", "typescriptreact", "typescript.tsx",
      "json", "jsonc",
   },
   capabilities = require("blink.cmp").get_lsp_capabilities(),
   -- Prefer a Biome config file, then JS/TS roots, then git
   root_markers = { { "biome.json", "biome.jsonc" }, { "package.json", "tsconfig.json", "jsconfig.json" }, ".git" },
   settings = {}, -- Biome LSP is mostly auto-configured; project config lives in biome.json/biome.jsonc
}
