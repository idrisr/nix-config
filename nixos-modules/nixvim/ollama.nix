{ pkgs, ... }: {
  config.programs.nixvim.plugins.ollama = {
    enable = true;
    url = "http://fft:11111";
    model = "mistral";
  };
  config = { environment.systemPackages = [ pkgs.ollama ]; };
}
