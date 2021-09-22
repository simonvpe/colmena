#
# Patches openfortivpn to use a pppd that can be run as user
#
{ openfortivpn, openssl, ppp }:
let
  pppPatch = orig: {
    postPatch = ''
      ${orig.postPatch}
      # This lets users execute pppd
      substituteInPlace pppd/Makefile.linux --replace '-m 555 pppd' '-m 4755 pppd'
    '';
  };
  openfortivpnPatch = _: {
    buildInputs = [ openssl (ppp.overrideAttrs pppPatch) ];
  };
in
openfortivpn.overrideAttrs openfortivpnPatch
