local icons = require("ui.icons")

local api = vim.api
local cmd = vim.cmd
local fn = vim.fn

local ensure_packer = function()
	local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
	if fn.empty(fn.glob(install_path)) > 0 then
		fn.system({ "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path })
		cmd([[packadd packer.nvim]])
		return true
	end
	return false
end

local packer_bootstrap = ensure_packer()

local status_ok, packer = pcall(require, "packer")
if not status_ok then
	return
end

api.nvim_create_autocmd("BufWritePost", {
	pattern = "packer.lua",
	command = "source <afile> | PackerCompile",
	group = api.nvim_create_augroup("PackerGroup", {}),
})

packer.init({
	display = {
		done_sym = icons.progress.done,
		error_sym = icons.progress.error,
		header_sym = "—",
		moved_sym = icons.misc.moved,
		removed_sym = icons.progress.trash,
		working_sym = icons.progress.pending,
	},
	luarocks = { python_cmd = "python3" },
})

return packer.startup(function(use)
	use({ "wbthomason/packer.nvim" })

	use({ "lewis6991/impatient.nvim" })

	-- [[ UI]]
	use({
		"eandrju/cellular-automaton.nvim",
		"folke/zen-mode.nvim",
		"lukas-reineke/indent-blankline.nvim",
		"~/dev/github.com/snelling-a/nvim-base16",
		-- "snelling-a/nvim-base16",
		"norcalli/nvim-colorizer.lua",
		{ "nvim-tree/nvim-tree.lua", requires = { "nvim-tree/nvim-web-devicons" } },
		{ "folke/noice.nvim", requires = { "MunifTanjim/nui.nvim", "rcarriga/nvim-notify" } },
		"freddiehaddad/feline.nvim",
	})

	-- [[[ TELESCOPE ]]]
	use({
		"nvim-telescope/telescope.nvim",
		requires = {
			"nvim-lua/plenary.nvim",
			"nvim-telescope/telescope-node-modules.nvim",
			"nvim-telescope/telescope-ui-select.nvim",
			{ "nvim-telescope/telescope-fzf-native.nvim", run = "make" },
		},
	})

	--[[ TREESITTER ]]
	use({
		"nvim-treesitter/nvim-treesitter",
		run = ":TSUpdate",
		requires = {
			"JoosepAlviste/nvim-ts-context-commentstring",
			"nvim-ts-autotag",
			"HiPhish/nvim-ts-rainbow2",
			"nvim-treesitter/nvim-treesitter-context",
			"nvim-treesitter/nvim-treesitter-textobjects",
		},
	})

	-- [[ LSP ]]
	use({
		{
			"neovim/nvim-lspconfig",
			requires = { "SmiteshP/nvim-navic", "williamboman/mason.nvim", "williamboman/mason-lspconfig.nvim" },
		},
		"jay-babu/mason-null-ls.nvim",
		"jose-elias-alvarez/null-ls.nvim",
		"b0o/schemastore.nvim",
		"fladson/vim-kitty",
		"folke/neodev.nvim",
		"jose-elias-alvarez/typescript.nvim",
		"jparise/vim-graphql",
		{ "preservim/vim-markdown", ft = "markdown", dependencies = { "godlygeek/tabular" } },

		"simrat39/symbols-outline.nvim",
		{ "folke/trouble.nvim", requires = "nvim-tree/nvim-web-devicons" },
	})

	-- [[ TOOLS ]]
	use({
		"akinsho/toggleterm.nvim",
		"mbbill/undotree",
		{
			"ThePrimeagen/refactoring.nvim",
			requires = { { "nvim-lua/plenary.nvim" }, { "nvim-treesitter/nvim-treesitter" } },
		},
	})

	use({
		"junegunn/vim-easy-align",
		{ "kylechui/nvim-surround", tag = "*" },
		"numToStr/Comment.nvim",
		"windwp/nvim-autopairs",
	})

	-- [[ GIT ]]
	use({ "kdheepak/lazygit.nvim", "lewis6991/gitsigns.nvim", "tpope/vim-fugitive", "tpope/vim-rhubarb" })

	-- [[ COMPLETION ]]
	use({
		"hrsh7th/cmp-nvim-lsp",
		"hrsh7th/cmp-buffer",
		"hrsh7th/cmp-path",
		"hrsh7th/cmp-cmdline",
		"hrsh7th/nvim-cmp",
		"ray-x/cmp-treesitter",
		{
			"L3MON4D3/LuaSnip",
			requires = {
				"rafamadriz/friendly-snippets",
				"saadparwaiz1/cmp_luasnip",
			},
		},
		{ "petertriho/cmp-git", requires = "nvim-lua/plenary.nvim" },
	})

	-- [[ COPILOT ]]
	use({ "github/copilot.vim", "zbirenbaum/copilot.lua", { "zbirenbaum/copilot-cmp", after = { "copilot.lua" } } })

	use({ "glacambre/firenvim", run = "FirenvimReload" })

	use({ "epwalsh/obsidian.nvim", requires = "nvim-lua/plenary.nvim" })
	use({ "jakewvincent/mkdnflow.nvim", rocks = "luautf8" })
	use({
		"lukas-reineke/headlines.nvim",
		after = "nvim-treesitter",
		config = function() require("headlines").setup() end,
	})

	if packer_bootstrap then
		require("packer").sync()
	end
end)
