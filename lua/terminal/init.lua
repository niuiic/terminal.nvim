local static = require("terminal.static")

local open = function(bufnr)
	bufnr = bufnr ~= nil and bufnr or vim.api.nvim_create_buf(true, false)
	vim.api.nvim_set_current_buf(bufnr)
	vim.cmd("term")
	vim.cmd("startinsert")
	static.config.on_term_opened(bufnr)
end

local setup = function(new_config)
	static.config = vim.tbl_deep_extend("force", static.config, new_config or {})
end

return {
	setup = setup,
	open = open,
}