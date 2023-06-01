final: prev: {
  booknote = final.writeShellApplication {
    name = "booknote";

    runtimeInputs = with final; [ pdftc ];
    text = builtins.readFile ./booknote.sh;
  };
}
