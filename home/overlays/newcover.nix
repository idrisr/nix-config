final: prev: {
  newcover = final.writeShellApplication {
    name = "newcover";

    runtimeInputs = with final; [ wget dimensions pdftk imagemagick ];
    text = builtins.readFile ./newcover.sh;
  };
}
