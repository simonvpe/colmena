{ pkgs
, ...
}:
let
  common = "--header --git --icons";
  aliases = {
    ls = "${pkgs.exa}/bin/exa ${common} --git-ignore";
    la = "${pkgs.exa}/bin/exa ${common} --all";
    ll = "${pkgs.exa}/bin/exa ${common} --long --git-ignore";
    lla = "${pkgs.exa}/bin/exa ${common} --long --all";
    lt = "${pkgs.exa}/bin/exa ${common} --tree --git-ignore";
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
