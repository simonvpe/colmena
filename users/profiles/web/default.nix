{ pkgs
, ...
}:
{
  programs.brave.enable = true;
  home.packages = with pkgs; [ signal-desktop ];
}
