{ writeScriptBin }: writeScriptBin "repl" ''
  set -o errexit
  source /etc/set-environment
  export DEFAULT_REPL=''${DEFAULT_REPL:-${./repl.nix}}
  set -- "''${1:-$DEFAULT_REPL}" "''${@:2}"
  exec -a rpl nix repl \
    --argstr replHost "$(hostname)" \
    --argstr flakePath ${../../.} \
    "$@"
''
