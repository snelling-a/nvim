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


return packer.startup(function(use)
	use({ "wbthomason/packer.nvim" })

	use({
		"glepnir/dashboard-nvim",
		-- event = "VimEnter",
		requires = { "nvim-tree/nvim-web-devicons" },
	})

	use({
		"folke/noice.nvim",
		requires = {
			"MunifTanjim/nui.nvim",
			"rcarriga/nvim-notify",
		},
	})

	use({
		"nvim-telescope/telescope.nvim",
		requires = {
			"nvim-telescope/telescope-node-modules.nvim",
			"nvim-lua/plenary.nvim",
			{
				"nvim-telescope/telescope-fzf-native.nvim",
				run = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release"
					.. "&& cmake --build build --config Release"
					.. "&& cmake --install build --prefix build",
			},
		},
	})

	use({
		"nvim-lualine/lualine.nvim",
		requires = {
			{ "kyazdani42/nvim-web-devicons" },
			{ "RRethy/nvim-base16", opt = false },
		},
	})

	use({ "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" })

	use({ "theprimeagen/harpoon" })

	use({ "numToStr/Comment.nvim" })
	use({ "kylechui/nvim-surround" })
	use({ "windwp/nvim-autopairs" })
	use({ "tpope/vim-fugitive" })
	use({ "tpope/vim-rhubarb" })
	use({ "lewis6991/gitsigns.nvim" })
	use({
		"pwntester/octo.nvim",
		requires = {
			"nvim-lua/plenary.nvim",
			"nvim-telescope/telescope.nvim",
			"kyazdani42/nvim-web-devicons",
		},
	})
	use({ "folke/zen-mode.nvim" })
	use({ "Exafunction/codeium.vim" })

	use({ "norcalli/nvim-colorizer.lua" })

	use({
		"nvim-tree/nvim-tree.lua",
		requires = {
			"nvim-tree/nvim-web-devicons",
		},
	})

	if packer_bootstrap then
		require("packer").sync()
	end
end)
