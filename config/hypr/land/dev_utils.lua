-- show info about current window
hl.window_rule({
	match = { title = "^window_info$" },
	float = true,
})
hl.bind(
	MAIN_MOD .. "+F12",
	hl.dsp.exec_cmd(
		"hyprctl activewindow > /tmp/window_info.txt && kitty --title window_info sh -c 'cat /tmp/window_info.txt ; read'"
	)
)
