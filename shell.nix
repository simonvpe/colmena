with import <nixpkgs> { };

import "${fetchgit {
  url = "https://github.com/zhaofengli/colmena.git";
  sha256 = "1agbp0fwwilpv64h8vdgjlqrvcrqhlcr9bjk486cjd05jj3vkljg";
}}/shell.nix"
