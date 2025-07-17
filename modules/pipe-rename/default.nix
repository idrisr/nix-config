_: prev: {
  pipe-rename = prev.stdenvNoCC.mkDerivation {
    pname = "pipe-renamer";
    name = "pipe-renamer";
    dontUnpack = true;
    nativeBuildInputs = [ prev.makeWrapper ];

    installPhase = ''
      mkdir -p "$out/bin"
      cp ${prev.qrcp}/bin/qrcp $out/bin/
      wrapProgram $out/bin/qrcp --add-flags "--port ${port}"
    '';
  };
}
