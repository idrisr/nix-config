{ ... }: {
  config = {
    services.locate = {
      enable = true;
      interval = "hourly";
    };
  };
}
