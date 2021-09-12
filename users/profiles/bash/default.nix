{
  config.programs.bash = {
    enable = true;
    initExtra = ''
      export MANPAGER="sh -c 'col -b | bat -l man -p'";
      export EDITOR=nvim
      export TERM=vt100
      printf '%s' "$(cat ~/.cache/wal/sequences)"
      source ~/.cache/wal/colors-tty.sh
    '';
    shellAliases = {
      cat = "bat";
    };
  };
}
