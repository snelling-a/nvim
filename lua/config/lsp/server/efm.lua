local EFM = {}

local settings = {}

function EFM.setup(opts)
	opts.init_options = { documentFormatting = true }
	opts.settings = settings

	require("lspconfig").efm.setup(opts)
end

return EFM
