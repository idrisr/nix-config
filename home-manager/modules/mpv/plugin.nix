# { pkgs ? import <nixpkgs> { } }:

{ stdenvNoCC, fetchFromGitHub }:
stdenvNoCC.mkDerivation {
  pname = "speed-script";
  version = "0.0.0";

  src = fetchFromGitHub {
    owner = "idrisr";
    repo = "mpv-script";
    rev = "9501023b1dcad21b69999c034919ad2b2e3ffbd2";
    hash = "sha256-pCBydrHqQLwPVh8UxDmNPKbANxurtl5ET/sveMZBno4=";
  };

  phases = [ "installPhase" ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/mpv/scripts
    cp -r $src/speed-script.lua $out/share/mpv/scripts
  '';

  passthru.scriptName = "speed-script.lua";
}
