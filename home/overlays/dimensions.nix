final: prev: {
  dimensions = final.writeShellApplication {
    name = "dimensions";

    runtimeInputs = with final; [ pdftk ripgrep ];
    text = builtins.readFile ./dimensions.sh;
  };
}
