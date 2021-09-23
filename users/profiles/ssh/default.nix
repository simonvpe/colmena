{
  programs.ssh.enable = true;
  programs.ssh.forwardAgent = true;
  programs.ssh.serverAliveCountMax = 10;
  programs.ssh.serverAliveInterval = 60;
}
