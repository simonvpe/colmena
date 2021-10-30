{ pkgs, ... }:
{
  config.programs.zsh = {
    enable = true;
    initExtra = ''
      export MANPAGER="sh -c 'col -b | ${pkgs.bat}/bin/bat -l man -p'";
      export EDITOR=nvim
      export POWERLEVEL9K_DISABLE_CONFIGURATION_WIZARD=true
      . ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
      . ${./.p10k.zsh}

    '';
    plugins = [
      {
        name = "zsh-vi-tools";
        src = pkgs.fetchgit {
          url = "https://github.com/jeffreytse/zsh-vi-mode";
          rev = "9e71245f29ddbb800de0a573ea42c0af08e4071b";
          sha256 = "sha256-2/j+QAm4cZm9y2yOfwmlj+Lxq2Oy3UDcY1woAUOy6ZU=";
        };
      }
    ];
  };
}
