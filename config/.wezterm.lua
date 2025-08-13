local wezterm = require "wezterm"

local config = {
	colors = { background = '#1e1e1e' },
	font_size = 10.0
}

if wezterm.target_triple:find("windows") then
	config.default_prog = { "cmd.exe", "/k", [[C:\Users\allen\configuration\config\cmdrc.bat]] }
end

return config
