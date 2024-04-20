self: super: {
  xournalpp-wrapped = super.stdenvNoCC.mkDerivation {
    name = "xournal";
    dontUnpack = true;
    nativeBuildInputs = [ super.makeWrapper super.texliveFull ];

    installPhase = ''
      mkdir -p "$out/bin"
      cp ${super.xournalpp}/bin/xournalpp $out/bin/
      wrapProgram $out/bin/xournalpp --prefix PATH : ${super.texliveFull}/bin/;
    '';
  };

  xournalpp = super.symlinkJoin {
    name = "xournalpp-custom";
    paths = [ self.xournalpp-wrapped super.xournalpp ];
  };
}
