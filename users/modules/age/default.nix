{ config
, pkgs
, lib
, ...
}:

let
  cfg = config.age;
  inherit (pkgs) writeScript bash runCommandNoCC coreutils callPackage;
  inherit (lib) mkIf mapAttrsToList mapAttrs pipe flip attrValues;
  inherit (lib.cli) toGNUCommandLineShell;
  inherit (lib.options) mkOption mkEnableOption;
  inherit (lib.types) path submodule attrsOf str nullOr either nonEmptyStr listOf package;
  inherit (lib.strings) concatMapStringsSep removeSuffix removePrefix replaceStrings makeSearchPath;
  inherit (lib.lists) flatten imap0 zipListsWith concatMap;
  inherit (builtins) toString baseNameOf dirOf;

  keyOptions = submodule {
    options = {
      inputPath = mkOption {
        type = path;
        description = ''
          The age encrypted data.

          When decrypting, all of your configured identity files (ssh public key)
          will be considered.
        '';
      };
      mode = mkOption {
        type = nonEmptyStr; # TODO: mode string type?
        default = "0600";
        description = ''
          Mode of the file.
        '';
      };
      owner = mkOption {
        type = nonEmptyStr;
        default = config.home.username;
        description = ''
          User ownership of the file.
        '';
      };
      group = mkOption {
        type = nonEmptyStr;
        default = "users";
        description = ''
          Group ownership of the file.
        '';
      };
    };
  };

  options.age = {
    enable = mkEnableOption "age";

    identities = mkOption {
      type = listOf nonEmptyStr;
      description = ''
        The private keys paths considered for decryption, relative
        to your home directory.
      '';
      default = [ ];
    };

    recipients = mkOption {
      type = attrsOf nonEmptyStr;
      description = ''
        The public keys for encryption of the secrets for this user. The
        attribute name should be matched with the host on where the key
        pair is located.
      '';
      default = { };
    };

    xdgRuntimeDir = mkOption {
      type = path;
      description = ''
        TODO: workaround for not being able to reliably figure out the XDG_RUNTIME_DIR
        for the users that didn't run nixos-rebuild
      '';
    };

    secrets = mkOption {
      type = attrsOf keyOptions;
      default = { };
    };

    ragePackage = mkOption {
      type = package;
      default = pkgs.rage;
    };
  };

  mkVolatilePath = { inputPath, ... }: removeSuffix ".age" "${secretsDir}/${baseNameOf inputPath}";
  mkOutputPathAbs = { outputPath, ... }: "${config.home.homeDirectory}/${outputPath}";
  mkMapText = concatMapStringsSep "\n";

  secretsDir = cfg.xdgRuntimeDir; #"/run/user/$(id -u ${config.home.username})/secrets";
  identities = toString (map (x: "--identity '${config.home.homeDirectory}/${x}'") cfg.identities);
  recipients = toString (mapAttrsToList (_: x: "--recipient '${x}'") cfg.recipients);
  secrets = mapAttrs (outputPath: secret: secret // { inherit outputPath; }) cfg.secrets;
  age-encrypt = callPackage ./age-encrypt.nix { inherit recipients; };
  age-decrypt = callPackage ./age-decrypt.nix { inherit identities; };
in
{
  inherit options;
  config = mkIf cfg.enable {

    systemd.user.services.age =
      let
        installKey =
          _args@{ inputPath
          , outputPath
          , owner
          , group
          , mode
          , volatilePath ? mkVolatilePath _args
          , outputPathAbs ? mkOutputPathAbs _args
          , paths ? makeSearchPath "bin" [ cfg.ragePackage coreutils ]
          , ...
          }:
          ''
            (
            ##### TODO: check that the identities are not above the home directory
            echo "decrypting secret ${inputPath} to ${volatilePath}"
            set -o errexit -o xtrace
            export PATH=${paths}
            install --owner=${owner} --group=${group} --mode=0700 --directory "${dirOf volatilePath}"
            rage --decrypt ${identities} --output "${volatilePath}" "${inputPath}"
            )
          '';
        activationScript = "#!${bash}/bin/bash\n" + mkMapText installKey (attrValues secrets);
      in
      {
        Unit = {
          Description = "Decryption of secrets using age";
        };
        Service = {
          Type = "oneshot";
          ExecStart = toString (writeScript "age-${config.home.username}" activationScript);
        };
        Install = {
          WantedBy = [ "default.target" ];
        };
      };

    # We re-use home-managers `home.file` stuff which gives us free collision detection
    # and is generally well-tested. To do this we need to create a derivation with symlinks
    # into the $XDG_RUNTIME_DIR.
    home.file =
      let
        linksInStore =
          let
            mkdir = { outputPath, ... }: "mkdir -p $out/${dirOf outputPath}";
            ln = secret@{ outputPath, ... }: "ln -s ${mkVolatilePath secret} $out/${outputPath}";
            secrets' = attrValues secrets;
          in
          runCommandNoCC "secrets" { } ''
            set -o errexit
            ${mkMapText mkdir secrets'}
            ${mkMapText ln secrets'}
          '';
        # TODO: fix permissions too loose on symlinks, right now ssh-agent just force chmods before running
        mkHmFile = _: { outputPath, ... }: {
          source = "${linksInStore}/${outputPath}";
          target = outputPath;
        };
      in
      mapAttrs mkHmFile secrets;

    home.packages = [ age-encrypt age-decrypt ];
  };
}
