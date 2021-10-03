{ pkgs, inputs, config, ... }:
{
  nix = {
    autoOptimiseStore = true;
    gc.automatic = true;
    optimise.automatic = true;
    useSandbox = true;
    allowedUsers = [ "@wheel" ];
    trustedUsers = [ "root" "@wheel" ];
    extraOptions = ''
      min-free = 536870912
      keep-outputs = true
      keep-derivations = true
      fallback = true
      experimental-features = nix-command flakes
      sandbox-paths = /bin/sh=${pkgs.bash}/bin/sh
    '';
    nixPath = [
      "repl=${toString ./.}/repl.nix"
      "nixpkgs=${inputs.nixpkgs}"
    ];
    registry.nixpkgs.flake = inputs.nixpkgs;
    package = pkgs.nixUnstable;
  };
  environment.shellAliases = {
    rpl = builtins.toString [
      "source /etc/set-environment"
      "&& nix repl"
      "--argstr host '${config.networking.hostName}'"
      "$(echo $NIX_PATH | perl -pe 's|.*(/nix/store/.*-source/profiles/nix/repl.nix).*|\\1|')"
    ];
  };

  environment.systemPackages = with pkgs; [
    nix-goto
  ];

  nixpkgs = {
    config.allowUnfree = true;
  };
}
