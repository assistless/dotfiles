{ ... }:
{
  # firewall
  networking.firewall.allowedTCPPorts = [ 25565 19132 ];
  networking.firewall.allowedUDPPorts = [ 25565 19132 ];
  networking.firewall.enable = true;
}