-- "Average" color schemes
--
-- This script will load color schemes supplied in "Hyperparameters",
-- compute average color scheme (compute median attribute value of highlight
-- groups present in all color schemes) and save it under configurable name in
-- configurable directory.
--
-- Dependencies (ideally only these plugins should be loaded):
-- - https://github.com/echasnovski/mini.nvim/blob/main/readmes/mini-colors.md
--   (for color scheme manipulations)
--
-- - Reference color scheme plugins.
--   Supplied lists contain top 5 popular Lua Neovim color schemes. This is how
--   they were chosen:
--     - Go through https://github.com/rockerBOO/awesome-neovim.
--     - Pick top 5 Lua implemented color schemes with most stars which are
--       not repeating.
--
--     Final list (as of 2023-04-20):
--     | Color scheme                | Stargazers |
--     |-----------------------------|------------|
--     | folke/tokyonight.nvim       | 3476 stars |
--     | catppuccin/nvim             | 2639 stars |
--     | rebelot/kanagawa.nvim       | 2219 stars |
--     | EdenEast/nightfox.nvim      | 2055 stars |
--     | projekt0n/github-nvim-theme | 1379 stars |
--
-- Notes:
-- - Original list was made also accounting for Vimscript color schemes
--   with Neovim relevant highlight groups.
--   This included 'sainnhe/everforest' (1815 stars) as the fifth color scheme.
--   Although it is sooooooo nice, it is quite different in terms of which
--   attributes it defines for certain highlight groups. Including it instead
--   of 'projekt0n/github-nvim-theme' resulted in not very coherent output.
--   So in the end it was decided to take "top 5 **Lua** color schemes".
--
-- - Due to averaging colors using Oklab color space, sever disagreement on
--   some color attribute leads to its deasaturation (becoming more gray)

local colors = require("mini.colors")

-- Hyperparameters ------------------------------------------------------------
-- Color scheme names to average
local cs_names = {
	"base16-default-dark",
	"carbonfox",
	"catppuccin",
	"github_dark",
	"kanagawa",
	"nightfox",
	"nord",
	"onedark",
	"oxocarbon",
	"rose-pine",
	"tokyonight",
}

-- Output color scheme name
local output_name = "average_dark"

-- Output directory
local output_directory = vim.fn.stdpath("config") .. "/colors"

-- Compute average color scheme ===============================================

-- Threshold number used to decide whether to include highlight group and
-- attributes in the output. Decrease this number will increase number of
-- highlight groups at cost of also increasing number of unique colors
-- sacrificing integrity of output.
-- Other possible values:
-- local n_threshold = 0
-- local n_threshold = math.floor(0.5 * #cs_names + 0.5)
local n_threshold = #cs_names

local extract = function(arr, field)
	local res = {}
	-- NOTE: use `pairs` instead of `ipairs` because there might be
	-- non-consecutive fields
	for _, v in pairs(arr) do
		if type(v) == "table" and v[field] ~= nil then
			table.insert(res, v[field])
		end
	end
	return res
end

local should_ignore = function(arr)
	-- Average only if operands are present with at least threshold number amount
	local n = vim.tbl_count(arr)
	return n == 0 or n < n_threshold
end

local median_numeric = function(arr)
	local t, n = vim.deepcopy(arr), #arr
	table.sort(t)
	-- Distinguish between even and odd sample size
	if n % 2 == 0 then
		return 0.5 * (t[0.5 * n] + t[0.5 * n + 1])
	else
		return t[0.5 * (n + 1)]
	end
end

local median_hex = function(hex_tbl)
	if should_ignore(hex_tbl) then
		return nil
	end

	local lab_tbl = vim.tbl_map(function(x) return colors.convert(x, "oklab") end, hex_tbl)

	local lab_res = {
		l = median_numeric(extract(lab_tbl, "l")),
		a = median_numeric(extract(lab_tbl, "a")),
		b = median_numeric(extract(lab_tbl, "b")),
	}

	-- Using `gamut_clip = 'cusp'` makes better lightness/chroma balance
	return colors.convert(lab_res, "hex", { gamut_clip = "cusp" })
end

local median_boolean = function(bool_tbl)
	if should_ignore(bool_tbl) then
		return nil
	end

	local n_true = 0
	for _, v in pairs(bool_tbl) do
		if v == true then
			n_true = n_true + 1
		end
	end

	-- Attribute is true if present in all reference color schemes
	-- Otherwise return `nil` to not explicitly include boolean attribute
	if n_threshold <= n_true then
		return true
	end
	return nil
end

--stylua: ignore
local median_hl_group = function(gr_tbl)
  if should_ignore(gr_tbl) then return nil end

  local res = {
    fg = median_hex(extract(gr_tbl, 'fg')),
    bg = median_hex(extract(gr_tbl, 'bg')),
    sp = median_hex(extract(gr_tbl, 'sp')),

    bold= median_boolean(extract(gr_tbl, 'bold')),
    italic= median_boolean(extract(gr_tbl, 'italic')),
    nocombine= median_boolean(extract(gr_tbl, 'nocombine')),
    reverse= median_boolean(extract(gr_tbl, 'reverse')),
    standout= median_boolean(extract(gr_tbl, 'standout')),
    strikethrough = median_boolean(extract(gr_tbl, 'strikethrough')),
    undercurl= median_boolean(extract(gr_tbl, 'undercurl')),
    underdashed   = median_boolean(extract(gr_tbl, 'underdashed')),
    underdotted   = median_boolean(extract(gr_tbl, 'underdotted')),
    underdouble   = median_boolean(extract(gr_tbl, 'underdouble')),
    underline= median_boolean(extract(gr_tbl, 'underline')),
  }

  -- Don't clear highlight group
  if vim.tbl_count(res) == 0 then return nil end
  return res
end

--- @type fun(arr_arr: table<string, table<string, string>>): table<string>
local union = function(arr_arr)
	local value_is_present = {}
	for _, arr in pairs(arr_arr) do
		for _, x in pairs(arr) do
			value_is_present[x] = true
		end
	end
	return vim.tbl_keys(value_is_present)
end

local average_colorschemes = function(cs_arr)
	local groups = extract(cs_arr, "groups")

	local all_group_names = union(vim.tbl_map(vim.tbl_keys, groups))
	local res_groups = {}
	for _, hl_name in pairs(all_group_names) do
		res_groups[hl_name] = median_hl_group(extract(groups, hl_name))
	end

	return colors
		.as_colorscheme({ name = output_name, groups = res_groups })
		:add_cterm_attributes()
		:add_terminal_colors()
end

-- Compute and save average color scheme ======================================
local cs_array = vim.tbl_map(
	function(name) return colors.get_colorscheme(name):compress():resolve_links() end,
	cs_names
)
local average_cs = average_colorschemes(cs_array)

average_cs:write({ name = output_name, directory = output_directory })
