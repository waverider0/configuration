local wezterm = require "wezterm"
local config = {}

if wezterm.target_triple:find("windows") then
	config.default_prog = { "cmd.exe", "/k", [[C:\Users\allen\configuration\config\cmd.bat]] }
end

return config
