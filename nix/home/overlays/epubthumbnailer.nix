final: prev: {
  # buildPythonApplication?
  epubthumb = final.writeShellApplication {
    name = "epubthumb";

    runtimeInputs = [
      (prev.pkgs.python39.withPackages
        (pythonPackages: with pythonPackages; [ pillow ]))
    ];

    text = ''
      python ${./epubthumbnailer.py} "$@"
    '';
  };
}
