{
  config.services.avahi = {
    enable = true;
    publish = {
      userServices = true;
      hinfo = true;
      enable = true;
      domain = true;
      addresses = true;
    };
  };
}
