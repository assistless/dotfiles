{ ... }:
{
  # user
  users.users.demi = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "input" ];
    # packages = with pkgs; [];
  };
}