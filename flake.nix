{
  description = "Flake for mre_naersk";

  inputs = rec {
    naersk = {
      url = "github:nmattia/naersk";
      inputs.nixpkgs = nixpkgs;
    };
    flakeUtils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixpkgsMoz = {
      url = "github:mozilla/nixpkgs-mozilla";
      flake = false;
    };
  };

  outputs = inputs: with inputs;
    with flakeUtils.lib;
    eachSystem defaultSystems (system:
      let
        common = import ./nix/common.nix {
          sources = { inherit naersk nixpkgs nixpkgsMoz; };
          inherit system;
        };
      in
      rec {
        packages = {
          "mre_naersk" = import ./nix/build.nix { inherit common; };
          "mre_naersk-debug" = import ./nix/build.nix { inherit common; release = false; };
        };
        defaultPackage = packages."mre_naersk";

        apps = builtins.mapAttrs (n: v: mkApp { name = n; drv = v; exePath = "/bin/mre_naersk"; }) packages;
        defaultApp = apps."mre_naersk";

        devShell = import ./nix/devShell.nix { inherit common; };
      }
    );
}
