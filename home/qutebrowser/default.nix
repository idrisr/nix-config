# https://github.com/IvarWithoutBones/dotfiles/blob/b6074cf26ed70bf3d10d36b3e0122ef6cfbc5f81/home-manager/modules/qutebrowser.nix
{ config, ... }: {
  config = {
    programs.qutebrowser = {
      enable = true;
      keyBindings = { normal = { "cm" = "clear-messages"; }; };

      settings = {
        colors.webpage.preferred_color_scheme = config.theme.color;
        downloads.location.directory = "$HOME/downloads";
        zoom.default = "200%";
        statusbar.position = "top";
        fonts.default_size = "12pt";

        content = {
          javascript.can_access_clipboard = true;
          autoplay = false;
        };

        url = {
          start_pages = "https://duckduckgo.com";
          default_page = "https://duckduckgo.com";
        };
      };

      searchEngines = {
        DEFAULT = "https://duckduckgo.com/?q={}";
        aa = "https://annas-archive.org/search?q={}";
        amz = "https://www.amazon.com/s?k={}&i=stripbooks";
        c = "https://cplusplus.com/search.do?q={}";
        cpl = "https://chipublib.bibliocommons.com/v2/search?query={}";
        git = "https://github.com/search?q={}";
        ho = "https://hoogle.haskell.org/?hoogle={}";
        hm = "https://mipmip.github.io/home-manager-option-search/?{}";
        mdn = "https://developer.mozilla.org/en-US/search?q={}";
        nx = "https://search.nixos.org/packages?query={}&channel=unstable";
        nixpkgs-issues =
          "https://github.com/NixOS/nixpkgs/issues?q=is%3Aopen+{}";
        nixpkgs-prs = "https://github.com/NixOS/nixpkgs/pulls?q=is%3Aopen+{}";
        npl =
          "https://encore.naperville-lib.org/iii/encore/search/C__S{}__Orightresult__U?lang=eng";
        repology = "https://repology.org/projects/?search={}";
        yt = "https://www.youtube.com/results?search_query={}";
      };

      quickmarks = {
        cppreference = "https://en.cppreference.com/w/cpp";
        home-manager = "https://github.com/nix-community/home-manager";
        nix-manual = "https://nixos.org/manual/nix/unstable";
        nixos-manual = "https://nixos.org/nixos/manual";
        nixpkgs = "https://github.com/NixOS/nixpkgs";
        nixpkgs-manual = "https://nixos.org/manual/nixpkgs/unstable";
        youtube = "https://www.youtube.com/";
        zh = "https://zerohedge.com/";
      };
    };
  };
}
