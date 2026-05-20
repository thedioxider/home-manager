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
	match = { class = "^AmneziaVPN$" },
	float = true,
	size = { 360, 640 },
})

-- Telegram
hl.window_rule({
	match = { class = "^org.telegram.desktop$" },
	float = true,
	pseudo = true,
	persistent_size = true,
})
