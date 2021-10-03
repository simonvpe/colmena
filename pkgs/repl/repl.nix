{ flakePath
, replHost
, flake ? builtins.getFlake flakePath
, channels ? flake.pkgs.${builtins.currentSystem}
}:
channels.nixos // rec {
  inherit flake channels;
  nixosConfigurations = flake.nixosConfigurations // {
    current = flake.nixosConfigurations.${replHost};
  };
  lib = lib.extend (
    self: super: {
      getFlake = path: builtins.getFlake (builtins.toString path);
    }
  );
}
