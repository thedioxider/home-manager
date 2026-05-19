-- Picture-in-Picture
hl.window_rule({
	match = { title = "^Picture-in-Picture$" },
	float = true,
	pin = true,
	content = "video",
	border_size = 1,
	keep_aspect_ratio = true,
	move = { "monitor_w - window_w - 1", "monitor_h - window_h - 1" },
})

-- AmneziaVPN
hl.window_rule({
	match = { title = "^AmneziaVPN$" },
	float = true,
	size = { 360, 640 },
})
