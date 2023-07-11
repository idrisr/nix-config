{ pkgs, ... }:
with pkgs; {
  screen-config =
    runCommand "leftonly" { nativeBuildInputs = [ makeWrapper ]; } ''
      mkdir -p $out/bin

      cp "${./laptop.sh}" laptop.sh
      chmod +x laptop.sh
      patchShebangs laptop.sh
      mv ./laptop.sh $out/bin
      wrapProgram $out/bin/laptop.sh --set PATH ${
        lib.makeBinPath [ xorg.xrandr ]
      }

      cp "${./left-only.sh}" left-only.sh
      chmod +x left-only.sh
      patchShebangs left-only.sh
      mv ./left-only.sh $out/bin
      wrapProgram $out/bin/left-only.sh --set PATH ${
        lib.makeBinPath [ xorg.xrandr ]
      }

      cp "${./left-and-laptop.sh}" left-and-laptop.sh
      chmod +x left-and-laptop.sh
      patchShebangs left-and-laptop.sh
      mv ./left-and-laptop.sh $out/bin
      wrapProgram $out/bin/left-and-laptop.sh --set PATH ${
        lib.makeBinPath [ xorg.xrandr ]
      }
    '';
}
