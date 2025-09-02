local vim = vim

return {
   -- Mason & deps
   {
      "williamboman/mason.nvim",
      build = ":MasonUpdate",
      config = function()
         require("mason").setup()
      end
   },
   -- {
   --    "williamboman/mason-lspconfig.nvim",
   --    config = function()
   --       require("mason-lspconfig").setup()
   --    end
   -- },
   {
      "neovim/nvim-lspconfig",
      dependencies = { 'saghen/blink.cmp' },
      opts = {
         servers = {
            lua_ls = {},
            tailwindcss = {},
            denols = {}
         }
      },
      config = function(_, opts)
         for server, config in pairs(opts.servers) do
            -- passing in config.capabilities merges with existing capabilities
            -- if I defined it
            config.capabilities = require('blink.cmp').get_lsp_capabilities(config.capabilities)
            vim.lsp.enable(server)
         end
      end
   },
   {
      "stevearc/conform.nvim",
      config = function()
         require("conform").setup({
            formatters_by_ft = {
               lua = { "stylua" },
               -- typescript = { "deno_fmt" },
            },
         })
         vim.keymap.set("n", "<leader>m", function()
            require("conform").format({ async = true, lsp_fallback = true })
         end, { desc = "For[M]at buffer" })
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
      dependencies = 'rafamadriz/friendly-snippets',
      version = '1.*',
      opts = {
         keymap = { preset = 'default' },
         appearance = {
            use_nvim_cmp_as_default = true,
            nerd_font_variant = 'mono'
         },
         signature = { enabled = true },
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
            window = { border = "rounded" }
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
               local map = function(mode, lhs, rhs, desc)
                  vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
               end
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
               -- actions
               map("n", "<leader>hs", gs.stage_hunk, "Stage hunk")
               map("n", "<leader>hr", gs.reset_hunk, "Reset hunk")
               map("n", "<leader>hS", gs.stage_buffer, "Stage buffer")
               map("n", "<leader>hu", gs.undo_stage_hunk, "Undo stage hunk")
               map("n", "<leader>hR", gs.reset_buffer, "Reset buffer")
               map("n", "<leader>hp", gs.preview_hunk, "Preview hunk")
               map("n", "<leader>hb", function() gs.blame_line({ full = true }) end, "Blame line")
               map("n", "<leader>hd", gs.diffthis, "Diff against index")
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
