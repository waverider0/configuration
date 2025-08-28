local wezterm = require "wezterm"

local config = {
	colors = {background = "#111111"},
	font = wezterm.font({family = "JetBrains Mono", harfbuzz_features = {"calt=0"}}),
	font_size = 11,
	keys = {
		-- create panes
		{key = "5", mods = "CTRL", action = wezterm.action.SplitHorizontal {domain = "CurrentPaneDomain"}},
		{key = "'", mods = "CTRL", action = wezterm.action.SplitVertical {domain = "CurrentPaneDomain"}},
		-- switch panes
		{key = "h", mods = "CTRL", action = wezterm.action.ActivatePaneDirection "Left"},
		{key = "j", mods = "CTRL", action = wezterm.action.ActivatePaneDirection "Down"},
		{key = "k", mods = "CTRL", action = wezterm.action.ActivatePaneDirection "Up"},
		{key = "l", mods = "CTRL", action = wezterm.action.ActivatePaneDirection "Right"},
		-- resize panes
		{key = "h", mods = "CTRL|SHIFT", action = wezterm.action.AdjustPaneSize {"Left", 10}},
		{key = "j", mods = "CTRL|SHIFT", action = wezterm.action.AdjustPaneSize {"Down", 10}},
		{key = "k", mods = "CTRL|SHIFT", action = wezterm.action.AdjustPaneSize {"Up", 10}},
		{key = "l", mods = "CTRL|SHIFT", action = wezterm.action.AdjustPaneSize {"Right", 10}},
	},
}

if wezterm.target_triple:find("windows") then
	config.default_prog = {"cmd.exe", "/k", [[C:\Users\allen\configuration\config\windows\cmdrc.bat]]}
end

return config
