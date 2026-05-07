{ lib, stdenvNoCC, fetchFromGitHub }:

stdenvNoCC.mkDerivation rec {
  pname = "tar1090";
  version = "unstable-2026-05-03";

  src = fetchFromGitHub {
    owner = "wiedehopf";
    repo = "tar1090";
    rev = "master";
    hash = "sha256-KYXn9TsbifqapJCPYxOgMvm/KvzltcAUsm1VxySMCoU=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/share/tar1090"
    cp -r html nginx-readsb-api.conf LICENSE README.md "$out/share/tar1090/"

    cat > "$out/share/tar1090/html/config.js" <<'EOF'
routeApiUrl = "https://adsb.im/api/0/routeset";
routeApi = true;
routeDisplay = "icao";
EOF

    runHook postInstall
  '';

  meta = with lib; {
    description = "Web interface for ADS-B decoders like readsb";
    homepage = "https://github.com/wiedehopf/tar1090";
    license = licenses.gpl3Plus;
    platforms = platforms.all;
  };
}
