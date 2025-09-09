{
  config,
  ...
}:

{
  service.thelounge = {
    enable = true;
    public = true;
    port = 9000;
    #plugins = ;
    #extraConfig;
  };
}
