# Test NixOS VMs

## VMs list

* vm     - bare bones VM
* k3s    - lightweight Kubernetes (k3s)
* xfce   - XFCE desktop

Run `nix flake show` to show outputs provided by this repository.

## Usage

* Launch VM from github
```
  nix run github:imincik/nixos-vms#<VM-NAME>

    ex.:

  nix run github:imincik/nixos-vms#xfce
```

* Launch VM from cloned source code
```
  nix run .#<VM-NAME>

    ex.:

  nix run .#xfce
```

### Passwords

* `root` : root
* `test` : test
