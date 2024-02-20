port: self: super: {
  qrcp = super.stdenv.mkDerivation {
    pname = "qrcp";
    name = "qrcp";
    dontUnpack = true;
    nativeBuildInputs = [ super.makeWrapper ];

    installPhase = ''
      mkdir -p "$out/bin"
      cp ${super.qrcp}/bin/qrcp $out/bin/
      wrapProgram $out/bin/qrcp --add-flags "--port ${port}"
    '';
  };
}
