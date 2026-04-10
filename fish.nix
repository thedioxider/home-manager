{ lib, pkgs, ... }:
{
  home.shell.enableFishIntegration = true;
  programs.fish = {
    enable = true;
    package = pkgs.fish;


    shellInit = ''
      fish_config theme choose "Old School"
    '';

    interactiveShellInit = ''
      complete -c ndev -f -a "(path basename $HOME/Shells/*/)"
    '';

    functions = {
      fish_right_prompt = {
        body = ''
          if test "$SHLVL" -gt 1;
            echo "[[$SHLVL]]";
          end
        '';
      };

      ndev = {
        description = "Enter a ~/Shells devshell with a persistent GC root";
        body = ''
          if test (count $argv) -lt 1
            echo "usage: ndev <name>[#attr] [extra nix develop args]" >&2
            return 1
          end
          set -l target $argv[1]
          set -l rest $argv[2..-1]
          set -l parts (string split -m1 '#' $target)
          set -l name $parts[1]
          set -l attr default
          if test (count $parts) -gt 1
            set attr $parts[2]
          end
          set -l dir "$HOME/Shells/$name"
          if not test -f "$dir/flake.nix"
            echo "no flake at $dir" >&2
            return 1
          end
          nix develop --profile "$dir/.gcroot-$attr" $rest "$HOME/Shells/$target"
        '';
      };
    };
  };
}
