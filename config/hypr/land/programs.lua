M = {}

M.terminal = "kitty"
M.term_launch = M.terminal .. " sh -c"
M.drun = "gtk-launch"

M.launcher = "rofi -show drun -modes drun,window,run,filebrowser"
M.clipboard = "rofi-clipboard"
M.emoji_picker = "rofimoji"

M.screenshot_region = "hyprshot -m region --clipboard-only"
M.file_manager = "nemo"
M.browser = M.drun .. " app.zen_browser.zen.desktop"

return M
