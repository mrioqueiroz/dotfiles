{ pkgs ? import (fetchTarball
  "https://github.com/NixOS/nixpkgs/archive/17b101e29dfff7ae02cdd00e8cde243d2a56472d.tar.gz")
  { } }:
let
  name = "shell";
  script = pkgs.writeScriptBin "script-name" ''
    echo "Test script";
  '';
in pkgs.mkShell {
  inherit name;
  buildInputs = with pkgs; [ script ];

  shellHook = ''
    echo "Started ${name}";
  '';
  ENVIRONMENT_VARIABLE = "envVar";
}
