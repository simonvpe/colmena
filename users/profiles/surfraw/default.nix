{ config
, pkgs
, ...
}:
let
  aliases = {
    surfraw = "detach surfraw";
    ddg = "surfraw duckduckgo";
    yt = "surfraw youtube";
  };

  detach = pkgs.writeScriptBin "detach" ''
    "$@" &>/dev/null &
  '';

in
{
  config = {
    home.packages = [ pkgs.surfraw detach ];
    xdg.configFile."surfraw/conf".text = ''
      SURFRAW_graphical_browser=${pkgs.xdg-utils}/bin/xdg-open
      SURFRAW_graphical=yes
    '';
    programs.zsh.shellAliases = aliases;
    programs.bash.shellAliases = aliases;
    programs.fish.shellAliases = aliases;
  };
}
