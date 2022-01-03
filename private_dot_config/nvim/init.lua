local cmd = vim.cmd
local exec = vim.api.nvim_exec
local g = vim.g
local opt = vim.opt
local map = vim.api.nvim_set_keymap
local default_opts = {noremap = true, silent = true}

cmd [[packadd packer.nvim]]

require('packer').startup(function()
  use 'wbthomason/packer.nvim'
  use 'mg979/vim-visual-multi'
  use 'joshdick/onedark.vim'
  use 'b3nj5m1n/kommentary'
  use {
    'nvim-lualine/lualine.nvim',
    requires = {'kyazdani42/nvim-web-devicons'},
    config = function() require'lualine'.setup {
      extensions = {'nvim-tree'}
    } end
  }
  use {
    'nvim-telescope/telescope.nvim',
    requires = {'nvim-lua/plenary.nvim'},
    config = function() require'telescope'.setup {
      defaults = {
        prompt_prefix = '',
        selection_caret = '',
        border = false,
        initial_mode = 'normal',
      },
      pickers = {
        find_files = {theme = 'dropdown'},
        buffers = {theme = 'dropdown'},
        live_grep = {theme = 'dropdown'},
      }
    } end
  }
  use {
    'kyazdani42/nvim-tree.lua',
    requires = {
      'kyazdani42/nvim-web-devicons',
    },
    config = function() require'nvim-tree'.setup {
      update_cwd = true,
      update_focused_file = {
        enable = true
      },
      view = {
        side = 'left',
        width = 40,
        auto_resize = true
      }
    } end
  }
  use {
    'neovim/nvim-lspconfig',
    config = function()
      require'lspconfig'.tsserver.setup{}
    end
  }
end)

opt.colorcolumn = '80'
opt.cursorline = true
opt.whichwrap:append({h = true, l = true})
opt.spelllang = {'en_us', 'ru'}
opt.list = true
opt.signcolumn = 'yes'
opt.number = true
opt.relativenumber = true
opt.so = 999
opt.undofile = true
opt.splitright = true
opt.splitbelow = true
opt.termguicolors = true
opt.expandtab = true
opt.shiftwidth = 2
opt.tabstop = 2
opt.smartindent = true
cmd([[
  filetype indent plugin on
  syntax enable
]])

cmd'colorscheme onedark'
cmd(([[
  highlight TelescopeBorder guifg=#3e4452
]]))

map('', '<up>', ':echoe "Use k"<CR>', {noremap = true, silent = false})
map('', '<down>', ':echoe "Use j"<CR>', {noremap = true, silent = false})
map('', '<left>', ':echoe "Use h"<CR>', {noremap = true, silent = false})
map('', '<right>', ':echoe "Use l"<CR>', {noremap = true, silent = false})

map('', 'fn', ':NvimTreeToggle<CR>', {noremap = true, silent = false})
map('', 'fb', ':Telescope buffers<CR>', {noremap = true, silent = false})
map('', 'ff', ':Telescope find_files<CR>', {noremap = true, silent = false})
map('', 'fg', ':Telescope live_grep<CR>', {noremap = true, silent = false})

