{ pkgs, ... }:
{
  config.programs.bash = {
    enable = true;
    initExtra = ''
      export MANPAGER="sh -c 'col -b | ${pkgs.bat}/bin/bat -l man -p'";
      export EDITOR=nvim
      printf '%s' "$(cat ~/.cache/wal/sequences)"
      source ~/.cache/wal/colors-tty.sh
    '';
  };
}
