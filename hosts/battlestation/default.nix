{ suites, ... }:
{
  imports = [
    ./configuration.nix
  ] ++ suites.desktop;

  bud.enable = true;
  bud.localFlakeClone = "/etc/nixos/flk";
}
