{ recipients
, writeScriptBin
, bash
, rage
}:
writeScriptBin "age-encrypt" ''
  #!${bash}/bin/bash
  set -o errexit -o nounset
  PATH=${rage}/bin
  rage --encrypt ${recipients} --output - "$1"
''
