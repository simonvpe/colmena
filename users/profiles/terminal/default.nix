{ pkgs
, ...
}:
let

  theme =
    let
      toJson = text: pkgs.runCommandNoCC "theme" { nativeBuildInputs = [ pkgs.yq ]; } ''
        cat <<EOF | tee /dev/stderr | ${pkgs.yq}/bin/yq . > $out
        ${text}
        EOF
      '';

      fromYaml = text: builtins.fromJSON (builtins.readFile (toJson text));
    in
    name: fromYaml
      (builtins.readFile "${pkgs.fetchFromGitHub {
      owner = "eendroroy";
      repo = "alacritty-theme";
      rev = "5bdfae7482d12bd40f55ae86391c5b8a86af6854";
      sha256 = "sha256-aAE4kdUwkE4L8ta1M8IseUlgpYOilF/HK7pi3OrJ1cU=";
    }}/themes/${name}.yaml");
in
{
  config.terminal.package = pkgs.alacritty;
  config.terminal.config.settings = {
    font.normal.family = "MesloLGS Nerd Font Mono";
    font.size = 10;
  } // (theme "tomorrow_night_bright");
}
