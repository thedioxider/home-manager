-- See https://wiki.hyprland.org/Configuring/Monitors/

hl.monitor({
	output = "desc:AU Optronics B173HAN04.9",
	mode = "1920x1080@144",
	position = "0x0",
	scale = 1,
})

hl.monitor({
	output = "desc:Xiaomi Corporation Mi Monitor 5745710115793",
	mode = "preferred",
	position = "auto-up",
	scale = 1,
	cm = "dcip3",
})

-- hl.monitor({
-- 	output = "desc:LG Electronics LG FULL HD 0x01010101",
-- 	mode = "1920x1080@60",
-- 	position = "auto-left",
-- 	scale = 1,
-- })
--
-- hl.monitor({
-- 	output = "",
-- 	mode = "preferred",
-- 	position = "auto",
-- 	scale = 1,
-- })

hl.monitor({
	output = "",
	mode = "preferred",
	position = "auto",
	scale = 1,
	mirror = "eDP-1",
})

-- To add free space on screen
-- reserved_area = { top, right, bottom, left }
