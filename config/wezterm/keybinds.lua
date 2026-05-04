local M = {}
local wezterm = require("wezterm")
local act = wezterm.action
local utils = require("utils")

---------------------------------------------------------------
--- keybinds
---------------------------------------------------------------
M.tmux_keybinds = {
	{
		key = "b",
		mods = "CMD",
		action = act.Multiple({
			act.SendString("\x07"),
			act.ActivateKeyTable({
				name = "tmux_prefix",
				one_shot = true,
				timeout_milliseconds = 3000,
			}),
		}),
	},
	{ key = "t", mods = "CMD",      action = act({ SpawnTab = "CurrentPaneDomain" }) },
	-- { key = "j", mods = "ALT",      action = act({ CloseCurrentTab = { confirm = true } }) },
	-- { key = "h", mods = "ALT",      action = act({ ActivateTabRelative = -1 }) },
	-- { key = "l", mods = "ALT",      action = act({ ActivateTabRelative = 1 }) },
	-- { key = "h", mods = "ALT|CTRL", action = act({ MoveTabRelative = -1 }) },
	-- { key = "l", mods = "ALT|CTRL", action = act({ MoveTabRelative = 1 }) },
	--{ key = "k", mods = "ALT|CTRL", action = act.ActivateCopyMode },
	-- {
	-- 	key = "k",
	-- 	mods = "ALT|CTRL",
	-- 	action = act.Multiple({ act.CopyMode("ClearSelectionMode"), act.ActivateCopyMode, act.ClearSelection }),
	-- },
	-- { key = "j",     mods = "ALT|CTRL",       action = act({ PasteFrom = "PrimarySelection" }) },
	{ key = "1",     mods = "CMD",            action = act({ ActivateTab = 0 }) },
	{ key = "2",     mods = "CMD",            action = act({ ActivateTab = 1 }) },
	{ key = "3",     mods = "CMD",            action = act({ ActivateTab = 2 }) },
	{ key = "4",     mods = "CMD",            action = act({ ActivateTab = 3 }) },
	{ key = "5",     mods = "CMD",            action = act({ ActivateTab = 4 }) },
	{ key = "6",     mods = "CMD",            action = act({ ActivateTab = 5 }) },
	-- { key = "7",     mods = "CMD",            action = act({ ActivateTab = 6 }) },
	-- { key = "8",     mods = "CMD",            action = act({ ActivateTab = 7 }) },
	-- { key = "9",     mods = "CMD",            action = act({ ActivateTab = 8 }) },
	-- { key = "-",     mods = "ALT",            action = act({ SplitVertical = { domain = "CurrentPaneDomain" } }) },
	-- { key = "\\",    mods = "ALT",            action = act({ SplitHorizontal = { domain = "CurrentPaneDomain" } }) },
	-- { key = "h",     mods = "ALT|SHIFT",      action = act({ ActivatePaneDirection = "Left" }) },
	-- { key = "l",     mods = "ALT|SHIFT",      action = act({ ActivatePaneDirection = "Right" }) },
	-- { key = "k",     mods = "ALT|SHIFT",      action = act({ ActivatePaneDirection = "Up" }) },
	-- { key = "j",     mods = "ALT|SHIFT",      action = act({ ActivatePaneDirection = "Down" }) },
	-- { key = "h",     mods = "ALT|SHIFT|CTRL", action = act({ AdjustPaneSize = { "Left", 1 } }) },
	-- { key = "l",     mods = "ALT|SHIFT|CTRL", action = act({ AdjustPaneSize = { "Right", 1 } }) },
	-- { key = "k",     mods = "ALT|SHIFT|CTRL", action = act({ AdjustPaneSize = { "Up", 1 } }) },
	-- { key = "j",     mods = "ALT|SHIFT|CTRL", action = act({ AdjustPaneSize = { "Down", 1 } }) },
	-- { key = "Enter", mods = "ALT",            action = "QuickSelect" },
	-- { key = "/",     mods = "ALT",            action = act.Search("CurrentSelectionOrEmptyString") },
}

M.default_keybinds = {
	{ key = "c",        mods = "CMD", action = act({ CopyTo = "Clipboard" }) },
	{ key = "v",        mods = "CMD", action = act({ PasteFrom = "Clipboard" }) },
	-- { key = "Insert",   mods = "SHIFT",      action = act({ PasteFrom = "PrimarySelection" }) },
	-- { key = "=",        mods = "CTRL",       action = "ResetFontSize" },
	-- { key = "+",        mods = "CTRL|SHIFT", action = "IncreaseFontSize" },
	-- { key = "-",        mods = "CTRL",       action = "DecreaseFontSize" },
	-- { key = "PageUp",   mods = "ALT",        action = act({ ScrollByPage = -1 }) },
	-- { key = "PageDown", mods = "ALT",        action = act({ ScrollByPage = 1 }) },
	-- { key = "b",        mods = "ALT",        action = act({ ScrollByPage = -1 }) },
	-- { key = "f",        mods = "ALT",        action = act({ ScrollByPage = 1 }) },
	-- { key = "z",        mods = "ALT",        action = "ReloadConfiguration" },
	-- { key = "z",        mods = "ALT|SHIFT",  action = act({ EmitEvent = "toggle-tmux-keybinds" }) },
	-- { key = "e",        mods = "ALT",        action = act({ EmitEvent = "trigger-nvim-with-scrollback" }) },
	-- { key = "q",        mods = "ALT",        action = act({ CloseCurrentPane = { confirm = true } }) },
	-- { key = "x",        mods = "ALT",        action = act({ CloseCurrentPane = { confirm = true } }) },
	-- { key = "a",        mods = "ALT",        action = wezterm.action.ShowLauncher },
	-- { key = " ",        mods = "ALT",        action = wezterm.action.ShowTabNavigator },
	-- { key = "d",        mods = "ALT|SHIFT",  action = wezterm.action.ShowDebugOverlay },
	-- {
	-- 	key = "r",
	-- 	mods = "ALT",
	-- 	action = act({
	-- 		ActivateKeyTable = {
	-- 			name = "resize_pane",
	-- 			one_shot = false,
	-- 			timeout_milliseconds = 3000,
	-- 			replace_current = false,
	-- 		},
	-- 	}),
	-- },
	-- {
	-- 	key = "s",
	-- 	mods = "ALT",
	-- 	action = act.PaneSelect({
	-- 		alphabet = "1234567890",
	-- 	})
	-- },
	-- {
	-- 	key = "`",
	-- 	mods = "ALT",
	-- 	action = act.RotatePanes("CounterClockwise"),
	-- },
	-- { key = "`", mods = "ALT|SHIFT", action = act.RotatePanes("Clockwise") },
	-- {
	-- 	key = "E",
	-- 	mods = "ALT|SHIFT",
	-- 	action = act.PromptInputLine({
	-- 		description = "Enter new name for tab",
	-- 		-- selene: allow(unused_variable)
	-- 		---@diagnostic disable-next-line: unused-local
	-- 		action = wezterm.action_callback(function(window, pane, line)
	-- 			-- line will be `nil` if they hit escape without entering anything
	-- 			-- An empty string if they just hit enter
	-- 			-- Or the actual line of text they wrote
	-- 			if line then
	-- 				window:active_tab():set_title(line)
	-- 			end
	-- 		end),
	-- 	}),
	-- },
}

function M.create_keybinds()
	return utils.merge_lists(M.default_keybinds, M.tmux_keybinds)
end

local function tmux_prefix_key(key)
	return act.SendString(key)
end

local function tmux_prefix_send_key(key, mods)
	return act.SendKey({ key = key, mods = mods or "NONE" })
end

local function pop_key_table_after(action)
	return act.Multiple({
		action,
		act.PopKeyTable,
	})
end

local function activate_tmux_copy_mode()
	return act.ActivateKeyTable({
		name = "tmux_copy_mode",
		one_shot = false,
		replace_current = true,
		timeout_milliseconds = 600000,
	})
end

local function activate_tmux_copy_prompt()
	return act.ActivateKeyTable({
		name = "tmux_copy_prompt",
		one_shot = false,
		timeout_milliseconds = 120000,
	})
end

local function activate_tmux_copy_prompt_once()
	return act.ActivateKeyTable({
		name = "tmux_copy_prompt_once",
		one_shot = true,
		timeout_milliseconds = 30000,
	})
end

local function create_tmux_prefix_key_table()
	local keys = {}

	local function send_action(key, action, mods)
		table.insert(keys, {
			key = key,
			mods = mods or "NONE",
			action = action,
		})
	end

	local function send_string(key, value, mods)
		table.insert(keys, {
			key = key,
			mods = mods or "NONE",
			action = tmux_prefix_key(value or key),
		})
	end

	local function send_key(key, mods, send_mods)
		table.insert(keys, {
			key = key,
			mods = mods or "NONE",
			action = tmux_prefix_send_key(key, send_mods or mods or "NONE"),
		})
	end

	local function send_physical_key(key, send_key_name, mods, send_mods)
		table.insert(keys, {
			key = "phys:" .. key,
			mods = mods or "NONE",
			action = tmux_prefix_send_key(send_key_name or key, send_mods or mods or "NONE"),
		})
	end

	-- Forward printable prefix keys to tmux. This covers tmux defaults such as
	-- z, [, ], :, ?, ", %, digits, pane/window selectors, and plugin bindings.
	send_string("Space", " ")
	for i = 33, 126 do
		local key = string.char(i)
		if key ~= "[" then
			send_string(key)
		end

		-- Some keyboard layouts/reporting modes include SHIFT in the key event
		-- for uppercase letters and shifted punctuation.
		if key ~= "[" and (key:match("%u") or key:match("%p")) then
			send_string(key, key, "SHIFT")
		end
	end

	local enter_tmux_copy_mode = act.Multiple({
		tmux_prefix_key("["),
		activate_tmux_copy_mode(),
	})
	send_action("[", enter_tmux_copy_mode)
	send_action("[", enter_tmux_copy_mode, "SHIFT")

	for i = 97, 122 do
		send_string(string.char(i), string.char(i - 96), "CTRL")
		send_key(string.char(i), "ALT")
	end

	for i = 65, 90 do
		local key = string.char(i)
		send_key(key, "ALT")
		send_key(key, "ALT|SHIFT", "ALT|SHIFT")
	end

	for i = 48, 57 do
		send_key(string.char(i), "ALT")
	end

	for _, key in ipairs({ "UpArrow", "DownArrow", "LeftArrow", "RightArrow" }) do
		send_key(key)
		send_key(key, "CTRL")
		send_key(key, "ALT")
		send_key(key, "SHIFT")
	end

	send_action(
		"PageUp",
		act.Multiple({
			tmux_prefix_send_key("PageUp"),
			activate_tmux_copy_mode(),
		})
	)
	send_key("PageDown")
	send_key("Backspace")
	send_physical_key("Delete")
	send_key("Escape")
	send_key("Enter")
	send_key("Tab")

	return keys
end

local function create_tmux_copy_prompt_key_table(pop_on_submit)
	local keys = {}

	local function send_string(key, value, mods)
		table.insert(keys, {
			key = key,
			mods = mods or "NONE",
			action = tmux_prefix_key(value or key),
		})
	end

	local function send_string_and_pop(key, value, mods)
		table.insert(keys, {
			key = key,
			mods = mods or "NONE",
			action = pop_key_table_after(tmux_prefix_key(value or key)),
		})
	end

	local function send_key(key, mods, send_mods)
		table.insert(keys, {
			key = key,
			mods = mods or "NONE",
			action = tmux_prefix_send_key(key, send_mods or mods or "NONE"),
		})
	end

	local function send_key_and_pop(key, mods, send_mods)
		table.insert(keys, {
			key = key,
			mods = mods or "NONE",
			action = pop_key_table_after(tmux_prefix_send_key(key, send_mods or mods or "NONE")),
		})
	end

	local function send_physical_key(key, send_key_name, mods, send_mods)
		table.insert(keys, {
			key = "phys:" .. key,
			mods = mods or "NONE",
			action = tmux_prefix_send_key(send_key_name or key, send_mods or mods or "NONE"),
		})
	end

	send_string("Space", " ")
	for i = 33, 126 do
		local key = string.char(i)
		send_string(key)

		if key:match("%u") or key:match("%p") then
			send_string(key, key, "SHIFT")
		end
	end

	for i = 97, 122 do
		local key = string.char(i)
		if pop_on_submit and key == "c" then
			send_string_and_pop(key, string.char(i - 96), "CTRL")
		else
			send_string(key, string.char(i - 96), "CTRL")
		end
		send_key(key, "ALT")
	end

	for _, key in ipairs({ "UpArrow", "DownArrow", "LeftArrow", "RightArrow" }) do
		send_key(key)
		send_key(key, "CTRL")
		send_key(key, "ALT")
		send_key(key, "SHIFT")
	end

	send_key("PageUp")
	send_key("PageDown")
	send_key("Home")
	send_key("End")
	send_key("Backspace")
	send_physical_key("Delete")
	if pop_on_submit then
		send_key_and_pop("Escape")
		send_key_and_pop("Enter")
	else
		send_key("Escape")
		send_key("Enter")
	end
	send_key("Tab")

	return keys
end

local function create_tmux_copy_mode_key_table()
	local keys = {}
	local exit_strings = {
		A = true,
		D = true,
		q = true,
		y = true,
	}
	local multi_prompt_strings = {
		["/"] = true,
		["?"] = true,
		[":"] = true,
		["1"] = true,
		["2"] = true,
		["3"] = true,
		["4"] = true,
		["5"] = true,
		["6"] = true,
		["7"] = true,
		["8"] = true,
		["9"] = true,
	}
	local one_key_prompt_strings = {
		F = true,
		T = true,
		f = true,
		t = true,
	}

	local function copy_mode_action_for_string(key, value)
		local action = tmux_prefix_key(value or key)
		if multi_prompt_strings[key] then
			return act.Multiple({
				action,
				activate_tmux_copy_prompt(),
			})
		end
		if one_key_prompt_strings[key] then
			return act.Multiple({
				action,
				activate_tmux_copy_prompt_once(),
			})
		end
		if exit_strings[key] then
			return pop_key_table_after(action)
		end
		return action
	end

	local function send_string(key, value, mods)
		table.insert(keys, {
			key = key,
			mods = mods or "NONE",
			action = copy_mode_action_for_string(key, value),
		})
	end

	local function send_control_string(key, value)
		table.insert(keys, {
			key = key,
			mods = "CTRL",
			action = tmux_prefix_key(value),
		})
	end

	local function send_key(key, mods, send_mods)
		table.insert(keys, {
			key = key,
			mods = mods or "NONE",
			action = tmux_prefix_send_key(key, send_mods or mods or "NONE"),
		})
	end

	local function send_key_and_pop(key, mods, send_mods)
		table.insert(keys, {
			key = key,
			mods = mods or "NONE",
			action = pop_key_table_after(tmux_prefix_send_key(key, send_mods or mods or "NONE")),
		})
	end

	local function send_physical_key(key, send_key_name, mods, send_mods)
		table.insert(keys, {
			key = "phys:" .. key,
			mods = mods or "NONE",
			action = tmux_prefix_send_key(send_key_name or key, send_mods or mods or "NONE"),
		})
	end

	send_string("Space", " ")
	for i = 33, 126 do
		local key = string.char(i)
		send_string(key)

		if key:match("%u") or key:match("%p") then
			send_string(key, key, "SHIFT")
		end
	end

	for i = 97, 122 do
		local key = string.char(i)
		if key == "c" or key == "j" then
			table.insert(keys, {
				key = key,
				mods = "CTRL",
				action = pop_key_table_after(tmux_prefix_key(string.char(i - 96))),
			})
		else
			send_control_string(key, string.char(i - 96))
		end
		send_key(key, "ALT")
	end

	for i = 65, 90 do
		local key = string.char(i)
		send_key(key, "ALT")
		send_key(key, "ALT|SHIFT", "ALT|SHIFT")
	end

	for i = 48, 57 do
		send_key(string.char(i), "ALT")
	end

	for _, key in ipairs({ "UpArrow", "DownArrow", "LeftArrow", "RightArrow" }) do
		send_key(key)
		send_key(key, "CTRL")
		send_key(key, "ALT")
		send_key(key, "SHIFT")
	end

	send_key("PageUp")
	send_key("PageDown")
	send_key("Home")
	send_key("End")
	send_key("Backspace")
	send_physical_key("Delete")
	send_key("Escape")
	send_key_and_pop("Enter")
	send_key("Tab")

	return keys
end

M.key_tables = {
	tmux_prefix = create_tmux_prefix_key_table(),
	tmux_copy_mode = create_tmux_copy_mode_key_table(),
	tmux_copy_prompt = create_tmux_copy_prompt_key_table(true),
	tmux_copy_prompt_once = create_tmux_copy_prompt_key_table(false),
}

-- M.key_tables = {
-- 	resize_pane = {
-- 		{ key = "LeftArrow",  action = act({ AdjustPaneSize = { "Left", 1 } }) },
-- 		{ key = "h",          action = act({ AdjustPaneSize = { "Left", 1 } }) },
-- 		{ key = "RightArrow", action = act({ AdjustPaneSize = { "Right", 1 } }) },
-- 		{ key = "l",          action = act({ AdjustPaneSize = { "Right", 1 } }) },
-- 		{ key = "UpArrow",    action = act({ AdjustPaneSize = { "Up", 1 } }) },
-- 		{ key = "k",          action = act({ AdjustPaneSize = { "Up", 1 } }) },
-- 		{ key = "DownArrow",  action = act({ AdjustPaneSize = { "Down", 1 } }) },
-- 		{ key = "j",          action = act({ AdjustPaneSize = { "Down", 1 } }) },
-- 		-- Cancel the mode by pressing escape
-- 		{ key = "Escape",     action = "PopKeyTable" },
-- 	},
-- 	copy_mode = {
-- 		{
-- 			key = "Escape",
-- 			mods = "NONE",
-- 			action = act.Multiple({
-- 				act.ClearSelection,
-- 				act.CopyMode("ClearPattern"),
-- 				act.CopyMode("Close"),
-- 			}),
-- 		},
-- 		{ key = "q",          mods = "NONE",  action = act.CopyMode("Close") },
-- 		-- move cursor
-- 		{ key = "h",          mods = "NONE",  action = act.CopyMode("MoveLeft") },
-- 		{ key = "LeftArrow",  mods = "NONE",  action = act.CopyMode("MoveLeft") },
-- 		{ key = "j",          mods = "NONE",  action = act.CopyMode("MoveDown") },
-- 		{ key = "DownArrow",  mods = "NONE",  action = act.CopyMode("MoveDown") },
-- 		{ key = "k",          mods = "NONE",  action = act.CopyMode("MoveUp") },
-- 		{ key = "UpArrow",    mods = "NONE",  action = act.CopyMode("MoveUp") },
-- 		{ key = "l",          mods = "NONE",  action = act.CopyMode("MoveRight") },
-- 		{ key = "RightArrow", mods = "NONE",  action = act.CopyMode("MoveRight") },
-- 		-- move word
-- 		{ key = "RightArrow", mods = "ALT",   action = act.CopyMode("MoveForwardWord") },
-- 		{ key = "f",          mods = "ALT",   action = act.CopyMode("MoveForwardWord") },
-- 		{ key = "\t",         mods = "NONE",  action = act.CopyMode("MoveForwardWord") },
-- 		{ key = "w",          mods = "NONE",  action = act.CopyMode("MoveForwardWord") },
-- 		{ key = "LeftArrow",  mods = "ALT",   action = act.CopyMode("MoveBackwardWord") },
-- 		{ key = "b",          mods = "ALT",   action = act.CopyMode("MoveBackwardWord") },
-- 		{ key = "\t",         mods = "SHIFT", action = act.CopyMode("MoveBackwardWord") },
-- 		{ key = "b",          mods = "NONE",  action = act.CopyMode("MoveBackwardWord") },
-- 		{
-- 			key = "e",
-- 			mods = "NONE",
-- 			action = act({
-- 				Multiple = {
-- 					act.CopyMode("MoveRight"),
-- 					act.CopyMode("MoveForwardWord"),
-- 					act.CopyMode("MoveLeft"),
-- 				},
-- 			}),
-- 		},
-- 		-- move start/end
-- 		{ key = "0",  mods = "NONE",  action = act.CopyMode("MoveToStartOfLine") },
-- 		{ key = "\n", mods = "NONE",  action = act.CopyMode("MoveToStartOfNextLine") },
-- 		{ key = "$",  mods = "SHIFT", action = act.CopyMode("MoveToEndOfLineContent") },
-- 		{ key = "$",  mods = "NONE",  action = act.CopyMode("MoveToEndOfLineContent") },
-- 		{ key = "e",  mods = "CTRL",  action = act.CopyMode("MoveToEndOfLineContent") },
-- 		{ key = "m",  mods = "ALT",   action = act.CopyMode("MoveToStartOfLineContent") },
-- 		{ key = "^",  mods = "SHIFT", action = act.CopyMode("MoveToStartOfLineContent") },
-- 		{ key = "^",  mods = "NONE",  action = act.CopyMode("MoveToStartOfLineContent") },
-- 		{ key = "a",  mods = "CTRL",  action = act.CopyMode("MoveToStartOfLineContent") },
-- 		-- select
-- 		{ key = " ",  mods = "NONE",  action = act.CopyMode({ SetSelectionMode = "Cell" }) },
-- 		{ key = "v",  mods = "NONE",  action = act.CopyMode({ SetSelectionMode = "Cell" }) },
-- 		{
-- 			key = "v",
-- 			mods = "SHIFT",
-- 			action = act({
-- 				Multiple = {
-- 					act.CopyMode("MoveToStartOfLineContent"),
-- 					act.CopyMode({ SetSelectionMode = "Cell" }),
-- 					act.CopyMode("MoveToEndOfLineContent"),
-- 				},
-- 			}),
-- 		},
-- 		-- copy
-- 		{
-- 			key = "y",
-- 			mods = "NONE",
-- 			action = act({
-- 				Multiple = {
-- 					act({ CopyTo = "ClipboardAndPrimarySelection" }),
-- 					act.CopyMode("Close"),
-- 				},
-- 			}),
-- 		},
-- 		{
-- 			key = "y",
-- 			mods = "SHIFT",
-- 			action = act({
-- 				Multiple = {
-- 					act.CopyMode({ SetSelectionMode = "Cell" }),
-- 					act.CopyMode("MoveToEndOfLineContent"),
-- 					act({ CopyTo = "ClipboardAndPrimarySelection" }),
-- 					act.CopyMode("Close"),
-- 				},
-- 			}),
-- 		},
-- 		-- scroll
-- 		{ key = "G",        mods = "SHIFT", action = act.CopyMode("MoveToScrollbackBottom") },
-- 		{ key = "G",        mods = "NONE",  action = act.CopyMode("MoveToScrollbackBottom") },
-- 		{ key = "g",        mods = "NONE",  action = act.CopyMode("MoveToScrollbackTop") },
-- 		{ key = "H",        mods = "NONE",  action = act.CopyMode("MoveToViewportTop") },
-- 		{ key = "H",        mods = "SHIFT", action = act.CopyMode("MoveToViewportTop") },
-- 		{ key = "M",        mods = "NONE",  action = act.CopyMode("MoveToViewportMiddle") },
-- 		{ key = "M",        mods = "SHIFT", action = act.CopyMode("MoveToViewportMiddle") },
-- 		{ key = "L",        mods = "NONE",  action = act.CopyMode("MoveToViewportBottom") },
-- 		{ key = "L",        mods = "SHIFT", action = act.CopyMode("MoveToViewportBottom") },
-- 		{ key = "o",        mods = "NONE",  action = act.CopyMode("MoveToSelectionOtherEnd") },
-- 		{ key = "O",        mods = "NONE",  action = act.CopyMode("MoveToSelectionOtherEndHoriz") },
-- 		{ key = "O",        mods = "SHIFT", action = act.CopyMode("MoveToSelectionOtherEndHoriz") },
-- 		{ key = "PageUp",   mods = "NONE",  action = act.CopyMode("PageUp") },
-- 		{ key = "PageDown", mods = "NONE",  action = act.CopyMode("PageDown") },
-- 		{ key = "b",        mods = "CTRL",  action = act.CopyMode("PageUp") },
-- 		{ key = "f",        mods = "CTRL",  action = act.CopyMode("PageDown") },
-- 		{
-- 			key = "Enter",
-- 			mods = "NONE",
-- 			action = act.CopyMode("ClearSelectionMode"),
-- 		},
-- 		-- search
-- 		{ key = "/", mods = "NONE", action = act.Search("CurrentSelectionOrEmptyString") },
-- 		{
-- 			key = "n",
-- 			mods = "NONE",
-- 			action = act.Multiple({
-- 				act.CopyMode("NextMatch"),
-- 				act.CopyMode("ClearSelectionMode"),
-- 			}),
-- 		},
-- 		{
-- 			key = "N",
-- 			mods = "SHIFT",
-- 			action = act.Multiple({
-- 				act.CopyMode("PriorMatch"),
-- 				act.CopyMode("ClearSelectionMode"),
-- 			}),
-- 		},
-- 	},
-- 	search_mode = {
-- 		{ key = "Escape", mods = "NONE", action = act.CopyMode("Close") },
-- 		{
-- 			key = "Enter",
-- 			mods = "NONE",
-- 			action = act.Multiple({
-- 				act.CopyMode("ClearSelectionMode"),
-- 				act.ActivateCopyMode,
-- 			}),
-- 		},
-- 		{ key = "p",      mods = "CTRL", action = act.CopyMode("PriorMatch") },
-- 		{ key = "n",      mods = "CTRL", action = act.CopyMode("NextMatch") },
-- 		{ key = "r",      mods = "CTRL", action = act.CopyMode("CycleMatchType") },
-- 		{ key = "/",      mods = "NONE", action = act.CopyMode("ClearPattern") },
-- 		{ key = "u",      mods = "CTRL", action = act.CopyMode("ClearPattern") },
-- 	},
-- }

M.mouse_bindings = {
	{
		event = { Up = { streak = 1, button = "Left" } },
		mods = "NONE",
		action = act({ CompleteSelection = "PrimarySelection" }),
	},
	{
		event = { Up = { streak = 1, button = "Right" } },
		mods = "NONE",
		action = act({ CompleteSelection = "Clipboard" }),
	},
	{
		event = { Up = { streak = 1, button = "Left" } },
		mods = "CTRL",
		action = "OpenLinkAtMouseCursor",
	},
	-- {
	-- 	event = { Up = { streak = 1, button = 'Middle' } },
	-- 	mods = 'NONE',
	-- 	action = act({ PasteFrom = "PrimarySelection" })
	-- },
	-- {
	-- 	event = { Down = { streak = 1, button = 'Middle' } },
	-- 	mods = 'NONE',
	-- 	action = act.DisableDefaultAssignment
	-- },
}

return M
