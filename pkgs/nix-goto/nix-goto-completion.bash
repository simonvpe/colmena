build-wordlist() {
    while read -r name path; do
        [[ -d "${path:-}" ]] && printf '%s ' "$name" || :
    done <<< $(echo ${NIX_PATH:-} | tr ':=' '\n ')
}

complete -W "$(build-wordlist | sort -u)" nix-goto
