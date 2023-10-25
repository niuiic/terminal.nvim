local static = require("terminal.static")

--- open terminal
---@param bufnr number | nil
local open = function(bufnr)
	if static.config.on_term_to_open(bufnr) == false then
		return
	end
	bufnr = bufnr ~= nil and bufnr or vim.api.nvim_create_buf(true, true)
	vim.api.nvim_set_current_buf(bufnr)
	vim.cmd("term")
	vim.cmd("startinsert")
	local pid = vim.fn.jobpid(vim.o.channel) or 0
	static.config.on_term_opened(bufnr, pid)
end

local setup = function(new_config)
	static.config = vim.tbl_deep_extend("force", static.config, new_config or {})
end

return {
	setup = setup,
	open = open,
}
