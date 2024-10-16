{ config, pkgs, lib, ... }:

# sudo apt install 
# build-essential git ninja-build cmake texinfo libgmp-dev libmpfr-dev libmpc-dev wget 
# python3 python3-pip python3-venv pkg-config libglib2.0-dev libpixman-1-dev libexpat1-dev libncurses5-dev bison flex curl
let
	pkgs-24 = import <nixos-24.05> {};
in {
  environment.systemPackages = with pkgs; [
    binutils
    bison
    cmake
    curl
    expat       # libexpat1-dev
    flex
    gcc         # build-essential
    git
    gmp         # libgmp-dev
    libglibutil # libglib2.0-dev
    libmpc      # libmpc-dev 
    mpfr        # libmpfr-dev
    ncurses     # libncurses5-dev
    ninja
    pixman      # libpixman-1-dev 
    pkg-config
    python3
    #texinfo
    wget
	];

	#users.users.h.packages = with pkgs; [];
}