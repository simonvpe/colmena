{ username ? "starlord", extraConfig ? _: {} }: { config, pkgs, lib, ... }:
with lib;
let
  cfg = config.simux.users.${username};
in
{
  options.simux.users.${username} = {
    enable = mkEnableOption "${username} user";
  };

  config = mkMerge [
    (mkIf cfg.enable (
      let orig = {
        nix.trustedUsers = [ username ];
        users.users.${username} = {
          isNormalUser = true;
          extraGroups = [ "wheel" "docker" "libvirtd" "dialout" ];
        };
        home-manager.users.${username} = import ./home { inherit pkgs config; };
        simux.nur.enable = true;
      };
      in orig // (extraConfig { inherit orig cfg pkgs; })))
  ];
}
