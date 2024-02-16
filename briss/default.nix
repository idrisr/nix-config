self: super:
super.mkDerivation {
  pname = "briss";
  version = "custom";
  dontUnpack = true;
  nativeBuildInputs = [ self.makeWrapper ];

  installPhase = ''
    mkdir -p "$out/bin"
    cp ${self.briss}/bin/briss $out/bin/
    wrapProgram $out/bin/briss --set GDK_SCALE "2.0"
  '';
}
