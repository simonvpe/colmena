{ pkgs
, lib
, ...
}:
let
  aliases = {
    ll = lib.mkForce "${pkgs.exa}/bin/exa --long --header --git";
  };
in
{
  config.programs.exa = {
    enable = true;
    enableAliases = true;
  };
  config.programs.bash.shellAliases = aliases;
  config.programs.zsh.shellAliases = aliases;
  config.programs.fish.shellAliases = aliases;
}
