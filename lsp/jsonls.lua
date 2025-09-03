return {
   cmd = { "vscode-json-language-server", "--stdio" },
   filetypes = { "json", "jsonc" },
   capabilities = require("blink.cmp").get_lsp_capabilities(),
   root_markers = { { "package.json" }, ".git" },
   settings = {
      json = {
         validate = { enable = true },
         format = { enable = true },
         schemaDownload = { enable = true },
         schemas = require('schemastore').json.schemas(),
         trace = { server = "off" },
      },
   },
}
