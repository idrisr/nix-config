{ rofi, writeShellApplication, zathura }:

writeShellApplication {
  name = "books";
  runtimeInputs = [ rofi zathura ];
  text = builtins.readFile ./filelist.sh;
}
