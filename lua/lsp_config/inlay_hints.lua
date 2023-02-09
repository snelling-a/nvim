local utils = require("utils")

local InlayHintsGroup = utils.augroup("InlayHints", {})
return function(client, bufnr)
	if not client.supports_method("textDocument/inlayHints") then
		return
	end

	require("lsp-inlayhints").on_attach(client, bufnr)
	-- utils.autocmd("LspAttach", {
	-- 	group = InlayHintsGroup,
	-- 	buffer = bufnr,
	-- 	callback = function(args)
	-- 		if not (args.data and args.data.client_id) then
	-- 			return
	-- 		end
	--
	-- 		require("lsp-inlayhints").on_attach(client, bufnr)
	-- 	end,
	-- })
end
