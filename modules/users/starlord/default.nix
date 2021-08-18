{ username ? "starlord", extraConfig ? _: {} }: { config, pkgs, ... }:
let orig = {
    nix.trustedUsers = [ username ];
    users.users.${username} = {
      isNormalUser = true;
      extraGroups = [ "wheel" "docker" "libvirtd" "dialout" ];
    };
    home-manager.users.${username} = import ./home { inherit config pkgs; };
  };
in orig // (extraConfig { inherit orig pkgs; })
