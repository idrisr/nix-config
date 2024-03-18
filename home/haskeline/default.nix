{ lib, ... }:
with lib;
let
  relToDotDir = file: ("/." + file);
  haskeline = builtins.readFile ./haskeline;
in {
  config =
    (mkMerge [{ home.file."${relToDotDir "haskeline"}".text = haskeline; }]);
}
