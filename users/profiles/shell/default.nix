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
      # pkgs.zsh-powerlevel10k
      # {
      #   name = "powerlevel10k";
      #   src = pkgs.fetchFromGitHub {
      #     owner = "romkatv";
      #     repo = "powerlevel10k";
      #     rev = "v1.15.0";
      #     sha256 = "sha256-mLPJwXqy8uL1/QOkAG31iKJ1wReH8xzJ/6PbqGIWcqw=";
      #   };
      # }
      # {
      #   name = "zsh-autosuggestions";
      #   src = pkgs.fetchFrom
      # }
    ];
  };
}
