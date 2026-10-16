--- @since 25.12.29

local set_active = ya.sync(function(self, active) self.active = active end)

local function navigate(self, step)
	if self.active then
		ya.emit("arrow", { step })
	else
		ya.emit("input:recall", { step })
	end
end

local hovered = ya.sync(function()
	local h = cx.active.current.hovered
	if not h then
		return {}
	end

	return {
		url = h.url,
		is_dir = h.cha.is_dir,
	}
end)

local function prompt()
	return ya.input {
		title = "Go to:",
		pos = { "top-center", y = 2, w = 50 },
		realtime = true,
		debounce = 0.1,
	}
end

local function fuzzy_pattern(value)
	local parts = {}
	for _, codepoint in utf8.codes(value) do
		local char = utf8.char(codepoint)
		if ("\\.^$|?*+()[]{}"):find(char, 1, true) then
			char = "\\" .. char
		end
		parts[#parts + 1] = char
	end
	return table.concat(parts, ".*")
end

local function entry()
	local input = prompt()
	set_active(true)

	while true do
		local value, event = input:recv()
		if event ~= 1 and event ~= 3 then
			ya.emit("escape", { filter = true })
			break
		end

		ya.emit("filter_do", { fuzzy_pattern(value), smart = true })

		local h = hovered()
		if event == 1 then
			ya.emit("escape", { filter = true })
			ya.emit(h.is_dir and "enter" or "open", { h.url })
			break
		end
	end
	set_active(false)
end

return { entry = entry, navigate = navigate }
