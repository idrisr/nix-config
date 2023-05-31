final: prev: {
  seder = final.writeShellApplication {
    name = "seder";
    runtimeInputs = with final; [ pdftk ];
    text = builtins.readFile ./seder.sh;
  };
}
