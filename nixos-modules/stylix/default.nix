{ pkgs, ... }: {
  stylix = {
    enable = true;
    image = pkgs.fetchurl {
      # url = "https://www.pixelstalk.net/wp-content/uploads/image11/Winter-HD-Desktop-Wallpaper-with-pink-winter-dawn-over-a-snowy-mountain-range.jpg";
      # sha256 = "R26yTKPqV/snIifyXdB/sY0UMjDC9ziY6xMJQoOaD4M=";
      url =
        "https://www.pixelstalk.net/wp-content/uploads/2015/01/Winter-Landscape-Snow-Background.jpg";
      sha256 = "BIogp6FNN9lHNcNtgP9tdIUWLtP1EAAHJIpnNGPO7W0=";
    };

    base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-hard.yaml";
  };
}
