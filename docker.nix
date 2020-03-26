# to use this:
# > nix-build docker.nix -o result-docker
# > docker load --input ./result-docker
# > docker run -p 8000:8000 ob-test

{ nixpkgs ? import <nixpkgs> {} }:
let
  exe = (import ./. {}).exe;
in
 nixpkgs.pkgs.dockerTools.buildImage {
    name = "obelisk-reflex-servant-example";
    contents = exe;
    config = {
      Cmd = [ "${exe}/backend" ];
      ExposedPorts = {
        "8000/tcp" = {};
      };
    };
 }