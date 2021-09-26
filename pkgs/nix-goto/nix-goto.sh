#!/usr/bin/env bash
set -o errexit -o nounset
while read -r name path; do
    if [[ "$name" == "$1" ]]; then
        if [[ -d "${path:-}" ]]; then
                cd "$path"
                action="exec $SHELL"
                break
        else
            >&2 echo "'$path' is not a path" && exit 1
        fi
        >&2 echo "no match $name"
    fi
done <<< $(echo $NIX_PATH | tr ':=' '\n ')
${action:-echo "no entry '$1' in \$NIX_PATH"}
${action:-exit 1}
