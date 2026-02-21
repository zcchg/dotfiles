local o = vim.opt

-- file options
  o.shada = "'100,f0,<1000,s100,:100,h"
  o.undofile = false
  vim.g.loaded_netrw = 1
  vim.g.loaded_netrwPlugin = 1

-- config and cache directories
  o.undodir   = { vim.fn.stdpath("data") .. "/undo" } ; vim.fn.mkdir(o.undodir._value,   "p")

-- functions
  -- strip whitespace on save
  vim.api.nvim_create_autocmd("BufWritePre", { pattern = "*", callback = function()
    local view = vim.fn.winsaveview()
    local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
    for i, line in ipairs(lines) do ; lines[i] = line:gsub("%s+$", "") ; end
    vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
    vim.fn.winrestview(view)
  end })

-- search
  o.hlsearch = true   -- highlight all matches
  o.incsearch = false -- don't search while typing
  o.ignorecase = true -- case-insensitive searching
  o.smartcase = true  --   unless contains uppercase

-- layout, mouse
  o.number = true     -- show the number column
  o.cursorline = true -- highlight the current line
  o.scrolloff = 5     -- show the following 5 lines while scrolling
  o.mouse = "vi"      -- only visual and insert modes

-- filetype indentation
  o.formatoptions:remove { "c", "r", "o" } -- don't continue comment on newline
  o.tabstop = 4 o.shiftwidth = 2 o.softtabstop = 2 o.expandtab = true

-- theme
  if o.background:get() == "dark" then
    -- yin mfd-amber mfd-scarlet mfd-hud mfd-nvg mfd-stealth
    vim.cmd.colorscheme("Mies")
  else
    vim.cmd.colorscheme("yang")
  end

