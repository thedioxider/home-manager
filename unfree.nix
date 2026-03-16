lib: pkg:
(builtins.elem (lib.getName pkg) [
  "android-studio"
  "spotify"
  "vscode"
  "obsidian"
  "blender"
  "android-studio-stable"
  "steam"
  "steam-unwrapped"
  "aseprite"
  "claude-code"
  "zoom"
  "idea"
  "cuda-merged"
  "libnvjitlink"
  "libnpp"
  "cudnn"
])
|| (builtins.match "^(cuda_[a-z_]+)|(libcu[a-z]+)$" (lib.getName pkg)) != null
