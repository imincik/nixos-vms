{
  description = "Simple NixOS VMs";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nixpkgs, flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } ({ withSystem, ... }:
      let
        nixosSystemFor = system: module:
          nixpkgs.lib.nixosSystem {
            inherit system;
            pkgs = withSystem system ({ pkgs, ... }: pkgs);
            modules = [ module ];
          };

        vmApp = name: {
          type = "app";
          program = "${self.nixosConfigurations.${name}.config.system.build.vm}/bin/run-nixos-vm";
        };

      in
      {
        systems = [ "x86_64-linux" ];

        flake = {
          nixosModules = {
            vm = ./modules/nixos/vm;
            k3s = ./modules/nixos/k3s;
            xfce = ./modules/nixos/xfce;
          };

          nixosConfigurations = {
            vm = nixosSystemFor "x86_64-linux" self.nixosModules.vm;
            k3s = nixosSystemFor "x86_64-linux" self.nixosModules.k3s;
            xfce = nixosSystemFor "x86_64-linux" self.nixosModules.xfce;
          };
        };

        perSystem = { ... }: {
          apps = {
            vm = vmApp "vm";
            k3s = vmApp "k3s";
            xfce = vmApp "xfce";
          };
        };
      });
}
