{ pkgs, ... }: {
  stylix = {
    enable = true;
    image = pkgs.fetchurl {
      url =
        # "https://www.pixelstalk.net/wp-content/uploads/2016/05/Epic-Anime-Awesome-Wallpapers.jpg";
        "https://www.pixelstalk.net/wp-content/uploads/image11/Winter-HD-Desktop-Wallpaper-with-pink-winter-dawn-over-a-snowy-mountain-range.jpg";
      sha256 = "R26yTKPqV/snIifyXdB/sY0UMjDC9ziY6xMJQoOaD4M=";
    };

    base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-hard.yaml";
  };
}
