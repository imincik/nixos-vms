{ pkgs, ... }:

{
  imports = [
    ../../modules/nixos/common.nix
  ];

  networking.firewall.allowedTCPPorts = [
    6443
  ];

  services.k3s = {
    enable = true;
    role = "server";
  };

  environment.systemPackages = with pkgs; [
    k3s
  ];
}
