pkgs:
with pkgs; [

  racket
  neomutt
  ocamlPackages.ocamlformat
  ocamlPackages.ocamlformat-rpc-lib
  zulip
  zulip-term
  slide2text
  losslesscut-bin
  mods
  # obsidian
  git-crypt
  abcde
  stylua
  alsa-utils
  ansifilter
  arandr
  aria
  asciidoc
  atool
  awscost
  bcc
  binutils
  booknote
  bpftrace
  brave
  calibre
  copyq
  cryptsetup
  dconf
  ddgr
  desktop-file-utils
  dfc # better df
  dig
  discord
  disko
  djvu2pdf
  dmenu
  dracut
  dzen2
  efibootmgr
  electrum
  epr
  ffmpeg
  fontpreview
  foremost
  gallery-dl
  gimp
  gnome-disk-utility
  gnupg
  gnuradio
  gparted
  gqrx
  graphviz
  haskellPackages.hasktags
  imagemagick
  inkscape
  inxi
  jq
  keepassxc
  killall
  lastpass-cli
  ldns
  libinput
  libreoffice
  libsForQt5.kdenlive
  light
  lmms
  lm_sensors
  lsof
  makemkv
  mathpix-snipping-tool
  mdtopdf
  mediainfo
  mplayer
  mpv
  mtr
  ncdu
  neofetch
  newcover
  nicotine-plus
  nil
  nitrogen
  nix-du
  nixfmt-classic
  nix-melt
  nixos-generators
  nixos-option
  nix-output-monitor
  nix-query-tree-viewer
  nix-tree
  nodePackages.bash-language-server
  nsxiv
  nuclear
  nvme-cli
  nwipe
  okular
  openscad
  parted
  pass
  pcmanfm
  pdftc
  pdftk
  pinentry
  pipe-rename
  pirate-get
  poppler_utils
  powerline
  powerline-fonts
  qemu
  qpdf
  qrcp
  rlwrap
  rofi-power-menu
  seder
  shellharden
  spectacle # screenshots
  sqlitebrowser
  (sqlite.override { interactive = true; })
  sshfs
  strawberry
  sxiv
  tabbed
  tcpdump
  textsnatcher
  tikzit
  timer
  tlp
  traceroute
  transcribe
  unetbootin
  unoconv
  unzip
  ventoy-full
  vorta
  weechat
  wget
  wireshark
  writedisk
  xclip
  xdotool
  xfce.thunar
  xorg.xev
  xorg.xwininfo
  xournalpp
  yt-dlp
  ytfzf
  zbar
  zip
  zotero
]
