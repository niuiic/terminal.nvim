# terminal.nvim

Simple and highly configurable terminal plugin for neovim.

## Why this plugin

- Flexible and highly configurable (needs a little creativity and programming ability)
- Manage terminal as buffer
- Multiple terminals

If you are not interested in these, just keep with `akinsho/toggleterm.nvim` which is more mature.

## Usage

<img src="https://github.com/niuiic/assets/blob/main/terminal.nvim/usage.gif" />

- Basic usage

Open terminal with `require("terminal").open(bufnr)`.

> Open terminal in current buffer with `require("terminal").open(0)`.

> Open terminal in a new buffer with `require("terminal").open()`.

- Advanced usage

Open terminal anywhere you like.

```lua
-- open terminal vertically
local open_vs_terminal = function()
	vim.cmd("vsplit")
	require("terminal").open(0)
end

-- open terminal horizontally
local open_hs_terminal = function()
	-- set height to 50
	vim.cmd("50split")
	require("terminal").open(0)
end

-- open terminal in float window
local open_float_terminal = function()
	-- 'niuiic/core.nvim' required
	local core = require("core")

	local size = core.win.proportional_size(0.8, 0.6)

	local handle = core.win.open_float(0, {
		enter = true,
		relative = "editor",
		width = size.width,
		height = size.height,
		row = size.row,
		col = size.col,
		style = "minimal",
		border = "rounded",
		title = "terminal",
		title_pos = "center",
	})
	require("terminal").open(0)
end
```

## Config

Default configuration here.

```lua
local utils = require("terminal.utils")

local config = {
	on_term_to_open = function()
		-- return false to prevent opening terminal
		return true
	end,
	on_term_opened = function(bufnr)
		-- check lua/terminal/utils.lua
		utils.set_buf_options()
		utils.set_buf_keymap(bufnr)
	end,
}
```

It's recommended to set keymap for terminal buffer. Here is an example.

```lua
require("terminal").setup({
	on_term_opened = function(bufnr)
		require("terminal.utils").set_buf_options()

		vim.api.nvim_set_option_value("filetype", "terminal", {
			buf = bufnr,
		})

		local modes = { "t", "n" }

		for _, mode in ipairs(modes) do
			vim.api.nvim_buf_set_keymap(bufnr, mode, "<C-z>", "", {
				callback = function()
					require("terminal").open()
				end,
			})

			vim.api.nvim_buf_set_keymap(bufnr, mode, "<C-x>", "", {
				callback = function()
					vim.api.nvim_buf_delete(bufnr, {
						force = true,
					})
				end,
			})

			vim.api.nvim_buf_set_keymap(bufnr, mode, "<C-k>", "", {
				callback = function()
					-- this command comes from 'akinsho/bufferline.nvim'
					vim.cmd("BufferLineCycleNext")
				end,
			})

			vim.api.nvim_buf_set_keymap(bufnr, mode, "<C-j>", "", {
				callback = function()
					vim.cmd("BufferLineCyclePrev")
				end,
			})

			vim.api.nvim_buf_set_keymap(bufnr, mode, "<space>bo", "", {
				callback = function()
					vim.cmd("BufferLinePick")
				end,
			})

			vim.api.nvim_buf_set_keymap(bufnr, mode, "<C-q>", "", {
				callback = function()
					-- custom command
					vim.cmd("Quit")
				end,
			})
		end
	end,
})
```
