#
# To get dxf export functionality
#
final: prev:
let packageOverrides = python-final: python-prev: {
  cadquery = python-prev.cadquery.overrideAttrs (_: {
    src = final.fetchgit {
      url = "https://github.com/cadquery/cadquery";
      rev = "ba1dfe448f47ea31e083865bc3e6be19982677f1";
      sha256 = "sha256-q0RaCavipyy/1zmDxF61KxAVAUevS9lSjCxtdP3LOys=";
    };
  });
};
in
{
  python = prev.python.override { inherit packageOverrides; };
  python37 = prev.python37.override { inherit packageOverrides; };
}
