{
  description = "Flake for mre_naersk";

  inputs = {
    naerskSrc = {
      url = "github:nmattia/naersk";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flakeUtils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  };

  outputs = inputs: with inputs;
    with flakeUtils.lib;
    eachSystem [ "x86_64-linux" ] (system:
      let
        pkgs = import nixpkgs { inherit system; };
        naersk = pkgs.callPackage naerskSrc { };
        packages = {
          mre_naersk = naersk.buildPackage {
            root = ./.;
            override = _: {
              PROTOC = "${pkgs.protobuf}/bin/protoc";
              PROTOC_INCLUDE = "${pkgs.protobuf}/include";
            };
            overrideMain = _: {
              PROTOC = "${pkgs.protobuf}/bin/protoc";
              PROTOC_INCLUDE = "${pkgs.protobuf}/include";
            };
          };
        };
      in
      {
        inherit packages;
        defaultPackage = packages.mre_naersk;
        devShell = with pkgs; mkShell {
          nativeBuildInputs = [ rustc cargo protobuf ];
          shellHook = ''
            export PROTOC="${protobuf}/bin/protoc";
            export PROTOC_INCLUDE="${protobuf}/include";
          '';
        };
      }
    );
}
