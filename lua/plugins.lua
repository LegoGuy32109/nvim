local mapMaker = function(bufnr)
   return function(mode, lhs, rhs, desc)
      vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
   end
end

return {
   {
      "mason-org/mason.nvim",
      build = ":MasonUpdate",
      config = function()
         require("mason").setup({ PATH = "prepend" })
      end
   },
   {
      "stevearc/conform.nvim",
      config = function()
         require("conform").setup({
            formatters = {
               biome = {
                  args = { "format", "--stdin-file-path", "$FILENAME" },
                  stdin = true,
               },
               deno = {
                  command = "deno",
                  stdin = true,
                  args = function(_, ctx)
                     local ext = (ctx.filename or ""):match("%.([%w]+)$") or ""
                     return { "fmt", "-", "--ext", ext }
                  end
               }
            },
            formatters_by_ft = {
               lua = { "stylua" },
               javascript = { "deno" },
               typescript = { "deno" },
               javascriptreact = { "deno" },
               typescriptreact = { "deno" },
               json = { "deno" },
               jsonc = { "deno" },
               markdown = { "deno" },
               css = { "deno" },
               toml = { "deno" },
            },
         })
         vim.keymap.set("n", "<leader>n", function()
            require("conform").format({ async = true, lsp_fallback = true })
         end, { desc = "For[N]at buffer" })
      end
   },
   -- UI for showing progress
   { "j-hui/fidget.nvim", tag = "legacy", opts = {} },
   -- Telescope & deps
   {
      "nvim-telescope/telescope.nvim",
      dependencies = { "nvim-lua/plenary.nvim" },
      config = function()
         local telescope = require("telescope")
         telescope.setup({
            defaults = {
               -- Nice defaults
               sorting_strategy = "ascending",
               layout_config = { prompt_position = "top" },
               path_display = { "smart" },
               mappings = {
                  i = {
                     ["<C-n>"] = "move_selection_next",
                     ["<C-p>"] = "move_selection_previous",
                  },
               },
            },
            pickers = {
               find_files = {
                  -- Use fd with hidden files, ignore .git
                  find_command = { "fd", "--type", "f", "--hidden", "--strip-cwd-prefix", "--exclude", ".git" },
               },
            },
         })
      end,
   },
   -- FZF-native sorter (faster)
   {
      "nvim-telescope/telescope-fzf-native.nvim",
      build = "make",
      config = function()
         require("telescope").load_extension("fzf")
      end
   },
   -- treesitter
   {
      "nvim-treesitter/nvim-treesitter",
      build = ":TSUpdate",
      config = function()
         require("nvim-treesitter.configs").setup({
            ensure_installed = { "lua", "bash", "json" },
            highlight = { enable = true },
            indent = { enable = true },
         })
      end,
   },

   -- mini plugins
   {
      "echasnovski/mini.nvim",
      version = false,
      config = function()
         require("mini.pairs").setup()
         require("mini.surround").setup({
            mappings = {
               add = "sa",
               delete = "sd",
               replace = "sr",
               find = "sf",
               find_left = "sF",
               highlight = "sh",
               update_n_lines = "sn", -- change search window
            }
         })
         local ai = require("mini.ai")
         ai.setup({
            n_lines = 500,
            custom_textobjects = {
               -- use uppercase for custom ones so defaults still valid
               F = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }),
               C = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }),
               A = ai.gen_spec.treesitter({ a = "@parameter.outer", i = "@parameter.inner" }),
            }
         })
      end

   },

   {
      'saghen/blink.cmp',
      dependencies = { { 'L3MON4D3/LuaSnip', version = 'v2.*' }, 'moyiz/blink-emoji.nvim', 'Kaiser-Yang/blink-cmp-dictionary' },
      version = '1.*',
      ---@module 'blink.cmp'
      ---@type 'blink.cmp.Config'
      ---@diagnostic disable-next-line: assign-type-mismatch it's fine bro
      opts = {
         keymap = { preset = 'default' },
         appearance = {
            use_nvim_cmp_as_default = false,
            nerd_font_variant = 'mono'
         },
         signature = { enabled = true },
         snippets = { preset = "luasnip" },
         completion = { documentation = { auto_show = false } },
         sources = {
            default = { "lsp", "path", "snippets", "buffer", "emoji" },
            providers = {
               cmdline = {
                  min_keyword_length = 2,
               },
               emoji = {
                  module = "blink-emoji",
                  name = "Emoji",
                  score_offset = 15, -- Tune by preference
                  opts = {
                     insert = true,  -- Insert emoji (default) or complete its name
                     ---@type string|table|fun():table
                     trigger = function()
                        return { ":" }
                     end,
                  },
               }
            }
         }
      }
   },

   -- which-key: popup available keymaps
   {
      "folke/which-key.nvim",
      event = "VeryLazy",
      config = function()
         require('which-key').setup({
            plugins = {
               marks = true,
               registers = true,
               spelling = { enabled = true },
            },
            win = { border = "rounded" },
            -- tired of seeing :checkhealth which-key on startup every time
            disable = {
               checkhealth = true
            }
         })
      end
   },
   -- gitsigns: git hunks in the gutter
   {
      "lewis6991/gitsigns.nvim",
      event = { "BufReadPre", "BufNewFile" },
      config = function()
         require("gitsigns").setup({
            signs = {
               add          = { text = "│" },
               change       = { text = "│" },
               delete       = { text = "_" },
               topdelete    = { text = "‾" },
               changedelete = { text = "~" },
            },
            current_line_blame = true, -- show blame inline
            on_attach = function(bufnr)
               local gs = package.loaded.gitsigns
               local map = mapMaker(bufnr)
               -- hunk navigation
               map("n", "]c",
                  function()
                     if vim.wo.diff then return "]c" end
                     vim.schedule(gs.next_hunk)
                     return "<Ignore>"
                  end, "Next hunk")
               map("n", "[c",
                  function()
                     if vim.wo.diff then return "[c" end
                     vim.schedule(gs.prev_hunk)
                     return "<Ignore>"
                  end, "Prev hunk")
               -- normal actions
               map("n", "<leader>hs", gs.stage_hunk, "Stage hunk")
               map("n", "<leader>hr", gs.reset_hunk, "Reset hunk")
               map("n", "<leader>hS", gs.stage_buffer, "Stage buffer")
               map("n", "<leader>hu", gs.undo_stage_hunk, "Undo stage hunk")
               map("n", "<leader>hR", gs.reset_buffer, "Reset buffer")
               map("n", "<leader>hp", gs.preview_hunk, "Preview hunk")
               map("n", "<leader>hb", function() gs.blame_line({ full = true }) end, "Blame line")
               map("n", "<leader>hd", gs.diffthis, "Diff against index")
               map("n", "<leader>td", gs.toggle_deleted, "Toggle deleted lines")
               -- visual actions
               map('v', '<leader>hs', '<cmd>Gitsigns stage_hunk<CR>', 'Stage Hunk')
               map('v', '<leader>hr', '<cmd>Gitsigns reset_hunk<CR>', 'Reset Hunk')
            end,
         })
      end,
   },
   {
      "kdheepak/lazygit.nvim",
      cmd = { "LazyGit", "LazyGitConfig", "LazyGitCurrentFile", "LazyGitFilter" },
      dependencies = { "nvim-lua/plenary.nvim" },
      keys = {
         { "<leader>lg", "<cmd>LazyGit<cr>", desc = "Open LazyGit" }
      }
   },
   -- Nvim-tree for file explorer
   {
      "nvim-tree/nvim-tree.lua",
      lazy = false,
      dependencies = { "nvim-tree/nvim-web-devicons" },
      opts = {
         sort = {
            sorter = "case_sensitive",
         },
         view = {
            width = 25,
         },
         renderer = {
            group_empty = true,
         },
         filters = {
            dotfiles = false,
         },
         on_attach = function(bufnr)
            local api = require('nvim-tree.api')
            -- default mappings
            api.config.mappings.default_on_attach(bufnr)
         end
      },
      config = function(_, opts)
         require("nvim-tree").setup(opts)
         vim.keymap.set("n", "<leader>e", '<cmd>NvimTreeFindFileToggle<CR>', { desc = 'Toggle NvimTree' })
         vim.keymap.set("n", "<leader>o", '<cmd>NvimTreeFocus<CR>', { desc = 'Focus NvimTree' })
      end,
   },

   {
      "catppuccin/nvim",
      name = "catppuccin",
      priority = 1000,
      config = function()
         require("catppuccin").setup({
            flavour = "mocha",
            integrations = {
               telescope = true,
               treesitter = true,
               native_lsp = {
                  enabled = true,
               },
            },
         })
         vim.cmd.colorscheme("catppuccin")
      end,
   }
}
