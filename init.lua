-- disable netrw
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
-- Leader <space>
vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.g.markdown_fenced_languages = { "ts=typescript" }
vim.g.have_nerd_font = true

-- Some defaults
vim.o.winborder = 'rounded'
vim.o.swapfile = false
vim.opt.number = true
vim.opt.termguicolors = true
vim.opt.signcolumn = "yes"
vim.opt.updatetime = 200
vim.opt.tabstop = 3
vim.opt.shiftwidth = 3
vim.opt.softtabstop = 3
vim.opt.expandtab = true
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.listchars = {
   tab = '▏ ',
   leadmultispace = '▏ ',
   trail = '￮',
   multispace = '￮',
   lead = '\\',
   extends = '▶',
   precedes = '◀',
   nbsp = '‿'
}
vim.opt.spell = true
vim.opt.spelllang = { "en_us" }

vim.keymap.set("i", "jk", "<Esc>", { desc = "Exit insert mode" })
-- paste what was last yanked
vim.keymap.set("n", "<leader>p", '"+p', { desc = "Paste System Clipboard" })
vim.keymap.set("n", "<leader>P", '"+P', { desc = "Paste System Clipboard before" })
vim.keymap.set("x", "<leader>p", '"+p', { desc = "Paste System Clipboard" })
vim.keymap.set("n", "<leader><C-p>", '"0p', { desc = "Paste last yank" })
vim.keymap.set("n", "<leader><C-P>", '"0P', { desc = "Paste last yank before" })
vim.keymap.set("x", "<leader><C-p>", '"0p', { desc = "Paste last yank" })
-- yank into system clipboard
vim.keymap.set("n", "<leader>y", '"+y', { desc = "Yank to System Clipboard" })
vim.keymap.set("x", "<leader>y", '"+y', { desc = "Yank to System Clipboard" })
-- recenter screen after movement / jump
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")
vim.keymap.set("n", "}", "}zzzv")
vim.keymap.set("n", "{", "{zzzv")

vim.diagnostic.config({
   virtual_text = { current_line = true },
   virtual_lines = { current_line = true },
   float = { border = "rounded" },
   severity_sort = true,
})
vim.keymap.set("n", "<leader>E", function()
   vim.diagnostic.open_float(nil, { scope = "line", focus = false, border = "rounded" })
end, { desc = "Show line diagnostics", silent = true })
vim.keymap.set("n", "<leader>d", vim.diagnostic.setqflist, { desc = "Open [D]iagnostics list" })

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
vim.lsp.enable({
   "biome",
   "denols",
   "luals",
   "tailwindcss",
   "vtsls",
})
vim.keymap.set("n", "<leader>ls", "<cmd>checkhealth lsp<CR>", { desc = "LspInfo" })
vim.keymap.set("n", "<leader>w", "<cmd>update<CR>", { desc = "Save file" })
vim.keymap.set("n", "<leader>s", function()
   require('conform').format({
      async = true,
      lsp_fallback = true,
      timeout_ms = 2000,
   }, function(err)
      if not err then
         vim.cmd("update")
      end
   end)
end, { desc = "Format and Save file", remap = true })
vim.keymap.set("n", "<leader>W", "<cmd>wa<CR>", { desc = "Save all files" })
vim.keymap.set("n", "<leader>q", "<cmd>qa<CR>", { desc = "Exit neovim" })
vim.keymap.set("n", "<leader>Q", "<cmd>qa!<CR>", { desc = "Force Exit neovim" })
vim.keymap.set("n", "<leader>x", "<cmd>q<CR>", { desc = "Exit file" })
vim.keymap.set("n", "<leader>X", "<cmd>q!<CR>", { desc = "Force Exit file" })
vim.keymap.set({ "n", "v", "x" }, "<Left>", "<C-W>h", { desc = "Go To Left Window" })
vim.keymap.set({ "n", "v", "x" }, "<Up>", "<C-W>k", { desc = "Go To Up Window" })
vim.keymap.set({ "n", "v", "x" }, "<Down>", "<C-W>j", { desc = "Go To Down Window" })
vim.keymap.set({ "n", "v", "x" }, "<Right>", "<C-W>l", { desc = "Go To Right Window" })

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
   vim.keymap.set("n", "zs", function()
      tb.spell_suggest(require("telescope.themes").get_cursor({}))
   end, { desc = "Spell Suggetions" })
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
      map('<leader>gt', telescope.lsp_type_definitions, 'Goto Type')
      map('<leader>fR', telescope.lsp_references, 'Goto References')
      map('<leader>fi', telescope.lsp_implementations, 'Goto Impl')

      map('K', vim.lsp.buf.hover, 'hover')
      map('<leader>k', vim.lsp.buf.signature_help, 'sig help')
      map('<leader>rn', vim.lsp.buf.rename, 'rename')

      vim.keymap.set({ 'v', 'x', 'n' }, '<leader>ca', function()
         -- range does not work :(
         local row = vim.api.nvim_win_get_cursor(0)[1]
         local text = vim.api.nvim_buf_get_lines(0, row - 1, row, true)[1] or ''
         local range = { start = { row, 0 }, ['end'] = { row, #text } }
         print(range)
         vim.lsp.buf.code_action({ range })
      end, { buffer = ev.buf, desc = 'Lsp: code_action', })
   end
})

-- highlight groups for spelling
vim.api.nvim_set_hl(0, "SpellBad", { undercurl = true, sp = "Red" })
vim.api.nvim_set_hl(0, "SpellCap", { undercurl = true, sp = "Orange" })
vim.api.nvim_set_hl(0, "SpellLocal", { undercurl = true, sp = "Yellow" })
vim.api.nvim_set_hl(0, "SpellRare", { undercurl = true, sp = "Cyan" })
