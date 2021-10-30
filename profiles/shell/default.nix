{ self, config, lib, pkgs, ... }:
{
  config = {
    environment.systemPackages = with pkgs; [
      any-nix-shell
    ];
    programs.zsh.enable = true;
    programs.zsh.autosuggestions.enable = false;
    users.defaultUserShell = pkgs.zsh;

    environment.pathsToLink = [ "/share/zsh" ];
  };
}
