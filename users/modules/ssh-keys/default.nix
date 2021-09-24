{ self
, config
, pkgs
, lib
, ...
}:

let
  cfg = config.sshKeys;
  inherit (lib) mkIf mapAttrsToList attrValues;
  inherit (lib.options) mkOption mkEnableOption;
  inherit (lib.types) path submodule attrsOf str;
  inherit (lib.strings) concatStringsSep;

  keyOptions = {
    options = {
      privateKeyPath = mkOption {
        type = path;
        description = "The age encrypted private key";
      };
      publicKey = mkOption {
        type = str;
        description = "The public key, will re-use the name of the private key + .pub";
      };
      passphrasePath = mkOption {
        type = str;
        description = "The path to the passphrase for the key, make sure to use agenix to store this one";
      };
    };
  };

  options.sshKeys = {
    enable = mkEnableOption "sshKeys";

    keys = mkOption {
      type = attrsOf (submodule keyOptions);
      default = { };
    };

    tmpPath = mkOption {
      type = str;
      default = "$XDG_RUNTIME_DIR/ssh-keys";
    };
  };

  identities = mapAttrsToList (_: { publicKey, ... }: publicKey) cfg.keys;

  installKey = { privateKeyPath, publicKey, passphrasePath }:
    let
      tmp = "${cfg.tmpPath}/${builtins.baseNameOf privateKeyPath}.tmp";
      sock = "${cfg.tmpPath}/${builtins.baseNameOf privateKeyPath}.sock";
    in
    ''
      set -x
      mkdir -p ${cfg.tmpPath}
      chmod 0700 ${cfg.tmpPath}
      ${pkgs.openssh}/bin/ssh-agent -a ${sock}
      (umask u=r,g=,o=; ${pkgs.rage}/bin/rage --decrypt {identities} -o ${tmp} ${privateKeyPath}
    '';
in
{
  inherit options;

  config = mkIf cfg.enable {
    #home.activation = concatStringsSep "\n" (map installKey (attrValues cfg.keys));
  };
}
