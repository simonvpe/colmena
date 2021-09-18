#
# pyroma tests fail with a segmentation fault, this commit fixes it
#
final: prev:
let packageOverrides = python-final: python-prev: {
  pyroma = python-prev.pyroma.overrideAttrs (_: {
    src = final.fetchgit {
      url = "https://github.com/regebro/pyroma";
      rev = "b528ee55cc516bb851a2be87a11b1b3c32c6edca";
      sha256 = "sha256-E7BnoVPzNP1q0ridQYzSp9CLHCE1Agwf72SQMlzL01o=";
    };
  });
};
in
{
  python = prev.python.override { inherit packageOverrides; };
  python37 = prev.python37.override { inherit packageOverrides; };
}
