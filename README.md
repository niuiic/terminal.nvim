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
	---@type fun(bufnr: number | nil): boolean
	on_term_to_open = function()
		-- return false to prevent opening terminal
		return true
	end,
	---@type fun(bufnr: number, pid: number)
	on_term_opened = function() end,
}
```

It's recommended to set keymap for terminal buffer. Here is an example.

```lua
local uv = vim.loop
local terms = {}

local set_line_number = function(show_line_number)
	local options = {
		"number",
		"relativenumber",
	}
	for _, option in ipairs(options) do
		vim.api.nvim_set_option_value(option, show_line_number, {
			win = 0,
		})
	end
end

local set_keymap = function(bufnr)
	local modes = { "t", "n" }

	for _, mode in ipairs(modes) do
		vim.api.nvim_buf_set_keymap(bufnr, mode, "<C-z>", "", {
			callback = function()
				require("terminal").open()
			end,
		})

		vim.api.nvim_buf_set_keymap(bufnr, mode, "<C-x>", "", {
			callback = function()
				uv.kill(terms[bufnr], "sigkill")
				table.remove(terms, bufnr)
				vim.api.nvim_buf_delete(bufnr, {
					force = true,
				})
			end,
		})

		vim.api.nvim_buf_set_keymap(bufnr, mode, "<C-k>", "", {
			callback = function()
				-- 'akinsho/bufferline.nvim' required
				vim.cmd("BufferLineCycleNext")
			end,
		})

		vim.api.nvim_buf_set_keymap(bufnr, mode, "<C-j>", "", {
			callback = function()
				vim.cmd("BufferLineCyclePrev")
			end,
		})

		vim.api.nvim_buf_set_keymap(bufnr, mode, "<space>bh", "", {
			callback = function()
				vim.cmd("BufferLineMovePrev")
			end,
		})

		vim.api.nvim_buf_set_keymap(bufnr, mode, "<space>bl", "", {
			callback = function()
				vim.cmd("BufferLineMoveNext")
			end,
		})

		vim.api.nvim_buf_set_keymap(bufnr, mode, "<space>bo", "", {
			callback = function()
				vim.cmd("BufferLinePick")
			end,
		})

		vim.api.nvim_buf_set_keymap(bufnr, mode, "<C-q>", "", {
			callback = function()
				vim.cmd("Quit")
			end,
		})

		vim.api.nvim_buf_set_keymap(bufnr, mode, "<esc>", "", {
			callback = function()
				vim.cmd("stopinsert")
			end,
		})
	end
end

return {
	config = function()
		require("terminal").setup({
			on_term_opened = function(bufnr, pid)
				vim.api.nvim_set_option_value("filetype", "terminal", {
					buf = bufnr,
				})

				set_line_number(false)

				set_keymap(bufnr)

				terms[bufnr] = pid
			end,
		})

		vim.api.nvim_create_autocmd({ "BufEnter" }, {
			pattern = { "*" },
			callback = function(args)
				local filetype = vim.api.nvim_get_option_value("filetype", {
					buf = args.buf,
				})

				if filetype == "terminal" then
					vim.cmd("startinsert")
				end

				set_line_number(filetype ~= "terminal")
			end,
		})
	end,
	keys = {
		{
			"<C-z>",
			function()
				require("terminal").open()
			end,
			desc = "open terminal",
		},
	},
}
```
