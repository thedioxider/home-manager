{ inputs, pkgs, ... }:

let
  system = pkgs.stdenv.hostPlatform.system;
  hyprland = inputs.hyprland.packages.${system}.hyprland;
in

hyprland.stdenv.mkDerivation {
  pname = "hyprcapture";
  version = "0.2.1";

  patches = [ ./nix-store-trust.patch ./nix-ui-compat.patch ./nix-session-env.patch ./nix-recording-compat.patch ];

  src = pkgs.fetchFromGitHub {
    owner = "gfhdhytghd";
    repo = "HyprCapture";
    rev = "36f1a6e2f14ca863fe861aacb2f807a7b8a29dfc";
    hash = "sha256-Jvjm/LFLt5ODuGNTHK6FvP32VQIzkQTyRibFNjnmy0s=";
  };

  nativeBuildInputs = with pkgs; [
    cmake
    pkg-config
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    inputs.hyprland.packages.${system}.hyprland.dev
    pkgs.qt6.qtbase
    pkgs.qt6.qtsvg
    pkgs.kdePackages.layer-shell-qt
    pkgs.nlohmann_json
    pkgs.lua5_4
    pkgs.glib
  ] ++ hyprland.buildInputs;

  meta = with pkgs.lib; {
    description = "Hyprland-only screenshot and recording overlay";
    homepage = "https://github.com/gfhdhytghd/HyprCapture";
    license = licenses.gpl3Only;
    platforms = [ "x86_64-linux" "aarch64-linux" ];
  };
}
