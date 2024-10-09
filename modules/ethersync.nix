{ config, pkgs, lib, ... }:

let
  ethersync = builtins.fetchTarball {
    url = "https://github.com/ethersync/ethersync/archive/refs/tags/v0.5.0.tar.gz";
    sha256 = "1jvsdcc53hz476jfm9rrm5ayd0r66asx5lvl6lg9fzjabw0dcvy8";
  };
in {
  environment.systemPackages = with pkgs; [
    # Other packages...
    ethersync
  ];
}
