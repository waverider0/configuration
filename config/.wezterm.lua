local wezterm = require "wezterm"

local config = {
	colors = { background = '#151515' },
	font_size = 11,
}

if wezterm.target_triple:find("windows") then
	config.default_prog = { "cmd.exe", "/k", [[C:\Users\allen\configuration\config\cmdrc.bat]] }
end

return config
