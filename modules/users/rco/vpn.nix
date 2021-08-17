{ openfortivpn
, writeScriptBin
, vpnHost ? "vpn.rco.se"
, vpnUser ? "simonp"
, bwObject ? "18da6c75-397a-4070-ae21-ac4b009365a5"
, trustedCert ? "28db5815ac57b1313aef6f277dcd769aaef51450751387885c1919ad05f14a29"
, nodePackages
, fetchFromGitHub
}:

let client = openfortivpn.overrideAttrs (original: {
  src = fetchFromGitHub {
    owner = "awidegreen";
    repo = "openfortivpn";
    rev = "master";
    sha256 = "18gm5757njmd52vdia8wghw4yazr931gg52i6rsbnxz42jscwr7f";
  };
});

in
writeScriptBin "vpn" ''
  sudo ${client}/bin/openfortivpn ${vpnHost} \
    --trusted-cert ${trustedCert} \
    -u ${vpnUser} \
    -p "$(${nodePackages.bitwarden-cli}/bin/bw --raw get password ${bwObject})"
''
