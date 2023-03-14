{ pkgs ? import <nixpkgs> {} }:
(pkgs.buildFHSUserEnv {
  name = "pipzone";
  targetPkgs = pkgs: (with pkgs; [
    python310
    python310Packages.pip
    python310Packages.virtualenv
    python310Packages.numpy
    zlib
  ]);
  runScript = ''
    argv=.venv/bin/activate.fish fish -c "source"
  '';
}).env
