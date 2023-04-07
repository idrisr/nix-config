final: prev: {
  pdftc = final.writeShellApplication {
    name = "pdftc";

    runtimeInputs = with final; [ ripgrep pdftk ];
    text = ''
      set -e
      set -u

      pdftk "$1" dump_data_utf8 |\
          rg --text bookmark'(title|level)'                       |\
          sed '$!N;s/^\([^\n]*\)\n\([^\n]*\)$/\2 \1/'             |\
          sed -r -e 's/BookmarkLevel: //'                          \
          -e 's/BookmarkTitle: //'                                 \
          -e 's/^6 /\t\t\t\t\t\t/'                                 \
          -e 's/^5 /\t\t\t\t\t/'                                   \
          -e 's/^4 /\t\t\t\t/'                                     \
          -e 's/^3 /\t\t\t/'                                       \
          -e 's/^2 /\t\t/'                                         \
          -e 's/^1 /\t/'                                           \
          -e 's/^\s+([0-9]+\.){6}[0-9]+\s/\t\t\t\t\t\t\t\t/'       \
          -e 's/^\s+([0-9]+\.){5}[0-9]+\s/\t\t\t\t\t\t\t/'         \
          -e 's/^\s+([0-9]+\.){4}[0-9]+\s/\t\t\t\t\t\t/'           \
          -e 's/^\s+([0-9]+\.){3}[0-9]+\s/\\tt\t\t\t/'             \
          -e 's/^\s+([0-9]+\.){2}[0-9]+\s/\t\t\t/'                 \
          -e 's/^\s+([0-9]+\.){1}[0-9]+\s/\t\t/'                   \
          -e 's/\t/    /g'                                        |\
          tr '[:upper:]' '[:lower:]'
    '';
  };
}
