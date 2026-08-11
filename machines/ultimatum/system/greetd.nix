{ pkgs , ... }:
{
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.sway}/bin/sway --config /etc/greetd/sway-config";
        user = "greeter";
      };
    };
  };
}
