local telescope = require("telescope")

telescope.load_extension "file_browser"
telescope.load_extension "workspaces"

function my_scroll_preview_page(prompt_bufnr, direction)
	local status = require "telescope.state".get_status(prompt_bufnr)
	status.picker.layout_config.scroll_speed = vim.api.nvim_win_get_height(status.preview_win)
	require "telescope.actions.set".scroll_previewer(prompt_bufnr, direction)
	status.picker.layout_config.scroll_speed = 1
end

function my_scroll_results_page(prompt_bufnr, direction)
	local state = require "telescope.state".get_status(prompt_bufnr)
	local picker = state.picker
	local status_updater = picker:get_status_updater(picker.prompt_win, picker.prompt_bufnr)

	picker.layout_config.scroll_speed = vim.api.nvim_win_get_height(state.layout.results.winid)
	require "telescope.actions.set".scroll_results(prompt_bufnr, direction)
	picker.layout_config.scroll_speed = 1

	status_updater {completed = true}
end

function my_get_status_text(self, opts)
	local ww = #(self:get_multi_selection())
	local xx = (self.stats.processed or 0) - (self.stats.filtered or 0)
	local yy = self.stats.processed or 0
	local status_icon = ""
	if opts and not opts.completed then
		status_icon = "*"
	end
	if xx == 0 and yy == 0 then
		return status_icon
	end
	local row = xx - (self.max_results - self:get_selection_row()) + 1
	if ww == 0 then
		return string.format("%s %s / %s / %s", status_icon, row, xx, yy)
	else
		return string.format("%s %s / %s / %s / %s", status_icon, ww, row, xx, yy)
	end
end

function my_move_selection(prompt_bufnr, direction)
	local actions = require "telescope.actions"
	local state = require "telescope.state"
	local picker = state.get_status(prompt_bufnr).picker
	local status_updater = picker:get_status_updater(picker.prompt_win, picker.prompt_bufnr)

	if direction == 1 then
		actions.move_selection_next(prompt_bufnr)
	elseif direction == -1 then
		actions.move_selection_previous(prompt_bufnr)
	end
	status_updater {completed = true}
end

telescope.setup({
  extensions = {
    workspaces = {
      -- keep insert mode after selection in the picker, default is false
      keep_insert = true,
    }
  },
  defaults = {
    get_status_text = my_get_status_text,
    layout_strategy = 'vertical',
    layout_config = {
      height = 0.95,
      prompt_position = 'bottom',
      width = 0.95,
      preview_cutoff = 5,
      preview_height = 0.6,
      scroll_speed = 1,
    },
    file_ignore_patterns = { ".cache/", "%.o", "%.so", "%.a", "%.ko", "%.tar.gz" },
    mappings = {
      i = {
	["<Up>"] = function (prompt_bufnr) my_move_selection(prompt_bufnr, -1) end,
	["<Down>"] = function (prompt_bufnr) my_move_selection(prompt_bufnr, 1) end,
        ["<PageUp>"] = function (prompt_bufnr) my_scroll_results_page(prompt_bufnr, -1) end,
        ["<PageDown>"] = function (prompt_bufnr) my_scroll_results_page(prompt_bufnr, 1) end,
        ["<C-Up>"] = require "telescope.actions".preview_scrolling_up,
        ["<C-Down>"] = require "telescope.actions".preview_scrolling_down,
        ["<C-PageUp>"] = function (prompt_bufnr) my_scroll_preview_page(prompt_bufnr, -1) end,
        ["<C-PageDown>"] = function (prompt_bufnr) my_scroll_preview_page(prompt_bufnr, 1) end,
      },
      n = {
	["<Up>"] = function (prompt_bufnr) my_move_selection(prompt_bufnr, -1) end,
	["<Down>"] = function (prompt_bufnr) my_move_selection(prompt_bufnr, 1) end,
        ["<PageUp>"] = function (prompt_bufnr) my_scroll_results_page(prompt_bufnr, -1) end,
        ["<PageDown>"] = function (prompt_bufnr) my_scroll_results_page(prompt_bufnr, 1) end,
        ["<C-Up>"] = require "telescope.actions".preview_scrolling_up,
        ["<C-Down>"] = require "telescope.actions".preview_scrolling_down,
        ["<C-PageUp>"] = function (prompt_bufnr) my_scroll_preview_page(prompt_bufnr, -1) end,
        ["<C-PageDown>"] = function (prompt_bufnr) my_scroll_preview_page(prompt_bufnr, 1) end,
      },
    }
  },
})

function my_set_tagstack()
	local tag_item = {
		tagname = vim.fn.expand('<cword>'),
		from = { vim.fn.bufnr('%'), vim.fn.line('.'), vim.fn.col('.'), 0 }
	}
	local tag_winid = vim.fn.win_getid()
	vim.fn.settagstack(tag_winid, { items = { tag_item } }, 't')
end

function my_lsp_dynamic_workspace_symbols()
	local width = vim.api.nvim_win_get_width(0) * 3 / 10

	my_set_tagstack()

	require('telescope.builtin').lsp_dynamic_workspace_symbols({fname_width=width})
end

function my_lsp_references(user_opts)
	local opts = user_opts or {}
	local width = vim.api.nvim_win_get_width(0) * 3 / 10

	opts.jump_type = "never"
	opts.fname_width = width
	require('telescope.builtin').lsp_references(opts)
end

local map = vim.api.nvim_set_keymap
default_options = {noremap = true, silent = true}

map("n", "fg", "<cmd>lua my_lsp_dynamic_workspace_symbols()<CR>", default_options)
map("n", "fb", "<cmd>Telescope buffers<CR>", default_options)
map("n", "ff", "<cmd>Telescope find_files<CR>", default_options)
map("n", "fw", "<cmd>Telescope workspaces<CR>", default_options)
map("v", "fh", "<cmd>Telescope git_bcommits_range<CR>", default_options)
map("n", "<C-\\>s", "<cmd>Telescope grep_string temp__scrolling_limit=9999<CR>", default_options)
map("n", "<C-\\>t", "<cmd>Telescope live_grep temp__scrolling_limit=9999<CR>", default_options)
map("n", "<C-\\>r", "<cmd>lua my_lsp_references({temp__scrolling_limit = 9999})<CR>", default_options)
