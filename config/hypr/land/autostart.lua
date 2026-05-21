hl.on("hyprland.start", function()
	hl.exec_cmd("systemctl restart --user waybar.service")
	hl.exec_cmd("waypaper --restore")
	hl.exec_cmd("xhost +si:localuser:root")
end)

hl.on("hyprland.shutdown", function()
	os.execute("systemctl --user stop hyprland-session.target")
end)
