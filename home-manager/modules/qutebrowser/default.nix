# https://github.com/IvarWithoutBones/dotfiles/blob/b6074cf26ed70bf3d10d36b3e0122ef6cfbc5f81/home-manager/modules/qutebrowser.nix
{
  config = {
    programs.qutebrowser = {
      enable = true;
      keyBindings = { normal = { "cm" = "clear-messages"; }; };

      settings = {
        downloads.location.directory = "$HOME/downloads";
        zoom.default = "75%";
        statusbar.position = "top";
        fonts.default_size = "12pt";

        completion.web_history.max_items = 10000;
        completion.cmd_history_max_items = 10000;

        auto_save.session = true;

        content = {
          javascript = { enabled = true; };

          autoplay = false;
          canvas_reading = false;
          geolocation = false;
          webrtc_ip_handling_policy = "default-public-interface-only";
          webgl = false;
        };

        url = {
          start_pages = "https://search.brave.com/";
          default_page = "https://search.brave.com/";
        };
      };

      searchEngines = {
        # DEFAULT = "https://kagi.com/search?q={}";
        DEFAULT = "https://search.brave.com/search?q={}";
        d3 = "https://duckduckgo.com/?q=site%3Ad3js.org+{}";
        dd = "https://duckduckgo.com/?q={}";
        aa = "https://annas-archive.org/search?q={}";
        am = "https://www.amazon.com/s?k={}";
        amz = "https://www.amazon.com/s?k={}&i=stripbooks";
        cpl = "https://chipublib.bibliocommons.com/v2/search?query={}";
        ho = "https://hoogle.haskell.org/?hoogle={}";
        hoe = "https://hoogle.haskell.org/?hoogle={}%20is%3Aexact";
        hm =
          "https://home-manager-options.extranix.com/?query={}&release=master";
        mdn = "https://developer.mozilla.org/en-US/search?q={}";
        np = "https://search.nixos.org/packages?query={}&channel=unstable";
        no = "https://search.nixos.org/options?query={}&channel=unstable";
        nog = "https://noogle.dev/q?term={}";
        npl =
          "https://encore.naperville-lib.org/iii/encore/search/C__S{}__Orightresult__U?lang=eng";
        yt = "https://www.youtube.com/results?search_query={}";
      };

      quickmarks = {
        cppreference = "https://en.cppreference.com/w/cpp";
        home-manager = "https://github.com/nix-community/home-manager";
        nix-manual = "https://nixos.org/manual/nix/unstable";
        nixos-manual = "https://nixos.org/nixos/manual";
        nixpkgs = "https://github.com/NixOS/nixpkgs";
        nixpkgs-manual = "https://nixos.org/manual/nixpkgs/unstable";
        zh = "https://zerohedge.com/";
      };
    };
  };
}
