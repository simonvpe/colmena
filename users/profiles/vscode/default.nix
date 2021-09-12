{ pkgs, ... }:
{
  config.programs.vscode.enable = true;
  config.programs.vscode.package = pkgs.vscode-fhs;
}
