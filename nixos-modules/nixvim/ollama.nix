{ pkgs, ... }: {
  config.programs.nixvim.plugins.ollama = {
    enable = false;
    url = "http://fft:11111";
    model = "mistral";

    prompts = {
      mathproof = {
        prompt = ''
          Provide feedback on this written solution to a math problem--- $sel. You'll find
          the problem statement towards the beginning. It might be a math proof,
          it might be someting looser.
          Consider feedback on
          the presentation,
          the english prose
          the latex macros used,
          as well as the correctness of the proof itself'';
        model = "mistral";
        inputLabel = "> ";
      };
    };
  };
  config = { environment.systemPackages = [ pkgs.ollama ]; };
}
