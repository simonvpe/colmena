{ coreutils
, installShellFiles
, runCommandNoCC
}:

runCommandNoCC "nix-goto" { nativeBuildInputs = [ installShellFiles ]; } ''
  mkdir -p $out/bin
  install --mode=0755 ${./nix-goto.sh} $out/bin/nix-goto
  installShellCompletion --bash --name nix-goto ${./nix-goto-completion.bash}
''
