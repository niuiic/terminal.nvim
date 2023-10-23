local config = {
	---@type fun(bufnr: number | nil): boolean
	on_term_to_open = function()
		return true
	end,
	---@type fun(bufnr: number)
	on_term_opened = function() end,
}

return {
	config = config,
}
