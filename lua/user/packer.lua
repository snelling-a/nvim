-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
vim.cmd.packadd('packer.nvim')

return require('packer').startup(function(use)
    -- Packer can manage itself
    use 'wbthomason/packer.nvim'

    use {
        'nvim-telescope/telescope.nvim',
        requires = {
            'nvim-lua/plenary.nvim',
            "nvim-telescope/telescope-node-modules.nvim",
            { 'nvim-telescope/telescope-fzf-native.nvim',
                run = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build' }
        }
    }

    use {
        'nvim-lualine/lualine.nvim',
        requires = {
            { 'kyazdani42/nvim-web-devicons' },
            { 'RRethy/nvim-base16', opt = false },
        }
    }
    use { 'akinsho/bufferline.nvim', tag = "v3.*", requires = 'nvim-tree/nvim-web-devicons' }

    use("JoosepAlviste/nvim-ts-context-commentstring")
    use("gpanders/editorconfig.nvim")
    use("nvim-treesitter/nvim-treesitter-textobjects")
    use('nvim-treesitter/playground')
    use({ 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' })

    use('theprimeagen/harpoon')
    use('mbbill/undotree')

    use("numToStr/Comment.nvim")
    use("kylechui/nvim-surround")
    use {
        "windwp/nvim-autopairs",
        config = function() require("nvim-autopairs").setup {} end
    }
    use('tpope/vim-fugitive')
    use("tpope/vim-rhubarb")
    use {
        'lewis6991/gitsigns.nvim',
        tag = 'v0.6'
    }
    use {
        'pwntester/octo.nvim',
        requires = {
            'nvim-lua/plenary.nvim',
            'nvim-telescope/telescope.nvim',
            'kyazdani42/nvim-web-devicons',
        },
    }

    use {
        'VonHeikemen/lsp-zero.nvim',
        requires = {
            -- LSP Support
            { 'neovim/nvim-lspconfig' },
            { 'williamboman/mason.nvim' },
            { 'williamboman/mason-lspconfig.nvim' },

            -- Autocompletion
            { 'hrsh7th/nvim-cmp' },
            { 'hrsh7th/cmp-buffer' },
            { 'hrsh7th/cmp-path' },
            { 'saadparwaiz1/cmp_luasnip' },
            { 'hrsh7th/cmp-nvim-lsp' },
            { 'hrsh7th/cmp-nvim-lua' },

            -- Snippets
            { 'L3MON4D3/LuaSnip' },
            { 'rafamadriz/friendly-snippets' },
        }
    }

    use("folke/zen-mode.nvim")
    use("github/copilot.vim")

    use {
        'nvim-tree/nvim-tree.lua',
        requires = {
            'nvim-tree/nvim-web-devicons',
        },
    }
end)
