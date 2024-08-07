{ pkgs ? import <inxpkgs> { }, wlroots_master_src ? null , nix-filter }:
let
  mkDate = longDate: (pkgs.lib.concatStringsSep "-" [
    (builtins.substring 0 4 longDate)
    (builtins.substring 4 2 longDate)
    (builtins.substring 6 2 longDate)
  ]);

  wlroots_0_18 = pkgs.wlroots_0_17.overrideAttrs (
    old: {
      version = "0.18.0";
      src = pkgs.fetchFromGitLab {
        domain = "gitlab.freedesktop.org";
        owner = "wlroots";
        repo = "wlroots";
        rev = "0.18.0";
        hash = "sha256-LiRnvu7qCbfSg+ONWVCtWwdzxxFZHfbgmy7zApCIW40=";
      };
      patches = [];
      buildInputs = old.buildInputs ++ (with pkgs; [ 
        lcms
      ]);
    }
  );

in
rec {
  qwlroots-qt6 = pkgs.qt6.callPackage ./nix {
    inherit nix-filter;
    wlroots = pkgs.wlroots_0_17;
  };
  
  qwlroots-qt5 = pkgs.libsForQt5.callPackage ./nix {
    inherit nix-filter;
    wlroots = pkgs.wlroots_0_17;
  };

  #qwlroots-qt6-wlroots-master = qwlroots-qt6.override {
  #  wlroots = wlroots_0_18;
  #};

  qwlroots-qt6-dbg = qwlroots-qt6.override {
    stdenv = pkgs.stdenvAdapters.keepDebugInfo pkgs.stdenv;
  };

  qwlroots-qt6-clang = qwlroots-qt6.override {
    stdenv = pkgs.clangStdenv;
  };

  default = qwlroots-qt6;
}
