---@diagnostic disable-next-line: undefined-global vim is vim man
local vim = vim

local lspconfig = require("lspconfig")
local util = require("lspconfig.util")

-- Common on_attach for all LSPs
local on_attach = function(_, bufnr)
   local map = function(mode, lhs, rhs, desc)
      vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
   end
   map("n", "gd", vim.lsp.buf.definition, "Goto Definition")
   map("n", "gr", vim.lsp.buf.references, "Goto References")
   map("n", "K", vim.lsp.buf.hover, "Hover Documentation")
   map("n", "<leader>rn", vim.lsp.buf.rename, "Rename Symbol")
   map("n", "<leader>ca", vim.lsp.buf.code_action, "Code Action")
end

require("mason").setup()
require("mason-lspconfig").setup({
   ensure_installed = { "lua_ls", "jsonls", "bashls", "html", "biome", "rust_analyzer", "tailwindcss", "denols", "tsserver" },
   handlers = {
      -- default handler
      function(server)
         lspconfig[server].setup({
            on_attach = on_attach,
            -- capabilities = vim.lsp.protocol.make_client_capabilities(),
            -- on_init ?
         })
      end,

      -- Server specific setups

      lua_ls = function()
         lspconfig.lua_ls.setup({
            on_attach = on_attach,
            -- capabilities = vim.lsp.protocol.make_client_capabilities(),
            root_dir = function(fname)
               -- Prefer explicit project markers; otherwise fall back to the file's folder
               return util.root_pattern(".luarc.json", ".luarc.jsonc", ".stylua.toml", ".git")(fname)
                   or util.path.dirname(fname)
            end,
            settings = {
               Lua = {
                  runtime = { version = "LuaJIT" },
                  diagnostics = { globals = { "vim" } },
                  workspace = {
                     checkThirdParty = false,
                     -- Add Neovim runtime to library
                     library = { vim.env.VIMRUNTIME },
                  }
               },
               -- Format with stylua instead
               format = { enable = false },
            }
         })
      end,

      denols = function()
         lspconfig.denols.setup {
            on_attach = on_attach,
            -- capabilities = vim.lsp.protocol.make_client_capabilities(),
            root_dir = util.root_pattern("deno.json", "deno.jsonc"),
            init_options = {
               enable = true,
               lint = true,
               unstable = true,
               suggest = { imports = { hosts = { ["https://deno.land"] = true, }, }, },
            },
         }
      end,

      ts_ls = function()
         lspconfig.ts_ls.setup {
            on_attach = on_attach,
            -- capabilities = vim.lsp.protocol.make_client_capabilities(),
            root_dir = util.root_pattern("package.json"),
            single_file_support = false,
         }
      end,
   }
})
