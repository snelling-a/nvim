---@type LazySpec
return {
	"stevearc/resession.nvim",
	config = function()
		local resession = require("resession")
		resession.setup({})
		local function get_session_name()
			local name = vim.fn.fnamemodify(vim.fn.getcwd(), (":s?%s??"):format(os.getenv("HOME")))
			local branch = vim.trim(vim.fn.system("git branch --show-current"))

			if vim.v.shell_error == 0 then
				return name .. branch
			else
				return name
			end
		end

		local session_dir = vim.fn.stdpath("data") .. "session"

		vim.api.nvim_create_autocmd({ "VimLeavePre" }, {
			callback = function()
				resession.save(get_session_name(), { dir = session_dir, notify = false })
			end,
		})

		local function complete()
			return resession.list({ dir = session_dir })
		end

		vim.api.nvim_create_user_command("SessionLoad", function(args)
			local session_name = args.fargs[1] or get_session_name()

			resession.load(session_name, { dir = session_dir, silence_errors = true })
		end, {
			complete = complete,
			nargs = "?",
		})

		vim.api.nvim_create_user_command("SessionDelete", function(args)
			resession.delete(args.fargs[1], { dir = session_dir, notify = true })
		end, {
			complete = complete,
			nargs = 1,
		})
	end,
}
