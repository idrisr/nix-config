self: super: {
  tikzit-wrapped = super.stdenvNoCC.mkDerivation {
    name = "tikzit";
    dontUnpack = true;
    nativeBuildInputs = [ super.makeWrapper super.texliveFull ];

    installPhase = ''
      mkdir -p "$out/bin"
      cp ${super.tikzit}/bin/tikzit $out/bin/
      wrapProgram $out/bin/tikzit --prefix PATH : ${super.texliveFull}/bin/;
    '';
  };

  tikzit = super.symlinkJoin {
    name = "tikzit-cust";
    paths = [ self.tikzit-wrapped super.tikzit ];
  };
}
