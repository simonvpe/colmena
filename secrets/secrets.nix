let
  # set ssh public keys here for your system and user
  laptop = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIERtFMJeJ6uI9AKoPvrYMx0edu3c0a7KMI9F8fVe+zyX root@hyperactivitydrive";
  starlord = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFj4hF3gCgGkoRwfURZOI7wUY/HM/C404Vv7zxmNNlMX simon@thesourcerer.se";
  neti = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBl0x0lHyufCLVvRnyXoNQ+yokV+EwKFn+qkGpELGdo1 neti@hyperactivitydrive";
  system = [ laptop ];
  users = [ starlord neti ];
  allKeys = system ++ users;
in
{
  "root/ssh.config.age".publicKeys = system;

  "starlord/ssh.config.age".publicKeys = [ starlord ];
  "starlord/bw.password.age".publicKeys = [ starlord ];

  "neti/vpn.config.age".publicKeys = [ neti ];
  "neti/ssh.config.age".publicKeys = [ neti ];
  "neti/id_ed25519.neti.age".publicKeys = [ neti ];
  "neti/id_ed25519.neti.pub.age".publicKeys = [ neti ];
  "neti/id_ed25519.pass.age".publicKeys = [ neti ];
}
