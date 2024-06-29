local M = {}
local wezterm = require("wezterm")
local act = wezterm.action
local utils = require("utils")

M.tmux_keybinds = {
	{ key = "b", mods = "CMD",      action =  wezterm.action.SendString("\x07") },
	{ key = "t", mods = "CMD",      action = act({ SpawnTab = "CurrentPaneDomain" }) },
	{ key = "1",     mods = "CMD",            action = act({ ActivateTab = 0 }) },
	{ key = "2",     mods = "CMD",            action = act({ ActivateTab = 1 }) },
	{ key = "3",     mods = "CMD",            action = act({ ActivateTab = 2 }) },
	{ key = "4",     mods = "CMD",            action = act({ ActivateTab = 3 }) },
	{ key = "5",     mods = "CMD",            action = act({ ActivateTab = 4 }) },
	{ key = "6",     mods = "CMD",            action = act({ ActivateTab = 5 }) },
}

M.default_keybinds = {
	{ key = "c",        mods = "CMD", action = act({ CopyTo = "Clipboard" }) },
	{ key = "v",        mods = "CMD", action = act({ PasteFrom = "Clipboard" }) },
}

function M.create_keybinds()
	return utils.merge_lists(M.default_keybinds, M.tmux_keybinds)
end

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
}

return M
