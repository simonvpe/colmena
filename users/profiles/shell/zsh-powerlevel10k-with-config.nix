{ config
, pkgs
, writeTextFile
}:

writeTextFile rec {
  name = "zsh-powerlevel10k.plugin.zsh";
  destination = "/${name}";
  text = ''
    export POWERLEVEL9K_DISABLE_CONFIGURATION_WIZARD=true
    source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
    source ${config}
  '';
}
