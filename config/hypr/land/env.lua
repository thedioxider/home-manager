hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")

-- compositor GPU selection: set AQ_DRM_DEVICES from aq-gpu's alias-based value.
-- If the util fails, AQ_DRM_DEVICES stays unset and Aquamarine auto-picks the
-- iGPU (it favours the built-in panel's GPU). (see aq-gpu.nix)
local h = io.popen("aq-gpu _load")
if h then
  local devs = h:read("*l")
  h:close()
  if devs and devs ~= "" then hl.env("AQ_DRM_DEVICES", devs) end
end
