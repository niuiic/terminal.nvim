local static = require("terminal.static")

---@param bufnr number | nil
---@param on_term_to_open (fun(bufnr: number | nil): boolean) | nil
---@param on_term_opened (fun(bufnr: number, pid: number, channel: number)) | nil
local open = function(bufnr, on_term_to_open, on_term_opened)
	on_term_to_open = on_term_to_open or static.config.on_term_to_open
	on_term_opened = on_term_opened or static.config.on_term_opened

	if on_term_to_open(bufnr) == false then
		return
	end
	bufnr = bufnr or vim.api.nvim_create_buf(true, true)
	vim.api.nvim_set_current_buf(bufnr)
	vim.cmd("term")
	vim.cmd("startinsert")
	local channel = vim.bo.channel
	local pid = vim.fn.jobpid(channel) or 0
	on_term_opened(bufnr, pid, channel)
end

local setup = function(new_config)
	static.config = vim.tbl_deep_extend("force", static.config, new_config or {})
end

return {
	setup = setup,
	open = open,
}
