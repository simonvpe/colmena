{ suites, ... }:
{
  imports = [
    ./configuration.nix
  ] ++ suites.desktop;
}
