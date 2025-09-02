---@diagnostic disable-next-line: undefined-global vim is vim man
local vim = vim

-- Leader <space>
vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.g.markdown_fenced_languages = {
   "ts=typescript"
}

-- Some defaults
vim.opt.number = true
vim.opt.termguicolors = true
vim.opt.signcolumn = "yes"
vim.opt.updatetime = 200
vim.opt.tabstop = 3
vim.opt.shiftwidth = 3
vim.opt.softtabstop = 3
vim.opt.expandtab = true

-- vim.keymap.set("n", "<C-'>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlights" })
vim.keymap.set("i", "jk", "<Esc>", { desc = "Exit insert mode" })
-- paste what was last yanked
vim.keymap.set("n", "<leader>p", '"0p', { desc = "Paste last yank" })
vim.keymap.set("n", "<leader>P", '"0P', { desc = "Paste last yank before" })
vim.keymap.set("x", "<leader>p", '"0P', { desc = "Paste last yank" })
-- recenter screen after movement / jump
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

vim.diagnostic.config({
   float = { border = "rounded" },
   severity_sort = true,
})
vim.keymap.set("n", "<leader>e", function()
   vim.diagnostic.open_float(nil, { scope = "line", focus = false, border = "rounded" })
end, { desc = "Show line diagnostics", silent = true })
vim.keymap.set("n", "<leader>q", vim.diagnostic.setqflist, { desc = "Open diagnostics list" })

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
   vim.fn.system({
      "git", "clone", "--filter=blob:none",
      "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath
   })
end
vim.opt.rtp:prepend(lazypath)

-- Load plugins
require("lazy").setup("plugins")

-- Telescope keymaps (after plugins load)
local ok, tb = pcall(require, "telescope.builtin")
if ok then
   vim.keymap.set("n", "<leader>ff", function()
      tb.find_files()
   end, { desc = "Find Files" })
   vim.keymap.set("n", "<leader>fg", tb.live_grep, { desc = "LiveGrep" })
   vim.keymap.set("n", "<leader>fb", tb.buffers, { desc = "Find Buffers" })
   vim.keymap.set("n", "<leader>fh", tb.help_tags, { desc = "Find Help" })
   vim.keymap.set("n", "<leader>fr", tb.resume, { desc = "Resume Search" })
   vim.keymap.set("n", "<leader>fo", tb.oldfiles, { desc = "Find Old Files" })
end

vim.api.nvim_create_autocmd('LspAttach', {
   group = vim.api.nvim_create_augroup('UserLspConfig', {}),
   callback = function(ev)
      local map = function(keys, func, desc)
         vim.keymap.set('n', keys, func, { buffer = ev.buf, desc = 'Lsp: ' .. desc })
      end

      local telescope = require('telescope.builtin')
      map('gd', telescope.lsp_definitions, 'Goto Definition')
      map('<leader>fs', telescope.lsp_document_symbols, 'Doc Symbols')
      map('<leader>fS', telescope.lsp_dynamic_workspace_symbols, 'Dynamic Symbols')
      map('gt', telescope.lsp_type_definitions, 'Goto Type')
      map('<leader>fR', telescope.lsp_references, 'Goto References')
      map('<leader>fi', telescope.lsp_implementations, 'Goto Impl')

      map('K', vim.lsp.buf.hover, 'hover')
      map('<leader>e', vim.diagnostic.open_float, 'diagnostic')
      map('<leader>k', vim.lsp.buf.signature_help, 'sig help')
      map('<leader>rn', vim.lsp.buf.rename, 'rename')
      map('<leader>ca', vim.lsp.buf.code_action, 'code action')
      map('<leader>m', vim.lsp.buf.format, 'format')

      vim.keymap.set('v', '<leader>ca',
         vim.lsp.buf.code_action, { buffer = ev.buf, desc = 'Lsp: code_action' })
   end
})

-- require("config.lsp")
