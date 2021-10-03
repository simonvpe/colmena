final: prev: {
  # keep sources this first
  sources = prev.callPackage (import ./_sources/generated.nix) { };
  # then, call packages with `final.callPackage`
  nix-goto = final.callPackage ./nix-goto { };
  repl = final.callPackage ./repl { };
}
