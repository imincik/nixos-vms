{ lib, pkgs, ... }:

{
  imports = [
    ../../modules/nixos/common.nix
  ];

  virtualisation = {
    graphics = lib.mkForce true;
    resolution = lib.mkForce {
      x = 1600;
      y = 900;
    };
  };

  services.xserver = {
    enable = true;
    displayManager.autoLogin.user = "test";
    desktopManager.xfce.enable = true;
  };

  environment.systemPackages = with pkgs; [
    firefox
  ];
}
