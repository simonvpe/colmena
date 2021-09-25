{ identities
, writeScriptBin
, bash
, rage
}:
writeScriptBin "age-decrypt" ''
  #!${bash}/bin/bash
  set -o errexit -o nounset
  PATH=${rage}/bin
  rage --decrypt ${identities} --output - "$1"
''
