{
  lib,
  nimPackages,
}:
nimPackages.buildNimPackage {
  pname = "flakestrap";
  version = "0.1.0";

  src = ../.;

  meta = {
    description = "A simple tool to bootstrap a flake-based NixOS configuration";
    license = [lib.licenses.mit];
    maintainers = [lib.maintainers.adamcstephens];
  };
}
