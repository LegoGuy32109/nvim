return {
   cmd = { 'lua-language-server' },
   filetypes = { 'lua' },
   capabilities = require('blink.cmp').get_lsp_capabilities(),
   -- Nested lists indicate equal priority
   root_markers = { { '.luarc.json', '.luarc.jsonc' }, '.git' },
   settings = {
      Lua = {
         diagnostics = { globals = { "vim" } },
         workspace = { checkThirdParty = false },
         runtime = { version = 'LuaJIT' }
      }
   }
}
