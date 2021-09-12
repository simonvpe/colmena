{ self, ... }:
# recommend using `hashedPassword`
{
  age = {
    sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
    secrets = {
      "root/ssh.config" = {
        file = "${self}/secrets/root/ssh.config.age";
        owner = "root";
        group = "users";
        mode = "0440";
      };
    };
  };

  users.users.root.hashedPassword = "$6$WjQs8n.Ibo$y7lNx0OBkJi2O2gTO64BHbLfhsHIbXz3xOq0qbBuzUmVZRRVimyR7xJ0oQDGh0QgS0nWo/Iud4GTrUaFyHfOd/";
}
