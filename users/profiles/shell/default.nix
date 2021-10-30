{ pkgs, ... }:
{
  config.programs.zsh = {
    enable = true;
    initExtra = ''
      export MANPAGER="sh -c 'col -b | ${pkgs.bat}/bin/bat -l man -p'";
      export EDITOR=nvim
      ${pkgs.any-nix-shell}/bin/any-nix-shell zsh --info-right | source /dev/stdin
    '';
    plugins = [
      {
        name = "zsh-autosuggestions";
        src = pkgs.zsh-autosuggestions;
        file = "share/zsh-autosuggestions/zsh-autosuggestions.zsh";
      }
      {
        name = "zsh-powerlevel10k";
        src = pkgs.callPackage ./zsh-powerlevel10k-with-config.nix { config = ./.p10k.zsh; };
      }
      {
        name = "zsh-vi-mode";
        src = pkgs.fetchgit {
          url = "https://github.com/jeffreytse/zsh-vi-mode";
          rev = "9e71245f29ddbb800de0a573ea42c0af08e4071b";
          sha256 = "sha256-2/j+QAm4cZm9y2yOfwmlj+Lxq2Oy3UDcY1woAUOy6ZU=";
        };
      }
    ];
  };
}
