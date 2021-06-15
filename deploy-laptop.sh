#!/usr/bin/env bash
nix-shell -p nixUnstable --run "sudo nix --option experimental-features 'nix-command flakes' build .#nixosConfigurations.laptop.config.system.build.toplevel"
nixos-install --system result
