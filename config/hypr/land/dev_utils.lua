-- show info about current window
hl.window_rule({
	match = { title = "^hyprinfo$" },
	float = true,
})
hl.bind(
	MAIN_MOD .. "+F12",
	hl.dsp.exec_cmd(
		"hyprctl activewindow > /tmp/window_info.txt && kitty --title hyprinfo sh -c 'cat /tmp/window_info.txt ; read'"
	)
)

-- show info about current layer
hl.bind(
	MAIN_MOD .. "+ALT+F12",
	hl.dsp.exec_cmd(
		"hyprctl layers > /tmp/layers_info.txt && kitty --title hyprinfo sh -c 'cat /tmp/layers_info.txt ; read'"
	)
)
