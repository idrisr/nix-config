_: prev: {
  kdenlive = prev.stdenvNoCC.mkDerivation {
    pname = "kdenlive";
    name = "kdenlive";
    dontUnpack = true;
    nativeBuildInputs = [ prev.makeWrapper ];

    installPhase = ''
      mkdir -p "$out/bin"
      cp ${prev.kdePackages.kdenlive}/bin/kdenlive $out/bin/
      wrapProgram $out/bin/kdenlive --set QT_SCALE_FACTOR 0.75
    '';
  };
}
