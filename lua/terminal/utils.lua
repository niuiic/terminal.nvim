local set_buf_options = function()
	vim.api.nvim_set_option_value("number", false, {
		win = 0,
	})
	vim.api.nvim_set_option_value("relativenumber", false, {
		win = 0,
	})
	vim.api.nvim_set_option_value("winfixwidth", true, {
		win = 0,
	})
	vim.api.nvim_set_option_value("list", false, {
		win = 0,
	})
	vim.api.nvim_set_option_value("wrap", true, {
		win = 0,
	})
	vim.api.nvim_set_option_value("linebreak", true, {
		win = 0,
	})
	vim.api.nvim_set_option_value("breakindent", true, {
		win = 0,
	})
	vim.api.nvim_set_option_value("showbreak", "      ", {
		win = 0,
	})
end

--- set keymap for terminal
---@param bufnr number
local set_buf_keymap = function(bufnr)
	vim.api.nvim_buf_set_keymap(bufnr, "t", "<C-q>", "", {
		callback = function()
			vim.api.nvim_buf_delete(bufnr, {
				force = true,
			})
		end,
	})
end

return {
	set_buf_options = set_buf_options,
	set_buf_keymap = set_buf_keymap,
}
