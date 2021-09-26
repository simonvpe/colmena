{
  config = {
    security.pam.enableSSHAgentAuth = true;
    security.pam.services.login.sshAgentAuth = true;
  };
}
