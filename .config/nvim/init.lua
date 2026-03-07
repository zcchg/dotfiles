local o = vim.opt
local group = vim.api.nvim_create_augroup("UserFunctions", { clear = true })
local function autocmd(events, opts)
  vim.api.nvim_create_autocmd(events, opts)
end

-- file options
  o.shada      = "'100,<1000,s100,:100,h"
  o.undofile   = true
  vim.g.loaded_netrw = 1
  vim.g.loaded_netrwPlugin = 1

-- search
  o.incsearch  = false -- don't search while typing
  o.ignorecase = true  -- case-insensitive searching
  o.smartcase  = true  --   unless contains uppercase

-- layout, mouse
  o.number     = true  -- show the number column
  o.cursorline = true  -- highlight the current line
  o.scrolloff  = 5     -- show the following 5 lines while scrolling
  o.mouse      = "vi"  -- only visual and insert modes

-- keybinding to show/hide line numbers
  vim.keymap.set("n", "<Leader>n", ":set number!<CR>", { noremap = true })

-- indentation
  autocmd("FileType", { group = group, pattern = vim.split([[
    text markdown sh zsh nu conf dosini json lua toml yaml
    css javascript tsx typescript html xml sql vim zig
  ]], "%s+", { trimempty = true }), callback = function()
    vim.opt_local.shiftwidth  = 2
    vim.opt_local.softtabstop = 2
    vim.opt_local.expandtab   = true
  end })

-- don't continue comment on newline
  autocmd("FileType", { group = group, callback = function()
    vim.opt_local.formatoptions:remove { "c", "r", "o" }
  end })

-- restore cursor position on open
  autocmd("BufReadPost", { group = group, callback = function(args)
    local file = args.file:match("([^/\\]+)$")
    if vim.tbl_contains({"COMMIT_EDITMSG", "REBASE_EDITMSG"}, file) then return end
    local m = vim.api.nvim_buf_get_mark(args.buf, '"')
    local l = vim.api.nvim_buf_line_count(args.buf)
    if m[1] > 0 and m[1] <= l then pcall(vim.api.nvim_win_set_cursor, 0, m) end
  end })

-- strip whitespace on save
  autocmd("BufWritePre", { group = group, callback = function(args)
    local view = vim.fn.winsaveview()
    vim.api.nvim_buf_call(args.buf, function()
      vim.cmd([[silent keepjumps keeppatterns %s/\s\+$//e]])
    end)
    vim.fn.winrestview(view)
  end })

-- syntax highlighting
  vim.pack.add({{ src = "https://github.com/nvim-treesitter/nvim-treesitter" }})
  local parsers = vim.split([[
    bash nu c css diff go gomod html ini javascript json lua make markdown
    python query regex ruby rust sql tsx typescript vim xml yaml zig
  ]], "%s+", { trimempty = true })
  require("nvim-treesitter").install(parsers)
  autocmd("FileType", { group = group, callback = function(args)
    pcall(vim.treesitter.start, args.buf)
  end })

-- themes
  vim.pack.add({{ src = "https://github.com/kungfusheep/mfd.nvim" }})
  vim.pack.add({{ src = "https://github.com/rebelot/kanagawa.nvim" }})
  vim.cmd.colorscheme(vim.o.background == "dark" and "yin" or "yang")

-- theme selector
  vim.pack.add({{ src = "https://github.com/zaldih/themery.nvim" }})
  require("themery").setup({ themes = {
    "yang",          "mfd-flir-bh",     "mfd-paper",    -- light
    "yin",           "mfd-flir",        "mfd-blackout", -- dark
    "mfd-amber",     "mfd-scarlet",                     -- red
    "mfd-hud",       "mfd-stealth",                     -- green
    "kanagawa-wave", "kanagawa-dragon",                 -- colorful
  } })
  vim.keymap.set("n", "<leader>th", "<cmd>Themery<cr>")
