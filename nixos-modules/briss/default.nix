self: super: {
  briss = super.stdenvNoCC.mkDerivation {
    pname = "briss";
    name = "briss";
    dontUnpack = true;
    nativeBuildInputs = [ super.makeWrapper ];

    installPhase = ''
      mkdir -p "$out/bin"
      cp ${super.briss}/bin/briss $out/bin/
      wrapProgram $out/bin/briss --set GDK_SCALE "2.0"
    '';
  };
}
