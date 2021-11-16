{ pkgs
, ...
}:
let
  common = "--header --git --icons";
  aliases = {
    ls = "${pkgs.exa}/bin/exa ${common}";
    la = "${pkgs.exa}/bin/exa ${common} --all";
    ll = "${pkgs.exa}/bin/exa ${common} --long";
    lla = "${pkgs.exa}/bin/exa ${common} --long --all";
    lt = "${pkgs.exa}/bin/exa ${common} --tree";
    lta = "${pkgs.exa}/bin/exa ${common} --tree --all";
  };
in
{
  config.programs.exa = {
    enable = true;
    enableAliases = false;
  };
  config.programs.bash.shellAliases = aliases;
  config.programs.zsh.shellAliases = aliases;
  config.programs.fish.shellAliases = aliases;
}
