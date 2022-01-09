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
  use {
    'navarasu/onedark.nvim',
    config = function() require'onedark'.load() end
  }
  use 'b3nj5m1n/kommentary'
  use {
  'blackCauldron7/surround.nvim',
    config = function() require'surround'.setup {
      mappings_style = 'sandwich',
      quotes = {"'", '"', '`'},
      prefix = 'c',
    } end
  }
  use {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate',
    config = function() require'nvim-treesitter.configs'.setup {
      ensure_installed = {
        'javascript',
        'typescript',
        'tsx',
        'scss',
        'css',
        'html',
        'json',
        'yaml',
        'lua',
      },
      highlight = {
        enable = true
      }
    } end
  }
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
      pickers = {
        find_files = {theme = 'dropdown'},
        live_grep = {theme = 'dropdown'},
        buffers = {theme = 'dropdown'},
        lsp_code_actions = {theme = 'cursor'},
        lsp_references = {theme = 'dropdown'},
        diagnostics = {theme = 'dropdown'},
        git_commits = {theme = 'dropdown'},
        git_branches = {theme = 'dropdown'},
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
      local nvim_lsp = require('lspconfig')
      local on_attach = function(client, bufnr)
        local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
        local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end
        buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')
        local opts = { noremap=true, silent=true }
        buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
        buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
        buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
        buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
        buf_set_keymap('n', 'ga', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
        buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
        buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
      end
      local tsserver_like_root_dir = function(fname)
        local primary = nvim_lsp.util.root_pattern('package-lock.json')(fname)
        local fallback = nvim_lsp.util.root_pattern('package.json', 'tsconfig.json')(fname)
        return primary or fallback
      end
      local servers = {
        {'tsserver', tsserver_like_root_dir},
        {'eslint', tsserver_like_root_dir},
        -- {'jsonls'},
      }
      for _, lsp in ipairs(servers) do
        local options = {
          on_attach = on_attach,
          flags = {
            debounce_text_changes = 150,
          }
        }
        if lsp[2] then
          options.root_dir = lsp[2]
        end
        nvim_lsp[lsp[1]].setup(options)
      end
    end
  }
  use 'hrsh7th/cmp-nvim-lsp'
  use 'hrsh7th/cmp-buffer'
  use 'hrsh7th/cmp-path'
  use 'hrsh7th/cmp-cmdline'
  use 'hrsh7th/cmp-vsnip'
  use 'hrsh7th/vim-vsnip'
  use {
    'hrsh7th/nvim-cmp',
    config = function()
      local cmp = require'cmp'
      cmp.setup {
        snippet = {
          expand = function(args)
            vim.fn["vsnip#anonymous"](args.body)
          end,
        },
        mapping = {
          ['<C-b>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
          ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
          ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
          ['<C-y>'] = cmp.config.disable,
          ['<C-e>'] = cmp.mapping({
            i = cmp.mapping.abort(),
            c = cmp.mapping.close(),
          }),
          ['<CR>'] = cmp.mapping.confirm({ select = true }),
        },
        formatting = {
          format = function(entry, vim_item)
            vim_item.menu = ({
              buffer = "[Buffer]",
              nvim_lsp = "[LSP]",
              luasnip = "[LuaSnip]",
              nvim_lua = "[Lua]",
              latex_symbols = "[LaTeX]",
            })[entry.source.name]
            return vim_item
          end
        },
        sources = cmp.config.sources({
          {name = 'nvim_lsp'},
          {name = 'vsnip'},
        }, {
          {name = 'buffer'},
        }),
      }
    end
  }
end)

opt.cursorline = true
opt.whichwrap:append({h = true, l = true})
opt.spelllang = {'en_us', 'ru'}
opt.list = true
opt.number = true
opt.relativenumber = true
opt.signcolumn = 'yes'
opt.so = 999
opt.undofile = true
opt.splitright = true
opt.splitbelow = true
opt.termguicolors = true
opt.expandtab = true
opt.shiftwidth = 2
opt.tabstop = 2
opt.smartindent = true

g.VM_maps = {Undo = 'u', Redo = '<C-r>'}
g.VM_highlight_matches = 'hi! Search guibg=#3b3f4c'

cmd [[syntax off]]

map('', 'fn', ':NvimTreeToggle<CR>', {noremap = true, silent = false})
map('', 'fb', ':Telescope buffers<CR><Esc>', {noremap = true, silent = false})
map('', 'fg', ':Telescope live_grep<CR>', {noremap = true, silent = false})
map('', 'ff', ':Telescope find_files<CR>', {noremap = true, silent = false})
map('', 'fa', ':Telescope lsp_code_actions<CR><Esc>', {noremap = true, silent = false})
map('', 'fr', ':Telescope lsp_references<CR><Esc>', {noremap = true, silent = false})
map('', 'fd', ':Telescope diagnostics<CR><Esc>', {noremap = true, silent = false})
map('', 'fgc', ':Telescope git_commits<CR><Esc>', {noremap = true, silent = false})
map('', 'fgb', ':Telescope git_branches<CR><Esc>', {noremap = true, silent = false})
