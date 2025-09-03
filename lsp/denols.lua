return {
  cmd = { "deno", "lsp" },
  filetypes = {
    "javascript", "javascriptreact", "javascript.jsx",
    "typescript", "typescriptreact", "typescript.tsx",
  },
  capabilities = require("blink.cmp").get_lsp_capabilities(),
  -- Make Deno attach only when a Deno config exists (avoids conflicts with Node/vtsls)
  root_markers = { { "deno.json", "deno.jsonc" } },
  settings = {
    deno = {
      enable = true,
      lint = true,
      unstable = true,
    },
  },
}
