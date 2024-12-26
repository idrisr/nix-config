{ pkgs, ... }:

let
  wallpapers = {
    winter0 = {
      url =
        "https://www.pixelstalk.net/wp-content/uploads/2015/01/Winter-Landscape-Snow-Background.jpg";
      sha256 = "BIogp6FNN9lHNcNtgP9tdIUWLtP1EAAHJIpnNGPO7W0=";
    };

    winter1 = {
      url =
        "https://www.pixelstalk.net/wp-content/uploads/image11/Winter-HD-Desktop-Wallpaper-with-pink-winter-dawn-over-a-snowy-mountain-range.jpg";
      sha256 = "R26yTKPqV/snIifyXdB/sY0UMjDC9ziY6xMJQoOaD4M=";
    };
    spring = {
      url =
        "https://www.pixelstalk.net/wp-content/uploads/images8/Spring-Landscape-4K-Wallpaper-Free-Spring-Landscape-4K-Background.jpg";
      sha256 = "5corV3V94nPILwp0rGdwa30g5VWOT+YqXdQDSFDJOIc=";
    };
    nebula = {
      url =
        "https://www.pixelstalk.net/wp-content/uploads/images6/Hot-Aesthetically-Pleasing-Wallpaper.jpg";
      sha256 = "5UQM6kVPRusBICuaHkFofSoWd8TGV0kDv3Nn9w69hTs=";
    };
  };
  selected = "nebula";
in {
  stylix = {
    enable = true;
    image = pkgs.fetchurl wallpapers.${selected};
    base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-hard.yaml";
  };
}
