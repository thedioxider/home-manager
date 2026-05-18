-- https://wiki.hypr.land/Configuring/

---- Monitors
require("monitors")

---- Program shortcut variables
require("programs")

---- Autostart
require("autostart")

---- Keybinds
require("keybinds")

---- Environment Variables
require("env")

---- Windows and Workspaces
require("workspace")

---- Looks specifics
require("looks")

---- Input
require("input")

---- Look and Feel
-- https://wiki.hyprland.org/Configuring/Variables
hl.config({
	general = {
		layout = "dwindle",
		no_focus_fallback = true,

		border_size = 2,

		gaps_in = 4,
		gaps_out = 0,
		gaps_workspaces = 15,

		col = {
			active_border = { colors = { "rgba(33ccffee)", "rgba(00ff99ee)" }, angle = 45 },
			inactive_border = "rgba(595959aa)",
		},

		resize_on_border = true,
		extend_border_grab_area = 30,
		hover_icon_on_border = true,

		snap = {
			enabled = true,
			window_gap = 30,
			monitor_gap = 60,
			respect_gaps = true,
		},
	},

	-- See https://wiki.hyprland.org/Configuring/Dwindle-Layout/ for more
	dwindle = {
		force_split = 2,
		preserve_split = true, -- If yes, mainMod + Y to change orientation
		special_scale_factor = 0.9,
		precise_mouse_move = true,
	},

	-- See https://wiki.hyprland.org/Configuring/Master-Layout/ for more
	-- master = {
	--     mfact = .7,
	--     new_status = "master",
	--     new_on_top = true,
	--     new_on_active = "after",
	--     orientation = "center",
	--     center_master_fallback = "left",
	--     count_for_center_master = 4,
	-- },

	-- https://wiki.hyprland.org/Configuring/Variables/#misc
	misc = {
		disable_autoreload = true,

		force_default_wallpaper = 0, -- Set to 0 or 1 to disable the anime mascot wallpapers
		disable_hyprland_logo = false, -- If true disables the random hyprland logo / anime girl background. :(
		disable_splash_rendering = false,
		middle_click_paste = false,
		focus_on_activate = false,
		initial_workspace_tracking = true,
		size_limits_tiled = true,

		-- swallows terminal whenever it starts some child gui program
		enable_swallow = true,
		swallow_regex = "^(kitty)$",

		mouse_move_enables_dpms = false,
		key_press_enables_dpms = true,

		font_family = "Roboto",

		vrr = 2,

		animate_manual_resizes = true,
		animate_mouse_windowdragging = true,
	},
})
