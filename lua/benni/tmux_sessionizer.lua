-- Put this in e.g. lua/tmux_sessionizer.lua (or directly in your config)
local M = {}

M.pick_and_switch = function()
	local pickers = require("telescope.pickers")
	local finders = require("telescope.finders")
	local conf = require("telescope.config").values
	local actions = require("telescope.actions")
	local action_state = require("telescope.actions.state")

	local home = vim.fn.expand("~")
	local roots = {
		home,
		home .. "/benni-projects",
		home .. "/work-projects",
	}

	-- Build a directory list (depth: root=1, projects=2)
	local results = {}

	local function add_dirs(root, maxdepth)
		local cmd = {
			"find",
			root,
			"-mindepth",
			"1",
			"-maxdepth",
			tostring(maxdepth),
			"-type",
			"d",
		}
		local out = vim.fn.systemlist(cmd)
		for _, p in ipairs(out) do
			if p and p ~= "" then
				table.insert(results, p)
			end
		end
	end

	-- Same spirit as your original script:
	-- - ~: depth 1
	-- - projects/work: depth 2
	add_dirs(roots[1], 1)
	add_dirs(roots[2], 2)
	add_dirs(roots[3], 2)

	if #results == 0 then
		vim.notify("No directories found", vim.log.levels.WARN)
		return
	end

	pickers
		.new({}, {
			prompt_title = "TMUX Sessionizer",
			finder = finders.new_table({ results = results }),
			sorter = conf.generic_sorter({}),
			attach_mappings = function(prompt_bufnr, _)
				actions.select_default:replace(function()
					actions.close(prompt_bufnr)
					local entry = action_state.get_selected_entry()
					local session = entry and entry[1] or entry.value
					if not session or session == "" then
						return
					end

					local session_name = vim.fn.fnamemodify(session, ":t"):gsub("%.", "_")

					-- Create session if missing, then switch to it
					-- -A: attach if exists, otherwise create
					-- -d: don't attach immediately (safe from Neovim)
					vim.fn.jobstart({ "tmux", "new-session", "-Ad", "-s", session_name, "-c", session })
					vim.fn.jobstart({ "tmux", "switch-client", "-t", session_name })
				end)
				return true
			end,
		})
		:find()
end

return M
