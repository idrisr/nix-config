final: prev: {
  transcribe = final.writeShellApplication {
    name = "transcribe";
    runtimeInputs = with final; [ tesseract5 poppler_utils ];
    text = builtins.readFile ./transcribe.sh;
  };
}
