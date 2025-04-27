{
  config,
  pkgs,
  lib,
  ...
}:

{
  virtualisation.docker.enable = true;
  users.users.h.extraGroups = [ "docker" ];
  virtualisation.docker.daemon.settings = {
    #  data-root = "/some-place/to-store-the-docker-data";
  };

  users.users.h = {
    packages = with pkgs; [
      vscode
      #(vscode-with-extensions.override {
      #  vscodeExtensions = with vscode-extensions; [
      #  jnoortheen.nix-ide
      #  llvm-vs-code-extensions.vscode-clangd
      #  ms-azuretools.vscode-docker
      #  ms-vscode-remote.remote-containers
      #  ];
      #})
    ];
  };
}
