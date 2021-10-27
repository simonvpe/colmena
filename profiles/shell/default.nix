{ self, config, lib, pkgs, ... }:
{
  config = {
    environment.systemPackages = with pkgs; [
      any-nix-shell
    ];
    programs.zsh.enable = true;
    programs.zsh.autosuggestions.enable = true;
    programs.zsh.promptInit = ''
      any-nix-shell zsh --info-right | source /dev/stdin
    '';
    users.defaultUserShell = pkgs.zsh;

    environment.pathsToLink = [ "/share/zsh" ];
  };
}
