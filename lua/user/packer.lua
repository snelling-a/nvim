local utils = require("utils")

local ensure_packer = function()
	local fn = vim.fn
	local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
	if fn.empty(fn.glob(install_path)) > 0 then
		fn.system({ "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path })
		vim.cmd([[packadd packer.nvim]])
		return true
	end
	return false
end

local packer_bootstrap = ensure_packer()

local status_ok, packer = pcall(require, "packer")
if not status_ok then
	return
end

local PackerGroup = utils.augroup("PackerGroup", {})
utils.autocmd("BufWritePost", {
	pattern = "packer.lua",
	command = "source <afile> | PackerCompile",
	group = PackerGroup,
})

packer.init({
	display = {
		working_sym = "",
		error_sym = "",
		done_sym = "",
		removed_sym = "ﮁ",
		moved_sym = "",
		header_sym = "—",
	},
	luarocks = { python_cmd = "python3" }, -- Set the python command to use for running hererocks
})

return packer.startup(function(use)
	use({ "wbthomason/packer.nvim" })

	use({ "lewis6991/impatient.nvim" })

	-- [[ UI]]
	use({
		"eandrju/cellular-automaton.nvim",
		"folke/zen-mode.nvim",
		"lukas-reineke/indent-blankline.nvim",
		"norcalli/nvim-colorizer.lua",
		"RRethy/nvim-base16",
		{ "nvim-tree/nvim-tree.lua", requires = { "nvim-tree/nvim-web-devicons" } },
		{
			{ "folke/noice.nvim", requires = { "MunifTanjim/nui.nvim", "rcarriga/nvim-notify" }, cond = utils.is_vim },
			{ "glepnir/dashboard-nvim", requires = { "nvim-tree/nvim-web-devicons" }, cond = utils.is_vim },
			{ "nvim-lualine/lualine.nvim", requires = { "kyazdani42/nvim-web-devicons" }, cond = utils.is_vim },
		},
	})

	-- [[[ TELESCOPE ]]]
	use({
		"nvim-telescope/telescope.nvim",
		requires = {
			-- "gbrlsnchs/telescope-lsp-handlers.nvim",
			"nvim-lua/plenary.nvim",
			"nvim-telescope/telescope-node-modules.nvim",
			"nvim-telescope/telescope-ui-select.nvim",
			{
				"nvim-telescope/telescope-fzf-native.nvim",
				run = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release"
					.. "&& cmake --build build --config Release"
					.. "&& cmake --install build --prefix build",
			},
		},
	})

	--[[ TREESITTER ]]
	use({
		"JoosepAlviste/nvim-ts-context-commentstring",
		"mrjones2014/nvim-ts-rainbow",
		"nvim-treesitter/nvim-treesitter-context",
		"nvim-treesitter/nvim-treesitter-textobjects",
		{ "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" },
	})

	-- [[ LSP ]]
	use({
		{
			"neovim/nvim-lspconfig",
			requires = { "hrsh7th/cmp-nvim-lsp", "williamboman/mason.nvim", "williamboman/mason-lspconfig.nvim" },
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
		"theprimeagen/harpoon",
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
	use({
		"lewis6991/gitsigns.nvim",
		"tpope/vim-fugitive",
		"tpope/vim-rhubarb",
		{
			"pwntester/octo.nvim",
			requires = { "nvim-lua/plenary.nvim", "nvim-telescope/telescope.nvim", "kyazdani42/nvim-web-devicons" },
		},
		{ "sindrets/diffview.nvim", requires = "nvim-lua/plenary.nvim" },
	})

	-- [[ COMPLETION ]]
	use({
		"L3MON4D3/LuaSnip",
		"hrsh7th/cmp-buffer",
		"hrsh7th/cmp-cmdline",
		"hrsh7th/cmp-path",
		"hrsh7th/nvim-cmp",
		"onsails/lspkind.nvim",
		"saadparwaiz1/cmp_luasnip",
		{ "petertriho/cmp-git", requires = "nvim-lua/plenary.nvim" },
	})

	use({ "Exafunction/codeium.vim" })
	use({ "glacambre/firenvim", run = function() vim.fn["firenvim#install"](1) end })

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
