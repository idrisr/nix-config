self: super: {
  xournalpp = super.stdenv.mkDerivation {
    name = "xournal";
    dontUnpack = true;
    nativeBuildInputs = [ super.makeWrapper super.texliveFull ];

    installPhase = ''
      mkdir -p "$out/bin"
      cp ${super.xournalpp}/bin/xournalpp $out/bin/
      wrapProgram $out/bin/xournalpp --prefix PATH : ${super.texliveFull}/bin/;
    '';
  };
}
