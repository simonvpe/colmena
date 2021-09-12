{
  #networking.wireguard.interfaces.wg0.ips = wg-ips;
  # To match firewall allowedUDPPorts (without this wg uses random port numbers).
  networking.firewall.allowedUDPPorts = [ 51820 ];
  networking.wireguard.interfaces.wg0.listenPort = 51820;
  # Key file stored locally on each machine, this has to be manually created.
  networking.wireguard.interfaces.wg0.privateKeyFile = "/etc/wireguard-keys/private";
  # For a client configuration, one peer entry for the server will suffice.
  networking.wireguard.interfaces.wg0.peers = [
    {
      # Public key of the server.
      publicKey = "dZH9BuC/1iVguJ+Fz0+vTc0NXklLkBGX00laM4TEJHE=";
      # Forward only this subnet via VPN.
      allowedIPs = [
        "10.200.0.0/22"
        "172.16.32.0/24"
        "172.16.33.0/24"
      ];
      # This is the server.
      endpoint = "109.104.14.127:51820";
      # Send keepalives every 25 seconds to keep NAT tables alive.
      persistentKeepalive = 25;
    }
  ];
}
