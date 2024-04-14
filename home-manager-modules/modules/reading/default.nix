self: super: {
  books = super.writeShellApplication {
    name = "books";
    runtimeInputs = with self; [ rofi zathura ];
    text = builtins.readFile ./filelist.sh;
  };
}
