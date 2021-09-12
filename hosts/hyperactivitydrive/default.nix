{ suites, ... }:
{
  imports = [
    ./configuration.nix
  ] ++ suites.laptop;

  bud.enable = true;
  bud.localFlakeClone = "/etc/nixos/flk";
}
