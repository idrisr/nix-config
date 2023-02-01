final: prev: {
  pdftc = final.writeShellApplication {
    name = "pdftc";

    runtimeInputs = with final; [ ripgrep pdftk ];
    text = ''
      set -e
      set -u

      pdftk "$1" dump_data_utf8 |\
          rg bookmark'(title|level)'                              |\
          sed '$!N;s/^\([^\n]*\)\n\([^\n]*\)$/\2 \1/'             |\
          sed -e 's/BookmarkLevel: //'                             \
          -e 's/BookmarkTitle: //'                                 \
          -e 's/^5 /\t\t\t\t\t/'                                   \
          -e 's/^4 /\t\t\t\t/'                                     \
          -e 's/^3 /\t\t\t/'                                       \
          -e 's/^2 /\t\t/'                                         \
          -e 's/^1 /\t/'                                           \
          -e 's/\t/    /g'                                        |\
          tr '[:upper:]' '[:lower:]'
    '';
  };
}
