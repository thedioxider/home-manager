hl.config({
	group = {},

	general = {
		layout = "scrolling",
	},

	dwindle = {
		force_split = 2,
		preserve_split = true, -- If yes, mainMod + Y to change orientation
		special_scale_factor = 0.9,
		precise_mouse_move = true,
	},

	master = {
		mfact = 0.7,
		new_status = "slave",
		orientation = "left",
	},

	scrolling = {
		fullscreen_on_one_column = true,
		column_width = 0.9,
		focus_fit_method = 0,
	},

	plugin = {
		split_monitor_workspaces = {
			count = 6,
			keep_focused = true,
			enable_persistent_workspaces = true,
		},
	},
})

-- Ignore maximize requests from apps. You'll probably like this.
hl.window_rule({
	match = { class = ".*" },
	suppress_event = "maximize",
})

-- Fix some dragging issues with XWayland
hl.window_rule({
	match = {
		class = "^$",
		title = "^$",
		xwayland = true,
		float = true,
		fullscreen = false,
		pin = false,
	},
	no_focus = true,
})

-- Prevents JetBrains popups from stealing focus or flickering
hl.window_rule({
	match = {
		class = "jetbrains-.*",
		title = "splash",
		float = true,
	},
	center = true,
	no_focus = true,
})
hl.window_rule({
	match = {
		class = "jetbrains-.*",
		title = "win.*",
	},
	no_focus = true,
})
hl.window_rule({
	match = {
		class = "jetbrains-.*",
	},
	no_blur = true,
	no_initial_focus = true,
	opacity = "1 override 1 override 1",
})

-- Ref https://wiki.hypr.land/Configuring/Basics/Workspace-Rules/
-- "Smart gaps" / "No gaps when only"
hl.workspace_rule({
	workspace = "w[tv1]",
	gaps_out = 0,
	gaps_in = 0,
})
hl.workspace_rule({
	workspace = "f[1]",
	gaps_out = 0,
	gaps_in = 0,
})
-- hl.window_rule({
--     match = {
--         float = false,
--         workspace = "w[tv1]",
--     },
--     border_size = 0,
--     rounding = 0,
-- })
hl.window_rule({
	match = {
		float = false,
		workspace = "f[1]",
	},
	border_size = 0,
	rounding = 0,
})
