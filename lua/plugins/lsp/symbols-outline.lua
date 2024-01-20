local desc = "Toggle outline"

---@type LazySpec
local M = { "hedyhli/outline.nvim" }

M.cmd = { "Outline", "OutlineOpen" }

M.keys = {
	{ "<leader>cs", desc = desc },
}

function M.config(_, opts)
	local outline = require("outline")
	outline.setup(opts)

	require("keymap").leader("cs", outline.toggle_outline--[[ vim.cmd.Outline ]], { desc = desc })
end

function M.opts(_, opts)
	local icons = require("ui.icons").kind_icons

	return require("util").tbl_extend_force(opts, {
		symbols = {
			icons = {
				Array = { icon = icons.Array, hl = "@constant" },
				Boolean = { icon = icons.Boolean, hl = "@boolean" },
				Class = { icon = icons.Class, hl = "@type" },
				Component = { icon = icons.Component, hl = "@function" },
				Constant = { icon = icons.Constant, hl = "@constant" },
				Constructor = { icon = icons.Constructor, hl = "@constructor" },
				Enum = { icon = icons.Enum, hl = "@type" },
				EnumMember = { icon = icons.EnumMember, hl = "@field" },
				Event = { icon = icons.Event, hl = "@type" },
				Field = { icon = icons.Field, hl = "@field" },
				File = { icon = icons.File, hl = "@text.uri" },
				Fragment = { icon = icons.Fragment, hl = "@constant" },
				Function = { icon = icons.Function, hl = "@function" },
				Interface = { icon = icons.Interface, hl = "@type" },
				Key = { icon = icons.Key, hl = "@type" },
				Macro = { icon = icons.Macro, hl = "@macro" },
				Method = { icon = icons.Method, hl = "@method" },
				Module = { icon = icons.Module, hl = "@namespace" },
				Namespace = { icon = icons.Namespace, hl = "@namespace" },
				Null = { icon = icons.Null, hl = "@type" },
				Number = { icon = icons.Number, hl = "@number" },
				Object = { icon = icons.Object, hl = "@type" },
				Operator = { icon = icons.Operator, hl = "@operator" },
				Package = { icon = icons.Package, hl = "@namespace" },
				Parameter = { icon = icons.Parameter, hl = "@parameter" },
				Property = { icon = icons.Property, hl = "@method" },
				StaticMethod = { icon = icons.StaticMethod, hl = "@function" },
				String = { icon = icons.String, hl = "@string" },
				Struct = { icon = icons.Struct, hl = "@type" },
				TypeAlias = { icon = icons.TypeAlias, hl = "@type" },
				TypeParameter = { icon = icons.TypeParameter, hl = "@parameter" },
				Variable = { icon = icons.Variable, hl = "@constant" },
			},
		},
	})
end

return M
