local wezterm = require("wezterm")
local utils = require("utils")
local keybinds = require("keybinds")
local scheme = wezterm.get_builtin_color_schemes()["Teerb"]

local function create_ssh_domain_from_ssh_config(ssh_domains)
	if ssh_domains == nil then
		ssh_domains = {}
	end
	for host, config in pairs(wezterm.enumerate_ssh_hosts()) do
		table.insert(ssh_domains, {
			name = host,
			remote_address = config.hostname .. ":" .. config.port,
			username = config.user,
			multiplexing = "None",
			assume_shell = "Posix",
		})
	end
	return { ssh_domains = ssh_domains }
end

--- load local_config
-- Write settings you don't want to make public, such as ssh_domains
package.path = os.getenv("HOME") .. "/.local/share/wezterm/?.lua;" .. package.path
local function load_local_config(module)
	local m = package.searchpath(module, package.path)
	if m == nil then
		return {}
	end
	return dofile(m)
end

local local_config = load_local_config("local")

local config = {
	underline_thickness = "1.2px",
	font = wezterm.font_with_fallback({
		"Hack Nerd Font",
		"PingFang SC",
		"Noto Sans CJK SC",
		"Source Han Sans CN",
		-- "WenQuanYi Micro Hei",
		-- "Microsoft YaHei",
	}),
	font_size = 11,
	-- line_height = 1.2,
	check_for_updates = false,
	use_ime = true,
	ime_preedit_rendering = "Builtin",
	use_dead_keys = false,
	warn_about_missing_glyphs = false,
	-- enable_kitty_graphics = false,
	animation_fps = 1,
	cursor_blink_ease_in = "Constant",
	cursor_blink_ease_out = "Constant",
	cursor_blink_rate = 0,

	-- cursor_thickness = '1cell',
	force_reverse_video_cursor = true,

	color_scheme = "Teerb",
	-- color_scheme_dirs = { os.getenv("HOME") .. "/.config/wezterm/colors/" },
	hide_tab_bar_if_only_one_tab = true,
	adjust_window_size_when_changing_font_size = false,
	selection_word_boundary = " \t\n{}[]()\"'`,;:│=&!%",
	window_padding = {
		left = 0,
		right = 0,
		top = 0,
		bottom = 0,
	},
	use_fancy_tab_bar = false,
	colors = {
		background = "#282935",
		tab_bar = {
			background = "#282935",
			new_tab = { bg_color = "#282935", fg_color = scheme.ansi[8], intensity = "Bold" },
			new_tab_hover = { bg_color = scheme.ansi[1], fg_color = scheme.brights[8], intensity = "Bold" },
			-- format-tab-title
			-- active_tab = { bg_color = "#121212", fg_color = "#FCE8C3" },
			-- inactive_tab = { bg_color = scheme.background, fg_color = "#FCE8C3" },
			-- inactive_tab_hover = { bg_color = scheme.ansi[1], fg_color = "#FCE8C3" },
		},
	},
	exit_behavior = "CloseOnCleanExit",
	tab_bar_at_bottom = false,
	window_close_confirmation = "AlwaysPrompt",
	-- window_background_opacity = 0.8,
	disable_default_key_bindings = true,
	enable_csi_u_key_encoding = true,
	leader = { key = "Space", mods = "CTRL|SHIFT" },
	keys = keybinds.create_keybinds(),
	mouse_bindings = keybinds.mouse_bindings,
}

local ansi = {}
for i, color in ipairs(scheme.ansi) do
	ansi[i] = color
end

local brights = {}
for i, color in ipairs(scheme.brights) do
	brights[i] = color
end

-- brighten bright black so ls entries like *.bak stay legible
brights[1] = "#b0b0b0"

config.colors.ansi = ansi
config.colors.brights = brights

local merged_config = utils.merge_tables(config, local_config)
return utils.merge_tables(merged_config, create_ssh_domain_from_ssh_config(merged_config.ssh_domains))
