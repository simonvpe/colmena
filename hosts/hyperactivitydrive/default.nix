{ suites, ... }:
{
  imports = [
    ./configuration.nix
  ] ++ suites.laptop;
}
