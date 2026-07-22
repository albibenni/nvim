local M = {}

-- Helper to get visual selection
local function get_visual_selection()
	local _, csrow, cscol, _ = table.unpack(vim.fn.getpos("'<"))
	local _, cerow, cecol, _ = table.unpack(vim.fn.getpos("'>"))

	-- Adjust for line lengths
	local lines = vim.fn.getline(csrow, cerow)
	if #lines == 0 then
		return ""
	end

	-- Extract the text within the selected columns
	lines[#lines] = string.sub(lines[#lines], 1, cecol)
	lines[1] = string.sub(lines[1], cscol)

	return table.concat(lines, "\n")
end

function M.schedule_task()
	local selected_text = get_visual_selection()
	local current_file = vim.fn.expand("%:t")

	if not selected_text or selected_text == "" then
		vim.notify("No text selected", vim.log.levels.WARN)
		return
	end

	local token = os.getenv("TODOIST_API_TOKEN")
	if not token then
		vim.notify(
			"TODOIST_API_TOKEN environment variable is not set. Please set it in your shell.",
			vim.log.levels.ERROR
		)
		return
	end

	local curl = require("plenary.curl")

	local function parse_schedule(s)
		if not s or s == "" then
			return s
		end
		s = vim.trim(s):lower()
		if s == "tod" then
			return "today"
		end
		if s == "tom" then
			return "tomorrow"
		end

		local weeks = s:match("^(%d+)w$")
		if weeks then
			return "in " .. weeks .. " weeks"
		end

		local months = s:match("^(%d+)m$")
		if months then
			return "in " .. (tonumber(months) * 30) .. " days"
		end

		local days = s:match("^(%d+)d$")
		if days then
			return "in " .. days .. " days"
		end
		
		return s
	end

	-- 1. Prompt for task name (pre-populated with visual selection)
	vim.ui.input({ prompt = "Todoist Task: ", default = selected_text }, function(task_content)
		if not task_content or task_content == "" then
			return
		end

		-- 2. Prompt for due date
		vim.ui.input({ prompt = "Schedule for (e.g. tod, tom, 1d, 1w, 1m) [Leave empty for Inbox]: " }, function(due_string)
			due_string = parse_schedule(due_string)

			-- 3. Prompt for Priority
			local priorities = {
				{ name = "P1 (Urgent / Red)", value = 4 },
				{ name = "P2 (High / Orange)", value = 3 },
				{ name = "P3 (Medium / Blue)", value = 2 },
				{ name = "P4 (Normal / Grey)", value = 1 },
			}

			vim.ui.select(priorities, {
				prompt = "Select Priority",
				format_item = function(item)
					return item.name
				end,
			}, function(priority_item)
				if not priority_item then
					return
				end

				vim.notify("Fetching Todoist projects...", vim.log.levels.INFO)

				-- 4. Fetch Projects & Prompt
				curl.get("https://api.todoist.com/api/v1/projects", {
					headers = { Authorization = "Bearer " .. token },
					callback = vim.schedule_wrap(function(res)
						local project_options = { { name = "Default (Inbox)", id = nil } }

						if res.status == 200 then
							local body = vim.fn.json_decode(res.body)
							local projects = body.results or body
							for _, p in ipairs(projects) do
								table.insert(project_options, p)
							end
						else
							vim.notify(
								"Could not fetch projects (Status: "
									.. tostring(res.status)
									.. "). Proceeding with default Inbox.",
								vim.log.levels.WARN
							)
						end

						vim.ui.select(project_options, {
							prompt = "Select Project",
							format_item = function(item)
								return item.name
							end,
						}, function(project_item)
							if not project_item then
								return
							end

							-- 5. Submit Task
							local payload = {
								content = task_content,
								priority = priority_item.value,
								description = "File: " .. current_file,
							}

							if due_string and due_string ~= "" then
								payload.due_string = due_string
								payload.due_lang = "en"
							end

							if project_item.id then
								payload.project_id = project_item.id
							end

							vim.notify("Creating Todoist task...", vim.log.levels.INFO)

							curl.post("https://api.todoist.com/api/v1/tasks", {
								headers = {
									Authorization = "Bearer " .. token,
									["Content-Type"] = "application/json",
								},
								body = vim.fn.json_encode(payload),
								callback = vim.schedule_wrap(function(create_res)
									if create_res.status == 200 or create_res.status == 204 then
										vim.notify("✅ Task successfully added to Todoist!", vim.log.levels.INFO)
									else
										vim.notify(
											"❌ Failed to add task. Status: "
												.. tostring(create_res.status)
												.. "\n"
												.. tostring(create_res.body),
											vim.log.levels.ERROR
										)
									end
								end),
							})
						end)
					end),
				})
			end)
		end)
	end)
end

return M
