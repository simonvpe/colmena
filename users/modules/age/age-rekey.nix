{ writeScriptBin
, bash
, moreutils
, age-encrypt
, age-decrypt
}:
writeScriptBin "age-rekey" ''
  #!${bash}/bin/bash
  set -o errexit -o nounset -o pipefail
  PATH=${age-encrypt}/bin:${age-decrypt}/bin:${moreutils}/bin
  age-decrypt "$1" | age-encrypt - | sponge "$1"
''
