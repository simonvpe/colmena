{
  programs.ssh.extraConfig = ''
    CanonicalizeHostname yes
    CanonicalDomains cybernet
    CanonicalizeMaxDots 1
    CanonicalizeFallbackLocal yes
  '';
}
