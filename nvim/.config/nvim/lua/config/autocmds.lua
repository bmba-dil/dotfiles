-- Highlighting
vim.api.nvim_create_autocmd("FileType", {
	callback = function()
		pcall(vim.treesitter.start)
	end,
})

-- tab format for certain filetypes
vim.api.nvim_create_autocmd("FileType", {
	pattern = { "lua", "yaml", "yml", "c", "cpp", "h" },
	callback = function()
		vim.opt_local.shiftwidth = 2
		vim.opt_local.tabstop = 2
		vim.opt_local.expandtab = true
	end,
})

-- Remember scroll + cursor per buffer in this window when switching buffers
local view_group = vim.api.nvim_create_augroup("user_buffer_view", { clear = true })

vim.api.nvim_create_autocmd("BufLeave", {
	group = view_group,
	callback = function(ev)
		local win = vim.api.nvim_get_current_win()
		if not vim.w[win].saved_views then
			vim.w[win].saved_views = {}
		end
		vim.w[win].saved_views[ev.buf] = vim.fn.winsaveview()
	end,
})

vim.api.nvim_create_autocmd("BufEnter", {
	group = view_group,
	callback = function(ev)
		local win = vim.api.nvim_get_current_win()
		local views = vim.w[win].saved_views
		local view = views and views[ev.buf]
		if not view then
			return
		end
		-- avoid fighting first open / diff mode awkwardness
		if vim.wo.diff then
			return
		end
		vim.schedule(function()
			if vim.api.nvim_get_current_buf() == ev.buf then
				vim.fn.winrestview(view)
			end
		end)
	end,
})
