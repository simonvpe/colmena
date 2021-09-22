{ pkgs
, ...
}:
let

in
{
  networking = {
    useNetworkd = true;
    useDHCP = false; # cannot be used together with networkd
    enableIPv6 = true;
  };

  services.resolved.dnssec = "false"; # not good to do this but it's a workaround for fresh tomato
  # dns right now.
}
