{ ... }:
{
  services.immich = {
    enable = true;
    port = 2283;
    host = "0.0.0.0";
    openFirewall = true;
    mediaLocation = "/server/media/pictures/immich";
    accelerationDevices = null;
  };
  users.users.immich.extraGroups = [ "video" "render" ];
}