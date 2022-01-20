{
  programs.ssh.enable = true;
  programs.ssh.forwardAgent = true;
  programs.ssh.serverAliveCountMax = 10;
  programs.ssh.serverAliveInterval = 60;
  programs.ssh.extraConfig = ''
    # re-use ssh connections
    Host *
      ControlPath ~/.ssh/control-%h-%p-%r
  '';
}
