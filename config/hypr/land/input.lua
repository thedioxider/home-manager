hl.config({
	input = {
		kb_layout = "us,ru",
		kb_options = "grp:win_space_toggle,shift:both_shiftlock",

		numlock_by_default = true,

		follow_mouse = 2,
		float_switch_override_focus = 0,
		sensitivity = 0, -- -1.0 - 1.0, 0 means no modification.
		accel_profile = "adaptive",

		touchpad = {
			disable_while_typing = true,
			natural_scroll = true,
			tap_to_click = true,
			drag_lock = false,
		},
	},

	animations = {
		workspace_wraparound = true,
	},

	gestures = {
		workspace_swipe_create_new = false,
		workspace_swipe_cancel_ratio = 0.2,
	},
})

-- TODO: [Hyprgrid](https://github.com/jairnarvaez/Hyprgrid)
hl.gesture({
	fingers = 3,
	direction = "vertical",
	action = "workspace",
})

hl.gesture({
	fingers = 3,
	direction = "horizontal",
	action = "scroll_move",
})

hl.gesture({
	fingers = 2,
	direction = "pinch",
	action = "cursorZoom",
	mode = "live",
	mods = MAIN_MOD,
})
