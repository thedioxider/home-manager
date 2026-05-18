hl.config({
	binds = {
		hide_special_on_workspace_change = true,
		workspace_center_on = 1,
	},
})

local programs = require("programs")
local smw = hl.plugin.split_monitor_workspaces

hl.bind(MAIN_MOD .. "+T", hl.dsp.exec_cmd(programs.terminal))
hl.bind(MAIN_MOD .. "+C", hl.dsp.window.close())
hl.bind(MAIN_MOD .. "+ALT+BackSpace", hl.dsp.exec_cmd("hyprshutdown --post-cmd 'hyprctl dispatch \"hl.dsp.exit()\"'"))
hl.bind(MAIN_MOD .. "+E", hl.dsp.exec_cmd(programs.file_manager))
hl.bind(MAIN_MOD .. "+V", hl.dsp.window.float())
hl.bind(MAIN_MOD .. "+R", hl.dsp.exec_cmd(programs.runner))
hl.bind(MAIN_MOD .. "+F", hl.dsp.window.fullscreen({ mode = "fullscreen" }))
hl.bind(MAIN_MOD .. "+P", hl.dsp.window.pseudo()) -- dwindle
hl.bind(MAIN_MOD .. "+Y", hl.dsp.layout("togglesplit"))
hl.bind(MAIN_MOD .. "+S", hl.dsp.layout("swapsplit"))
hl.bind(MAIN_MOD .. "+M", hl.dsp.window.pin())
hl.bind("ALT+Tab", hl.dsp.focus({ urgent_or_last = true }))
hl.bind(MAIN_MOD .. "+U", hl.dsp.window.toggle_swallow())
hl.bind(MAIN_MOD .. "+SHIFT+S", function()
	smw.change_monitor("+1")
end)

hl.layer_rule({ match = { namespace = "selection" }, no_anim = true })
hl.bind("Print", hl.dsp.exec_cmd(programs.screenshot_region))

-- Move focus with MAIN_MOD + arrow keys
hl.bind(MAIN_MOD .. "+left", hl.dsp.focus({ direction = "l" }))
hl.bind(MAIN_MOD .. "+right", hl.dsp.focus({ direction = "r" }))
hl.bind(MAIN_MOD .. "+up", hl.dsp.focus({ direction = "u" }))
hl.bind(MAIN_MOD .. "+down", hl.dsp.focus({ direction = "d" }))
-- Move focus with MAIN_MOD + vim motions
hl.bind(MAIN_MOD .. "+H", hl.dsp.focus({ direction = "l" }))
hl.bind(MAIN_MOD .. "+L", hl.dsp.focus({ direction = "r" }))
hl.bind(MAIN_MOD .. "+K", hl.dsp.focus({ direction = "u" }))
hl.bind(MAIN_MOD .. "+J", hl.dsp.focus({ direction = "d" }))

-- Switch workspaces with MAIN_MOD + [0-9]
-- Move active window to a workspace with MAIN_MOD + SHIFT + [0-9]
for i = 0, 9 do
	hl.bind(MAIN_MOD .. "+" .. i, function()
		smw.workspace(i)
	end)
	hl.bind(MAIN_MOD .. "+SHIFT+" .. i, function()
		smw.move_to_workspace_silent(i)
	end)
end

-- Special workspace (scratchpad)
hl.bind(MAIN_MOD .. "+grave", hl.dsp.workspace.toggle_special("magic"))
hl.bind(MAIN_MOD .. "+SHIFT+grave", hl.dsp.window.move({ workspace = "special:magic", follow = false }))

-- Scroll through existing workspaces with MAIN_MOD + scroll
hl.bind(MAIN_MOD .. "+mouse_down", function()
	smw.workspace("m+1")
end)
hl.bind(MAIN_MOD .. "+period", function()
	smw.workspace("m+1")
end)
hl.bind(MAIN_MOD .. "+SHIFT+period", function()
	smw.move_to_workspace("m+1")
end)
hl.bind(MAIN_MOD .. "+mouse_up", function()
	smw.workspace("m-1")
end)
hl.bind(MAIN_MOD .. "+comma", function()
	smw.workspace("m-1")
end)
hl.bind(MAIN_MOD .. "+SHIFT+comma", function()
	smw.move_to_workspace("m-1")
end)

-- Move/resize windows with MAIN_MOD + LMB/RMB and dragging
hl.bind(MAIN_MOD .. "+mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(MAIN_MOD .. "+mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Laptop multimedia keys for volume and LCD brightness
hl.bind(
	"XF86AudioRaiseVolume",
	hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"),
	{ repeating = true, locked = true }
)
hl.bind(
	"XF86AudioLowerVolume",
	hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),
	{ repeating = true, locked = true }
)
hl.bind(
	"XF86AudioMute",
	hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),
	{ repeating = true, locked = true }
)
hl.bind(
	"XF86AudioMicMute",
	hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),
	{ repeating = true, locked = true }
)

hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl s 5%+"), { repeating = true, locked = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl s 5%-"), { repeating = true, locked = true })

-- Requires playerctl
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl pause"), { locked = true })
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })
