self: super: {
  transcribe = self.writeShellApplication {
    name = "transcribe";
    runtimeInputs = with self; [ tesseract5 poppler_utils ];
    text = builtins.readFile ./transcribe.sh;
  };
}
