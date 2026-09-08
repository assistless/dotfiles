{ ... }:
{
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
    publish = {
      enable = true;
      addresses = true;
      workstation = true;
    };
    extraConfig = ''
      [server]
      use-ipv6=no
    '';
  };
}
