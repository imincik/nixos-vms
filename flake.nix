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
        nixosSystemFor = system: host:
          nixpkgs.lib.nixosSystem {
            inherit system;
            pkgs = withSystem system ({ pkgs, ... }: pkgs);
            modules = [ host ];
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
            common = ./modules/nixos/common.nix;
          };

          nixosConfigurations = {
            vm = nixosSystemFor "x86_64-linux" ./hosts/vm;
            k3s = nixosSystemFor "x86_64-linux" ./hosts/k3s;
            xfce = nixosSystemFor "x86_64-linux" ./hosts/xfce;
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
