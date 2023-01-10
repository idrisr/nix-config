self: super: {
  epubthumb = self.writeShellApplication {
    name = "epubthumb";

    runtimeInputs = [
      (super.pkgs.python39.withPackages
        (pythonPackages: with pythonPackages; [ pillow ]))
    ];

    text = ''
      python ${./epubthumbnailer.py} "$@"
    '';
  };
}
