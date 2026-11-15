hl.config({
	-- TODO: groups
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
		wrap_focus = true,
	},
})

---- Setup all existing workspaces
local SMW_COUNT = 6
hl.config({
	plugin = {
		split_monitor_workspaces = {
			count = SMW_COUNT,
			keep_focused = true,
			enable_persistent_workspaces = true,
		},
	},
})

-- On disconnect, move windows from the removed monitor's Nth workspace
-- to the focused monitor's Nth workspace
local function smw_block(id)
	return math.floor((id - 1) / SMW_COUNT)
end

hl.on("monitor.removed", function()
	-- Hyprland has already migrated the removed monitor's workspaces here,
	-- so any window outside a connected monitor's block is orphaned
	local owned = {}
	for _, m in ipairs(hl.get_monitors()) do
		local a = m.active_workspace
		if a and a.id > 0 then
			owned[smw_block(a.id)] = true
		end
	end
	local target = hl.get_active_workspace()
	if not target or target.id < 1 then
		return
	end
	local base = smw_block(target.id) * SMW_COUNT
	for _, w in ipairs(hl.get_windows()) do
		local id = w.workspace and w.workspace.id
		if id and id > 0 and not owned[smw_block(id)] then
			local dest = base + (id - 1) % SMW_COUNT + 1
			hl.dispatch(hl.dsp.window.move({ workspace = tostring(dest), follow = false, window = w }))
		end
	end
end)

-- Reset a workspace back to the default layout once it has one or less windows
local window_ws = {}
for _, w in ipairs(hl.get_windows()) do
	if w.workspace then
		window_ws[w.address] = w.workspace.id
	end
end

local function reset_ws_layout(id)
	if not id or id < 1 then
		return
	end
	hl.timer(function()
		local ws = hl.get_workspace(id)
		local default = hl.get_config("general:layout")
		if ws and ws.windows <= 1 and ws.tiled_layout ~= default then
			hl.workspace_rule({ workspace = tostring(id), layout = default })
		end
	end, { timeout = 50, type = "oneshot" })
end

hl.on("window.open", function(w)
	if w.workspace then
		window_ws[w.address] = w.workspace.id
	end
end)
hl.on("window.move_to_workspace", function(w, ws)
	local from = window_ws[w.address]
	window_ws[w.address] = ws and ws.id
	reset_ws_layout(from)
end)
hl.on("window.close", function(w)
	local from = w.workspace and w.workspace.id or window_ws[w.address]
	window_ws[w.address] = nil
	reset_ws_layout(from)
end)

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
