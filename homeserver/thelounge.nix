{
  config,
  ...
}:

{
  services.thelounge = {
    enable = true;
    public = true;
    port = 9000;
  };
}
