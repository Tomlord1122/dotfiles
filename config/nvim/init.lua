-- =============================================================================
-- Neovim Configuration
-- =============================================================================

-- ---------------------------------------------------------------------------
-- 1. Bootstrap lazy.nvim (plugin manager)
-- ---------------------------------------------------------------------------
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- ---------------------------------------------------------------------------
-- 2. Plugins
-- ---------------------------------------------------------------------------
require("lazy").setup({
  -- Treesitter: superior syntax highlighting via incremental parsing
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        -- Install parsers for common languages
        ensure_installed = {
          "bash", "c", "css", "go", "html", "javascript", "json",
          "lua", "markdown", "python", "rust", "toml", "tsx",
          "typescript", "vim", "vimdoc", "yaml",
        },
        -- Automatically install parsers when entering a buffer
        auto_install = true,
        highlight = {
          enable = true,
          -- Disable vim's regex-based highlighting (treesitter replaces it)
          additional_vim_regex_highlighting = false,
        },
        indent = { enable = true },
      })
    end,
  },

  -- Dracula colorscheme (matches your Ghostty terminal theme)
  {
    "Mofiqul/dracula.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd.colorscheme("dracula")
    end,
  },
})

-- ---------------------------------------------------------------------------
-- 3. General settings
-- ---------------------------------------------------------------------------

-- Line numbers
vim.opt.number = true         -- Show absolute line number on current line
vim.opt.relativenumber = true -- Relative numbers on other lines (easier jumps)

-- Search
vim.opt.hlsearch = true       -- Highlight search matches
vim.opt.incsearch = true      -- Show matches as you type
vim.opt.ignorecase = true     -- Case-insensitive search...
vim.opt.smartcase = true      -- ...unless query contains uppercase

-- Indentation
vim.opt.tabstop = 4           -- Display width of a tab character
vim.opt.shiftwidth = 4        -- Indent/outdent by 4 spaces
vim.opt.softtabstop = 4       -- Backspace treats 4 spaces as a tab
vim.opt.expandtab = true      -- Use spaces instead of tabs
vim.opt.smartindent = true    -- Auto-indent new lines

-- UI
vim.opt.termguicolors = true  -- 24-bit color (required for modern colorschemes)
vim.opt.cursorline = true     -- Highlight the current line
vim.opt.signcolumn = "yes"    -- Always show sign column (avoids layout shift)
vim.opt.scrolloff = 8         -- Keep 8 lines visible above/below cursor
vim.opt.wrap = false          -- Don't wrap long lines

-- Behavior
vim.opt.mouse = "a"           -- Enable mouse in all modes
vim.opt.clipboard = "unnamedplus" -- Use system clipboard
vim.opt.undofile = true       -- Persistent undo across sessions
vim.opt.swapfile = false      -- No swap files
vim.opt.updatetime = 250      -- Faster CursorHold events (useful for plugins)

-- Clear search highlights with Esc
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")
