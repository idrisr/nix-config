final: prev: {
  mdtopdf = final.writeShellApplication {
    name = "mdtopdf";
    runtimeInputs = with final; [ pandoc texlive.combined.scheme-full ];
    text = builtins.readFile ./mdtopdf.sh;
  };
}
