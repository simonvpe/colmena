{ pkgs
, ...
}:
{
  config.terminal.package = pkgs.alacritty;
  config.terminal.config.settings = {
    font.normal.family = "Inconsolata";
    font.size = 6;
  };
}
