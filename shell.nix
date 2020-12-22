with import <nixpkgs> { };

import "${fetchgit {
  url = "https://github.com/zhaofengli/colmena.git";
  sha256 = "0dvp3w0msgrkbh48m6hxzl43m1hrliwdbn6dygsk8qvd22i3nfa7";
}}/shell.nix"
