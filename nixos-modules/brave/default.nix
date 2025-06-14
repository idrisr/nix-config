_: prev: {
  brave = prev.stdenvNoCC.mkDerivation {
    pname = "brave";
    name = "brave";
    dontUnpack = true;
    nativeBuildInputs = [ prev.makeWrapper ];

    installPhase = ''
      mkdir -p "$out/bin"
      cp ${prev.brave}/bin/brave $out/bin/
      wrapProgram $out/bin/brave --add-flags "--password-store=basic" --add-flags "--disable-features=PasswordManager"
    '';
  };
}
