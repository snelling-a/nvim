---@param bufnr integer,
---@param client vim.lsp.Client
local function sign_in(bufnr, client)
	client:request(
		---@diagnostic disable-next-line: param-type-mismatch
		"signIn",
		vim.empty_dict(),
		function(err, result)
			if err then
				vim.notify(err.message, vim.log.levels.ERROR)
				return
			end
			if result.command then
				local code = result.userCode
				local command = result.command
				vim.fn.setreg("+", code)
				vim.fn.setreg("*", code)
				local continue = vim.fn.confirm(
					"Copied your one-time code to clipboard.\n" .. "Open the browser to complete the sign-in process?",
					"&Yes\n&No"
				)
				if continue == 1 then
					client:exec_cmd(command, { bufnr = bufnr }, function(cmd_err, cmd_result)
						if cmd_err then
							vim.notify(err.message, vim.log.levels.ERROR)
							return
						end
						if cmd_result.status == "OK" then
							vim.notify("Signed in as " .. cmd_result.user .. ".")
						end
					end)
				end
			end

			if result.status == "PromptUserDeviceFlow" then
				vim.notify("Enter your one-time code " .. result.userCode .. " in " .. result.verificationUri)
			elseif result.status == "AlreadySignedIn" then
				vim.notify("Already signed in as " .. result.user .. ".")
			end
		end
	)
end

---@param client vim.lsp.Client
local function sign_out(_, client)
	client:request(
		---@diagnostic disable-next-line: param-type-mismatch
		"signOut",
		vim.empty_dict(),
		function(err, result)
			if err then
				vim.notify(err.message, vim.log.levels.ERROR)
				return
			end
			if result.status == "NotSignedIn" then
				vim.notify("Not signed in.")
			end
		end
	)
end

---@type vim.lsp.Config
return {
	cmd = {
		"copilot-language-server",
		"--stdio",
	},
	root_markers = { ".git" },
	init_options = {
		editorInfo = {
			name = "Neovim",
			version = tostring(vim.version()),
		},
		editorPluginInfo = {
			name = "Neovim",
			version = tostring(vim.version()),
		},
	},
	settings = {
		telemetry = {
			telemetryLevel = "all",
		},
	},
	on_attach = function(client, bufnr)
		vim.api.nvim_buf_create_user_command(bufnr, "LspCopilotSignIn", function()
			sign_in(bufnr, client)
		end, { desc = "Sign in Copilot with GitHub" })
		vim.api.nvim_buf_create_user_command(bufnr, "LspCopilotSignOut", function()
			sign_out(bufnr, client)
		end, { desc = "Sign out Copilot with GitHub" })

		vim.lsp.inline_completion.enable()

		vim.keymap.set({ "i" }, "<M-]>", function()
			vim.lsp.inline_completion.select({ count = 1, wrap = true })
		end, { buffer = bufnr, desc = "Next inline completion" })

		vim.keymap.set({ "i" }, "<M-[>", function()
			vim.lsp.inline_completion.select({ count = -1, wrap = true })
		end, { buffer = bufnr, desc = "Prev inline completion" })

		vim.keymap.set({ "i" }, "<Tab>", function()
			if vim.lsp.inline_completion.get() then
				return
			end
			vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Tab>", true, false, true), "n", false)
		end, { buffer = bufnr, desc = "Accept inline completion" })
	end,
}
