final: prev: {
  roamamer = final.writeShellApplication {
    name = "roamamer";

    runtimeInputs = with final; [ git ];
    text = builtins.readFile ./roamamer.sh;
  };
}
