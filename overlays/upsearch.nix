final: prev: {
  upsearch = prev.writeScriptBin "upsearch" ''
    set -o errexit -o nounset

    if [ "$PWD" == / ]; then
      exit 1
    fi

    if [ -e "$1" ]; then
      echo "$PWD/$1"
      exit 0
    fi

    cd ..
    exec "$0" "$1"
  '';
}
