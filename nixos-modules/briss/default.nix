_: prev: {
  briss = prev.stdenvNoCC.mkDerivation {
    pname = "briss";
    name = "briss";
    dontUnpack = true;
    nativeBuildInputs = [ prev.makeWrapper ];

    installPhase = ''
      mkdir -p "$out/bin"
      cp ${prev.briss}/bin/briss $out/bin/
      wrapProgram $out/bin/briss --set GDK_SCALE "2.0"
    '';
  };
}
