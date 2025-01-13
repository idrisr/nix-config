# TODO: make this a home manager module
port: _: prev: {
  qrcp = prev.stdenvNoCC.mkDerivation {
    pname = "qrcp";
    name = "qrcp";
    dontUnpack = true;
    nativeBuildInputs = [ prev.makeWrapper ];

    installPhase = ''
      mkdir -p "$out/bin"
      cp ${prev.qrcp}/bin/qrcp $out/bin/
      wrapProgram $out/bin/qrcp --add-flags "--port ${port}"
    '';
  };
}
