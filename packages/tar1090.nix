{ lib, stdenvNoCC, fetchFromGitHub }:

stdenvNoCC.mkDerivation rec {
  pname = "tar1090";
  version = "unstable-2026-07-23";

  src = fetchFromGitHub {
    owner = "wiedehopf";
    repo = "tar1090";
    rev = "9508b4e1dd2400039b76c971880eebdd89cacc61";
    hash = "sha256-AtL8rXxOtX+YmpmO88pfCOcAzu5Yqvha8cqaHPJ0j1c=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/share/tar1090"
    cp -r html nginx-readsb-api.conf LICENSE README.md "$out/share/tar1090/"

    printf '%s\n' \
      'routeApiUrl = "https://adsb.im/api/0/routeset";' \
      'routeApi = true;' \
      'routeDisplay = "icao";' \
      > "$out/share/tar1090/html/config.js"

    runHook postInstall
  '';

  meta = with lib; {
    description = "Web interface for ADS-B decoders like readsb";
    homepage = "https://github.com/wiedehopf/tar1090";
    license = licenses.gpl3Plus;
    platforms = platforms.all;
  };
}
