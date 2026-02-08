{
  config,
  lib,
  pkgs,
  globLink,
  ...
}:
{
  xdg.configFile."helix/config.toml".source = globLink config "config/helix/config.toml";
  programs.helix = {
    enable = true;

    # Language Servers & Formatters
    extraPackages = with pkgs; [
      # nix
      nixd

      # c/cpp
      libclang
      lldb

      # html, css, javascript, typescript, json, markdown
      vscode-langservers-extracted
      typescript-language-server
      marksman
      prettier

      # python
      python3.pkgs.python-lsp-server
      black

      # java
      jdt-language-server
      google-java-format

      # xml
      lemminx
      libxml2

      # toml
      taplo

      # yaml
      yaml-language-server

      # lua
      lua-language-server
      stylua

      # rust
      rust-analyzer
      clippy

      # kotlin
      kotlin-language-server
      ktlint

      # docker
      dockerfile-language-server
      dockerfmt
      docker-compose-language-service

      # dart
      dart
    ];
    languages = {
      language =
        let
          prettier-lang-parser = lang: parser: {
            name = lang;
            auto-format = true;
            formatter = {
              command = lib.getExe pkgs.prettier;
              args = [
                "--parser"
                parser
              ];
            };
          };
          prettier-lang = lang: (prettier-lang-parser lang lang);
        in
        [
          {
            name = "nix";
            language-servers = [ "nixd" ];
            auto-format = true;
            formatter.command = lib.getExe pkgs.nixfmt;
          }
          {
            name = "python";
            auto-format = true;
            formatter = {
              command = lib.getExe pkgs.black;
              args = [
                "--quiet"
                "-"
              ];
            };
          }
          (prettier-lang "html")
          (prettier-lang "css")
          (prettier-lang "scss")
          (prettier-lang-parser "javascript" "typescript")
          (prettier-lang "typescript")
          (prettier-lang-parser "tsx" "typescript")
          (prettier-lang "markdown")
          (prettier-lang "json")
          (prettier-lang "yaml")
          {
            name = "java";
            auto-format = true;
            formatter.command = lib.getExe pkgs.google-java-format;
          }
          {
            name = "toml";
            auto-format = true;
            formatter = {
              command = lib.getExe pkgs.taplo;
              args = [
                "format"
                "-"
              ];
            };
          }
          {
            name = "xml";
            language-servers = [ "lemminx" ];
            file-types = [
              "xml"
              "svg"
              "xsd"
              "xslt"
              "xsl"
            ];
            auto-format = true;
            formatter = {
              command = "${pkgs.libxml2}/bin/xmllint";
              args = [
                "--format"
                "-"
              ];
            };
          }
          {
            name = "lua";
            auto-format = true;
            formatter.command = lib.getExe pkgs.stylua;
          }
          {
            name = "rust";
            auto-format = true;
            formatter.command = lib.getExe pkgs.rustfmt;
          }
          {
            name = "kotlin";
            auto-format = true;
            formatter = {
              command = "ktlint";
              args = [
                "--format"
              ];
            };
          }
          {
            name = "dockerfile";
            auto-format = true;
            formatter.command = "dockerfmt";
          }
          (prettier-lang-parser "docker-compose" "yaml")
          {
            name = "dart";
            auto-format = true;
            formatter = {
              command = lib.getExe pkgs.dart;
              args = [ "format" ];
            };
          }
          {
            name = "c";
            auto-format = true;
            formatter.command = "${pkgs.libclang}/bin/clang-format";
          }
          {
            name = "cpp";
            auto-format = true;
            formatter.command = "${pkgs.libclang}/bin/clang-format";
          }
        ];
      language-server = {
        lemminx = {
          command = lib.getExe pkgs.lemminx;
        };
        rust-analyzer = {
          config = {
            check.command = lib.getExe pkgs.clippy;
          };
        };
      };
    };
  };
}
