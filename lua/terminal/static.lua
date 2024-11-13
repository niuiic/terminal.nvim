local config = {
	get_cmd = function()
		return "terminal"
	end,
	---@type fun(bufnr: number | nil): boolean
	on_term_to_open = function()
		return true
	end,
	---@type fun(bufnr: number, pid: number, channel: number)
	on_term_opened = function() end,
}

return {
	config = config,
}
