local utils = require("terminal.utils")

local config = {
	on_term_to_open = function()
		return true
	end,
	on_term_opened = function(bufnr)
		utils.set_buf_options()
		utils.set_buf_keymap(bufnr)
	end,
}

return {
	config = config,
}
