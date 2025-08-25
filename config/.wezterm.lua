local wezterm = require "wezterm"

local config = {
	colors = {background = "#111111"},
	font = wezterm.font({family = "JetBrains Mono", harfbuzz_features = {"calt=0"}}),
	font_size = 11,
	keys = {
		{key = "5", mods = "CTRL", action = wezterm.action.SplitHorizontal {domain = "CurrentPaneDomain"}},
		{key = "h", mods = "CTRL", action = wezterm.action.ActivatePaneDirection "Left"},
		{key = "l", mods = "CTRL", action = wezterm.action.ActivatePaneDirection "Right"},
		{key = "h", mods = "CTRL|SHIFT", action = wezterm.action.AdjustPaneSize {"Left", 10}},
		{key = "l", mods = "CTRL|SHIFT", action = wezterm.action.AdjustPaneSize {"Right", 10}},
	},
}

if wezterm.target_triple:find("windows") then
	config.default_prog = {"cmd.exe", "/k", [[C:\Users\allen\configuration\config\cmdrc.bat]]}
end

return config
