{ pkgs }:
pkgs.writeTextFile {
  name = "wifi-bssid-monitor-parser";
  destination = "/bin/wifi-bssid-monitor-parser";
  executable = true;
  text = ''
    #!${pkgs.python3}/bin/python3
    ${builtins.readFile ./parser.py}
  '';
}
