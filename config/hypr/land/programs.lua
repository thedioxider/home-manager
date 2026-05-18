M = {}

M.terminal = "kitty"
M.term_launch = M.terminal .. " sh -c"
M.drun = "gtk-launch"
M.runner = 'rofi -show combi -modes combi -combi-modes "window,drun,run"'
M.screenshot_region = "hyprshot -m region --clipboard-only"
M.file_manager = "nemo"
M.browser = M.drun .. " app.zen_browser.zen.desktop"

return M
