{
  config.programs.nixvim.plugins = {
    avante = {
      enable = true;
      settings = {
        behaviour = { enable_token_counting = false; };
        openai = { model = "gpt-4o-mini"; };
        provider = "openai";
        claude = {
          endpoint = "https://api.anthropic.com";
          max_tokens = 4096;
          model = "claude-3-5-sonnet-20240620";
          temperature = 0;
        };
        diff = {
          autojump = true;
          debug = false;
          list_opener = "copen";
        };
        highlights = {
          diff = {
            current = "DiffText";
            incoming = "DiffAdd";
          };
        };
        hints = { enabled = true; };
        mappings = {
          diff = {
            both = "cb";
            next = "]x";
            none = "c0";
            ours = "co";
            prev = "[x";
            theirs = "ct";
          };
        };
        windows = {
          sidebar_header = {
            align = "right";
            rounded = true;
          };
          width = 50;
          wrap = true;
        };
      };
    };
  };
}
