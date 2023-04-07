{ pkgs, ... }: {
  programs.gh = {
    enable = true;
    extensions = with pkgs; [ gh-eco gh-dash ];
  };
}
